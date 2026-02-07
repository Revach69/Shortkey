//
//  ProFeatures.swift
//  Shortkey
//
//  Central definition of all Pro features
//

import Foundation

enum ProFeature: String, CaseIterable {
    case unlimitedActions = "unlimited_actions"
    case promptChaining = "prompt_chaining"

    // MARK: - Display Properties

    var displayName: String {
        switch self {
        case .unlimitedActions:
            return Strings.ProFeatures.unlimitedActions
        case .promptChaining:
            return Strings.ProFeatures.promptChaining
        }
    }

    var icon: String {
        switch self {
        case .unlimitedActions:
            return "infinity"
        case .promptChaining:
            return "link"
        }
    }

    var description: String {
        switch self {
        case .unlimitedActions:
            return Strings.ProFeatures.unlimitedActionsDescription
        case .promptChaining:
            return Strings.ProFeatures.promptChainingDescription
        }
    }

    // MARK: - Implementation Status

    var isImplemented: Bool {
        return true
    }
}
