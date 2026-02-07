//
//  AnthropicModels.swift
//  Shortkey
//
//  Created by Shortkey Team on 07/02/2026.
//

import Foundation

// MARK: - Messages Request

struct AnthropicMessagesRequest: Codable {
    let model: String
    let maxTokens: Int
    let system: String?
    let messages: [AnthropicMessage]
    let temperature: Double?

    init(model: String, maxTokens: Int, system: String? = nil, messages: [AnthropicMessage], temperature: Double? = nil) {
        self.model = model
        self.maxTokens = maxTokens
        self.system = system
        self.messages = messages
        self.temperature = temperature
    }

    enum CodingKeys: String, CodingKey {
        case model
        case maxTokens = "max_tokens"
        case system
        case messages
        case temperature
    }
}

struct AnthropicMessage: Codable {
    let role: String
    let content: String
}

// MARK: - Messages Response

struct AnthropicMessagesResponse: Codable {
    let id: String
    let type: String
    let role: String
    let content: [AnthropicContentBlock]
    let stopReason: String?
    let usage: AnthropicUsage?

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case role
        case content
        case stopReason = "stop_reason"
        case usage
    }
}

struct AnthropicContentBlock: Codable {
    let type: String
    let text: String?
}

struct AnthropicUsage: Codable {
    let inputTokens: Int
    let outputTokens: Int

    enum CodingKeys: String, CodingKey {
        case inputTokens = "input_tokens"
        case outputTokens = "output_tokens"
    }
}

// MARK: - Error Response

struct AnthropicErrorResponse: Codable {
    let type: String
    let error: AnthropicErrorDetail
}

struct AnthropicErrorDetail: Codable {
    let type: String
    let message: String
}
