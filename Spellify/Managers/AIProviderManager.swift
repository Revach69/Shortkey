//
//  AIProviderManager.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
import Combine

/// Manages the active AI provider and its connection state
final class AIProviderManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var status: ConnectionStatus = .notConfigured
    @Published private(set) var availableModels: [AIModel] = []
    @Published var selectedModel: AIModel = .defaultModel
    
    // MARK: - Private Properties
    
    private var provider: AIModelProvider
    private let defaults: UserDefaults
    private let selectedModelKey = "spellify.selectedModel"
    
    // Reusable encoder/decoder for performance
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    // MARK: - Constants
    
    static let maxTextLength = 10_000
    
    // MARK: - Helpers
    
    private func friendlyErrorMessage(from error: Error) -> String {
        let errorDescription = error.localizedDescription.lowercased()
        
        if errorDescription.contains("internet") || errorDescription.contains("offline") {
            return Strings.Common.noInternet
        } else if errorDescription.contains("timeout") || errorDescription.contains("timed out") {
            return Strings.Common.connectionTimeout
        } else if errorDescription.contains("could not connect") || errorDescription.contains("unreachable") {
            return Strings.Common.cannotReachServer
        } else if errorDescription.contains("unauthorized") || errorDescription.contains("401") {
            return Strings.Common.invalidAPIKey
        } else {
            return Strings.Common.connectionFailed
        }
    }
    
    // MARK: - Initialization
    
    init(
        provider: AIModelProvider? = nil,
        defaults: UserDefaults = .standard
    ) {
        self.defaults = defaults
        self.provider = provider ?? OpenAIProvider()
        loadSelectedModel()
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func validateOnLaunch() async {
        guard provider.isConfigured else {
            status = .notConfigured
            return
        }
        
        status = .connecting
        
        do {
            let isValid = try await provider.testConnection()
            if isValid {
                await fetchModels()
                status = .connected(model: selectedModel.name)
            } else {
                status = .error(message: Strings.Common.invalidAPIKey)
            }
        } catch {
            status = .error(message: friendlyErrorMessage(from: error))
        }
    }
    
    @MainActor
    func testConnection() async -> Bool {
        status = .connecting
        
        do {
            let isValid = try await provider.testConnection()
            if isValid {
                await fetchModels()
                status = .connected(model: selectedModel.name)
                return true
            } else {
                status = .error(message: Strings.Common.invalidAPIKey)
                return false
            }
        } catch {
            status = .error(message: friendlyErrorMessage(from: error))
            return false
        }
    }
    
    @MainActor
    func fetchModels() async {
        do {
            availableModels = try await provider.fetchAvailableModels()
            
            // Ensure selected model is still available
            if !availableModels.contains(where: { $0.id == selectedModel.id }) {
                if let firstModel = availableModels.first {
                    selectModel(firstModel)
                }
            }
        } catch {
            // Keep using existing models if fetch fails
        }
    }
    
    func selectModel(_ model: AIModel) {
        selectedModel = model
        saveSelectedModel()
        
        if case .connected = status {
            status = .connected(model: model.name)
        }
    }
    
    @MainActor
    func configure(apiKey: String) async {
        await provider.configure(apiKey: apiKey)
        
        // Reset state when disconnecting (empty API key)
        if apiKey.isEmpty {
            status = .notConfigured
            availableModels = []
        }
    }
    
    func transform(text: String, action: SpellAction) async throws -> String {
        guard text.count <= Self.maxTextLength else {
            throw SpellifyError.textTooLong
        }
        
        guard status.isReady else {
            throw SpellifyError.providerNotConfigured
        }
        
        return try await provider.transform(
            text: text,
            description: action.description,
            model: selectedModel.id
        )
    }
    
    var providerDisplayName: String {
        provider.displayName
    }
    
    // MARK: - Private Methods
    
    private func loadSelectedModel() {
        guard let data = defaults.data(forKey: selectedModelKey),
              let model = try? Self.decoder.decode(AIModel.self, from: data) else {
            return
        }
        selectedModel = model
    }
    
    private func saveSelectedModel() {
        guard let data = try? Self.encoder.encode(selectedModel) else { return }
        defaults.set(data, forKey: selectedModelKey)
    }
}

// MARK: - Errors

enum SpellifyError: LocalizedError, Equatable {
    case textTooLong
    case providerNotConfigured
    case noTextSelected
    case transformFailed(underlying: Error)
    
    var errorDescription: String? {
        switch self {
        case .textTooLong:
            return "Text too long"
        case .providerNotConfigured:
            return "AI provider not configured"
        case .noTextSelected:
            return "No text selected"
        case .transformFailed(let error):
            return "Transform failed: \(error.localizedDescription)"
        }
    }
    
    static func == (lhs: SpellifyError, rhs: SpellifyError) -> Bool {
        switch (lhs, rhs) {
        case (.textTooLong, .textTooLong),
             (.providerNotConfigured, .providerNotConfigured),
             (.noTextSelected, .noTextSelected):
            return true
        case (.transformFailed, .transformFailed):
            // Consider all transformFailed errors equal for testing purposes
            return true
        default:
            return false
        }
    }
}

