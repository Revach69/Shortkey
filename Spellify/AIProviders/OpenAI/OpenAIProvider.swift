//
//  OpenAIProvider.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation

/// OpenAI implementation of AIModelProvider
final class OpenAIProvider: AIModelProvider {
    
    // MARK: - AIModelProvider Properties
    
    let id = "openai"
    let displayName = "OpenAI"
    
    var isConfigured: Bool {
        (try? keychain.retrieve(key: keychainKey)) != nil
    }
    
    private(set) var connectionStatus: ConnectionStatus = .notConfigured
    
    // MARK: - Private Properties
    
    private let session: URLSessionProtocol
    private let keychain: KeychainServiceProtocol
    private let keychainKey = "openai-api-key" // Must match KeychainService.saveAPIKey format
    private let baseURL = "https://api.openai.com/v1"
    private let timeout: TimeInterval = 10.0
    
    // Reusable encoder/decoder for performance
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    
    // MARK: - Initialization
    
    init(
        session: URLSessionProtocol = URLSession.shared,
        keychain: KeychainServiceProtocol = KeychainService.shared
    ) {
        self.session = session
        self.keychain = keychain
    }
    
    // MARK: - AIModelProvider Methods
    
    func configure(apiKey: String) async {
        // Update connection status based on API key presence
        if apiKey.isEmpty {
            connectionStatus = .notConfigured
        }
        // Note: API key is saved to keychain by AIProviderSection before calling this
    }
    
    func testConnection() async throws -> Bool {
        guard let apiKey = try keychain.retrieve(key: keychainKey) else {
            throw OpenAIError.noAPIKey
        }
        
        let request = try buildRequest(
            endpoint: "/models",
            method: "GET",
            apiKey: apiKey
        )
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            return true
        case 401:
            throw OpenAIError.unauthorized
        default:
            throw OpenAIError.httpError(statusCode: httpResponse.statusCode)
        }
    }
    
    func fetchAvailableModels() async throws -> [AIModel] {
        guard let apiKey = try keychain.retrieve(key: keychainKey) else {
            throw OpenAIError.noAPIKey
        }
        
        let request = try buildRequest(
            endpoint: "/models",
            method: "GET",
            apiKey: apiKey
        )
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw OpenAIError.invalidResponse
        }
        
        let modelsResponse = try Self.decoder.decode(OpenAIModelsResponse.self, from: data)
        
        // Filter to only chat models
        let chatModels = modelsResponse.data
            .filter { $0.id.contains("gpt") }
            .sorted { $0.id < $1.id }
            .map { AIModel(id: $0.id, name: formatModelName($0.id), provider: id) }
        
        return chatModels
    }
    
    func transform(text: String, prompt: String, model: String) async throws -> String {
        guard let apiKey = try keychain.retrieve(key: keychainKey) else {
            throw OpenAIError.noAPIKey
        }
        
        let requestBody = OpenAIChatRequest(
            model: model,
            messages: [
                OpenAIChatMessage(role: "system", content: prompt),
                OpenAIChatMessage(role: "user", content: text)
            ],
            temperature: 0.3
        )
        
        let bodyData = try Self.encoder.encode(requestBody)
        
        var request = try buildRequest(
            endpoint: "/chat/completions",
            method: "POST",
            apiKey: apiKey
        )
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 401 {
                throw OpenAIError.unauthorized
            }
            throw OpenAIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let chatResponse = try Self.decoder.decode(OpenAIChatResponse.self, from: data)
        
        guard let content = chatResponse.choices.first?.message.content else {
            throw OpenAIError.noContent
        }
        
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Private Methods
    
    private func buildRequest(endpoint: String, method: String, apiKey: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + endpoint) else {
            throw OpenAIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = timeout
        
        return request
    }
    
    private func formatModelName(_ id: String) -> String {
        // Convert model IDs to readable names
        switch id {
        case "gpt-4o-mini":
            return "GPT-4o Mini"
        case "gpt-4o":
            return "GPT-4o"
        case "gpt-4-turbo":
            return "GPT-4 Turbo"
        case "gpt-4":
            return "GPT-4"
        case "gpt-3.5-turbo":
            return "GPT-3.5 Turbo"
        default:
            return id.replacingOccurrences(of: "-", with: " ").capitalized
        }
    }
}

// MARK: - Errors

enum OpenAIError: LocalizedError {
    case noAPIKey
    case invalidURL
    case invalidResponse
    case unauthorized
    case httpError(statusCode: Int)
    case noContent
    
    var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "No API key configured"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .unauthorized:
            return "Invalid API key"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .noContent:
            return "No content in response"
        }
    }
}


