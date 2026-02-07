//
//  AnthropicProvider.swift
//  Shortkey
//
//  Created by Shortkey Team on 07/02/2026.
//

import Foundation

/// Anthropic implementation of AIModelProvider
final class AnthropicProvider: AIModelProvider {

    // MARK: - AIModelProvider Properties

    let id = AIProviderConstants.Anthropic.id
    let displayName = AIProviderConstants.Anthropic.displayName
    let apiKeyURL = NetworkConstants.Anthropic.apiKeyURL

    var isConfigured: Bool {
        do {
            let key = try keychain.retrieve(key: keychainKey)
            return key != nil && !key!.isEmpty
        } catch KeychainError.encodingFailed, KeychainError.decodingFailed {
            AppLogger.error("Keychain data corruption for Anthropic key")
            return false
        } catch {
            // errSecItemNotFound is expected when no key exists
            return false
        }
    }

    private(set) var connectionStatus: ConnectionStatus = .notConfigured

    // MARK: - Private Properties

    private let session: URLSessionProtocol
    private let keychain: KeychainServiceProtocol
    private let keychainKey = AIProviderConstants.Anthropic.keychainKey
    private let baseURL = NetworkConstants.Anthropic.baseURL
    private let timeout: TimeInterval = NetworkConstants.requestTimeout
    private let apiVersion = "2023-06-01"

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
        if apiKey.isEmpty {
            connectionStatus = .notConfigured
        }
        // Note: API key is saved to keychain by AIProviderSection before calling this
    }

    func testConnection() async throws -> Bool {
        guard let apiKey = try keychain.retrieve(key: keychainKey) else {
            throw AnthropicError.noAPIKey
        }

        let requestBody = AnthropicMessagesRequest(
            model: "claude-sonnet-4-5-20250929",
            maxTokens: 10,
            messages: [AnthropicMessage(role: "user", content: "Hi")]
        )

        let bodyData = try Self.encoder.encode(requestBody)

        var request = try buildRequest(
            endpoint: "/messages",
            method: "POST",
            apiKey: apiKey
        )
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AnthropicError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            return true
        case 401:
            throw AnthropicError.unauthorized
        default:
            throw AnthropicError.httpError(statusCode: httpResponse.statusCode)
        }
    }

    func fetchAvailableModels() async throws -> [AIModel] {
        // Anthropic has no list-models endpoint; return hardcoded list
        return [
            AIModel(id: "claude-sonnet-4-5-20250929", name: "Claude Sonnet 4.5", provider: id),
            AIModel(id: "claude-haiku-4-5-20251001", name: "Claude Haiku 4.5", provider: id)
        ]
    }

    func transform(text: String, description: String, model: String) async throws -> String {
        guard let apiKey = try keychain.retrieve(key: keychainKey) else {
            throw AnthropicError.noAPIKey
        }

        let requestBody = AnthropicMessagesRequest(
            model: model,
            maxTokens: 4096,
            system: buildSystemPrompt(for: description),
            messages: [AnthropicMessage(role: "user", content: text)],
            temperature: 0.3
        )

        let bodyData = try Self.encoder.encode(requestBody)

        var request = try buildRequest(
            endpoint: "/messages",
            method: "POST",
            apiKey: apiKey
        )
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AnthropicError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 401 {
                throw AnthropicError.unauthorized
            }
            throw AnthropicError.httpError(statusCode: httpResponse.statusCode)
        }

        let messagesResponse = try Self.decoder.decode(AnthropicMessagesResponse.self, from: data)

        guard let content = messagesResponse.content.first?.text else {
            throw AnthropicError.noContent
        }

        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Private Methods

    private func buildRequest(endpoint: String, method: String, apiKey: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + endpoint) else {
            throw AnthropicError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue(apiVersion, forHTTPHeaderField: "anthropic-version")
        request.timeoutInterval = timeout

        return request
    }
}

// MARK: - Errors

enum AnthropicError: LocalizedError {
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
