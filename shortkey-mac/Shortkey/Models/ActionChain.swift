//
//  ActionChain.swift
//  Shortkey
//
//  Created by Shortkey Team on 07/02/2026.
//

import Foundation

/// Represents an ordered sequence of actions where each action's output feeds into the next
struct ActionChain: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var icon: String // SF Symbol name
    var steps: [ChainStep]

    init(id: UUID = UUID(), name: String, icon: String = "link", steps: [ChainStep] = []) {
        self.id = id
        self.name = name
        self.icon = icon
        self.steps = steps
    }
}

/// A single step in a chain, referencing an existing SpellAction
struct ChainStep: Identifiable, Codable, Equatable {
    let id: UUID
    var actionId: UUID // references a SpellAction

    init(id: UUID = UUID(), actionId: UUID) {
        self.id = id
        self.actionId = actionId
    }
}

// MARK: - Test Fixtures

#if DEBUG
extension ActionChain {
    static func fixture(
        id: UUID = UUID(),
        name: String = "Test Chain",
        icon: String = "link",
        steps: [ChainStep] = []
    ) -> ActionChain {
        ActionChain(id: id, name: name, icon: icon, steps: steps)
    }
}
#endif
