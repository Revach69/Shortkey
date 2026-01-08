//
//  SpellifyError.swift
//  Spellify
//
//  Error types for Spellify operations
//

import Foundation

enum SpellifyError: LocalizedError, Equatable {
    case textTooLong
    case providerNotConfigured
    case noTextSelected
    case transformFailed(underlying: Error)
    
    var errorDescription: String? {
        switch self {
        case .textTooLong:
            return "Text too long"
        case .providerNotConfigured:
            return "AI provider not configured"
        case .noTextSelected:
            return "No text selected"
        case .transformFailed(let error):
            return "Transform failed: \(error.localizedDescription)"
        }
    }
    
    static func == (lhs: SpellifyError, rhs: SpellifyError) -> Bool {
        switch (lhs, rhs) {
        case (.textTooLong, .textTooLong),
             (.providerNotConfigured, .providerNotConfigured),
             (.noTextSelected, .noTextSelected):
            return true
        case (.transformFailed, .transformFailed):
            // Consider all transformFailed errors equal for testing purposes
            return true
        default:
            return false
        }
    }
}
