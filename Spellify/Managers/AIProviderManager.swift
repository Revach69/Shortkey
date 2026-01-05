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
    
    // MARK: - Constants
    
    static let maxTextLength = 10_000
    
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
    
    /// Validates the API key on app launch
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
                status = .error(message: "Invalid API key")
            }
        } catch {
            status = .error(message: error.localizedDescription)
        }
    }
    
    /// Tests the connection with the current API key
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
                status = .error(message: "Invalid API key")
                return false
            }
        } catch {
            status = .error(message: error.localizedDescription)
            return false
        }
    }
    
    /// Fetches available models from the provider
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
    
    /// Selects a model to use
    func selectModel(_ model: AIModel) {
        selectedModel = model
        saveSelectedModel()
        
        if case .connected = status {
            status = .connected(model: model.name)
        }
    }
    
    /// Configures the API key for the provider
    @MainActor
    func configure(apiKey: String) async {
        await provider.configure(apiKey: apiKey)
        
        // Reset state when disconnecting (empty API key)
        if apiKey.isEmpty {
            status = .notConfigured
            availableModels = []
        }
    }
    
    /// Transforms text using the selected action
    func transform(text: String, action: SpellAction) async throws -> String {
        // Check text length
        guard text.count <= Self.maxTextLength else {
            throw SpellifyError.textTooLong
        }
        
        // Check if provider is ready
        guard status.isReady else {
            throw SpellifyError.providerNotConfigured
        }
        
        return try await provider.transform(
            text: text,
            prompt: action.prompt,
            model: selectedModel.id
        )
    }
    
    /// Returns the display name of the current provider
    var providerDisplayName: String {
        provider.displayName
    }
    
    // MARK: - Private Methods
    
    private func loadSelectedModel() {
        guard let data = defaults.data(forKey: selectedModelKey),
              let model = try? JSONDecoder().decode(AIModel.self, from: data) else {
            return
        }
        selectedModel = model
    }
    
    private func saveSelectedModel() {
        guard let data = try? JSONEncoder().encode(selectedModel) else { return }
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
    
    // MARK: - Equatable
    
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

