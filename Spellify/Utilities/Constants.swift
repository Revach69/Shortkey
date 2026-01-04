//
//  Constants.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
import Carbon.HIToolbox

/// App-wide constants
enum Constants {
    
    // MARK: - Text Limits
    
    /// Maximum text length for transformation (characters)
    static let maxTextLength = 10_000
    
    // MARK: - Network
    
    /// API request timeout in seconds
    static let requestTimeout: TimeInterval = 10.0
    
    // MARK: - UI
    
    /// Popover width
    static let popoverWidth: CGFloat = 300
    
    /// Popover height
    static let popoverHeight: CGFloat = 400
    
    /// Settings window width
    static let settingsWidth: CGFloat = 500
    
    /// Settings window height
    static let settingsHeight: CGFloat = 400
    
    // MARK: - URLs
    
    /// OpenAI API key page
    static let openAIKeyURL = URL(string: "https://platform.openai.com/api-keys")!
    
    // MARK: - Default Shortcut
    
    /// Default keyboard shortcut key code (S)
    static let defaultShortcutKeyCode: UInt32 = UInt32(kVK_ANSI_S)
    
    /// Default keyboard shortcut modifiers (Cmd + Shift)
    static let defaultShortcutModifiers: UInt32 = UInt32(cmdKey | shiftKey)
}


