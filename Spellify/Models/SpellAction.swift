//
//  SpellAction.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation

/// Represents a text transformation action with a name and prompt
struct SpellAction: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var prompt: String
    var icon: String // SF Symbol name
    
    init(id: UUID = UUID(), name: String, prompt: String, icon: String = "wand.and.stars") {
        self.id = id
        self.name = name
        self.prompt = prompt
        self.icon = icon
    }
}

// MARK: - Default Actions

extension SpellAction {
    
    /// Default actions created on first launch
    static let defaults: [SpellAction] = [
        SpellAction(
            name: "Fix Grammar",
            prompt: "Fix any grammar and spelling errors in this text. Keep the same tone and style. Only return the corrected text, nothing else.",
            icon: "text.badge.checkmark"
        ),
        SpellAction(
            name: "Translate to Spanish",
            prompt: "Translate this text to Spanish. Only return the translated text, nothing else.",
            icon: "globe"
        )
    ]
}

// MARK: - Test Fixtures

#if DEBUG
extension SpellAction {
    static func fixture(
        id: UUID = UUID(),
        name: String = "Test Action",
        prompt: String = "Test prompt",
        icon: String = "wand.and.stars"
    ) -> SpellAction {
        SpellAction(id: id, name: name, prompt: prompt, icon: icon)
    }
}
#endif


