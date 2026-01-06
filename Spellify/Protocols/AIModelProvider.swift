//
//  AIModelProvider.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation

/// Protocol defining the interface for AI model providers
/// Follows SOLID Open/Closed principle - new providers can be added without modifying existing code
protocol AIModelProvider: AnyObject {
    
    /// Unique identifier for the provider
    var id: String { get }
    
    /// Human-readable display name
    var displayName: String { get }
    
    /// URL for obtaining an API key from the provider
    var apiKeyURL: URL { get }
    
    /// Whether the provider has been configured with an API key
    var isConfigured: Bool { get }
    
    /// Current connection status
    var connectionStatus: ConnectionStatus { get }
    
    /// Configures the provider with an API key
    func configure(apiKey: String) async
    
    /// Tests if the current configuration is valid
    func testConnection() async throws -> Bool
    
    /// Fetches available models from the provider
    func fetchAvailableModels() async throws -> [AIModel]
    
    /// Transforms text using the specified description and model
    func transform(text: String, description: String, model: String) async throws -> String
}

// MARK: - Default Implementation

extension AIModelProvider {
    
    /// Builds a comprehensive system prompt with safety guardrails
    /// All providers can use this standardized prompt to ensure consistent behavior
    func buildSystemPrompt(for actionDescription: String) -> String {
        """
        \(actionDescription)
        
        Critical Instructions:
        - Follow the action description precisely, nothing more
        - Preserve the original language and tone unless explicitly instructed otherwise
        - Maintain the exact meaning and intent of the original text
        - Keep all proper nouns, names, and technical terms unchanged
        - Do NOT add explanations, commentary, or introductory phrases
        - Do NOT modify content beyond what the action describes
        - Output ONLY the transformed text itself
        
        If the requested action is unclear or inappropriate, output the original text unchanged.
        """
    }
}

// MARK: - URLSession Protocol for Testing

/// Protocol for URLSession to enable mocking in tests
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

// MARK: - Keychain Service Protocol

/// Protocol for Keychain operations to enable mocking in tests
protocol KeychainServiceProtocol {
    func save(key: String, value: String) throws
    func retrieve(key: String) throws -> String?
    func delete(key: String) throws
}



