//
//  OpenAIModels.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation

// MARK: - Models List Response

struct OpenAIModelsResponse: Codable {
    let data: [OpenAIModelData]
}

struct OpenAIModelData: Codable {
    let id: String
    let object: String?
    let created: Int?
    let ownedBy: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case ownedBy = "owned_by"
    }
}

// MARK: - Chat Completion Request

struct OpenAIChatRequest: Codable {
    let model: String
    let messages: [OpenAIChatMessage]
    let temperature: Double?
    
    init(model: String, messages: [OpenAIChatMessage], temperature: Double? = nil) {
        self.model = model
        self.messages = messages
        self.temperature = temperature
    }
}

struct OpenAIChatMessage: Codable {
    let role: String
    let content: String
}

// MARK: - Chat Completion Response

struct OpenAIChatResponse: Codable {
    let id: String
    let choices: [OpenAIChatChoice]
    let usage: OpenAIUsage?
}

struct OpenAIChatChoice: Codable {
    let index: Int
    let message: OpenAIChatMessage
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }
}

struct OpenAIUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}



