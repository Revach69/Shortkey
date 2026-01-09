//
//  AIProviderManager.swift
//  Spellify
//
//  Manages the active AI provider and its connection state
//

import Foundation
import Combine

@MainActor
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
            status = .error(message: ErrorMessageFormatter.friendlyMessage(from: error))
        }
    }
    
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
            status = .error(message: ErrorMessageFormatter.friendlyMessage(from: error))
            return false
        }
    }
    
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
            throw TextTransformError.textTooLong
        }
        
        guard status.isReady else {
            throw TextTransformError.providerNotConfigured
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
        guard let data = defaults.data(forKey: selectedModelKey) else {
            AppLogger.log("No saved model found, using default")
            return
        }
        
        do {
            selectedModel = try Self.decoder.decode(AIModel.self, from: data)
            AppLogger.log("Loaded saved model: \(selectedModel.name)")
        } catch {
            AppLogger.error("Failed to decode saved model: \(error). Using default model.")
        }
    }
    
    private func saveSelectedModel() {
        do {
            let data = try Self.encoder.encode(selectedModel)
            defaults.set(data, forKey: selectedModelKey)
            AppLogger.log("Saved model preference: \(selectedModel.name)")
        } catch {
            AppLogger.error("Failed to save model preference: \(error)")
        }
    }
}
