//
//  SpellAction.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation

/// Represents a text transformation action with a name and description
struct SpellAction: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    var icon: String // SF Symbol name
    
    init(id: UUID = UUID(), name: String, description: String, icon: String = "wand.and.stars") {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
    }
}

// MARK: - Default Actions

extension SpellAction {
    
    static let defaults: [SpellAction] = [
        SpellAction(
            name: "Fix Grammar",
            description: "Fix any grammar and spelling errors in this text. Keep the same tone and style. Only return the corrected text, nothing else.",
            icon: "text.badge.checkmark"
        ),
        SpellAction(
            name: "Translate to Spanish",
            description: "Translate this text to Spanish. Only return the translated text, nothing else.",
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
        description: String = "Test description",
        icon: String = "wand.and.stars"
    ) -> SpellAction {
        SpellAction(id: id, name: name, description: description, icon: icon)
    }
}
#endif


