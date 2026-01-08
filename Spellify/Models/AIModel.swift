//
//  AIModel.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation

/// Represents an AI model available from a provider
struct AIModel: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let provider: String
    
    init(id: String, name: String, provider: String = "openai") {
        self.id = id
        self.name = name
        self.provider = provider
    }
}

// MARK: - Common Models

extension AIModel {
    
    static let defaultModel = AIModel(
        id: "gpt-4o-mini",
        name: "GPT-4o Mini",
        provider: "openai"
    )
}

