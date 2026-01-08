//
//  ProFeatures.swift
//  Spellify
//
//  Central definition of all Pro features
//

import Foundation

enum ProFeature: String, CaseIterable {
    case unlimitedActions = "unlimited_actions"
    
    // MARK: - Display Properties
    
    var displayName: String {
        switch self {
        case .unlimitedActions:
            return Strings.ProFeatures.unlimitedActions
        }
    }
    
    var icon: String {
        switch self {
        case .unlimitedActions:
            return "infinity"
        }
    }
    
    var description: String {
        switch self {
        case .unlimitedActions:
            return Strings.ProFeatures.unlimitedActionsDescription
        }
    }
    
    // MARK: - Implementation Status
    
    /// All features in this enum are implemented
    var isImplemented: Bool {
        return true
    }
}
