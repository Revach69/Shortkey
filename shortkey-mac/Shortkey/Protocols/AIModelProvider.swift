//
//  AIModelProvider.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import Foundation

/// Protocol defining the interface for AI model providers
/// Follows SOLID Open/Closed principle - new providers can be added without modifying existing code
protocol AIModelProvider: AnyObject {
    
    var id: String { get }
    var displayName: String { get }
    var apiKeyURL: URL { get }
    var isConfigured: Bool { get }
    var connectionStatus: ConnectionStatus { get }
    
    func configure(apiKey: String) async
    func testConnection() async throws -> Bool
    func fetchAvailableModels() async throws -> [AIModel]
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



