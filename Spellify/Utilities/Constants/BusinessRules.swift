//
//  BusinessRules.swift
//  Spellify
//
//  Business logic constants and rules
//

import Foundation

enum BusinessRules {
    
    // MARK: - Text Processing
    
    /// Maximum text length for AI transformation (characters)
    static let maxTextLength = 10_000
    
    // MARK: - Subscription & Pro Features
    
    /// Maximum number of actions for free tier users
    static let freeActionsLimit = 3
    
    // MARK: - Action Validation
    
    /// Maximum action name length (characters)
    static let maxNameLength = 50
    
    /// Maximum description length (characters)
    static let maxDescriptionLength = 500
}
