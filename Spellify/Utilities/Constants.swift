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
    
    /// Masked API key display
    static let maskedAPIKey = "sk-••••••••••••••••••••••••"
    
    /// Visual separator for text
    static let textSeparator = "·"
    
    // MARK: - URLs
    
    /// OpenAI API key page
    static let openAIKeyURL = URL(string: "https://platform.openai.com/api-keys")!
    
    // MARK: - Default Shortcut
    
    /// Default keyboard shortcut key code (S)
    static let defaultShortcutKeyCode: UInt32 = UInt32(kVK_ANSI_S)
    
    /// Default keyboard shortcut modifiers (Cmd + Shift)
    static let defaultShortcutModifiers: UInt32 = UInt32(cmdKey | shiftKey)
    
    // MARK: - Action Editor
    
    /// Maximum prompt length (characters)
    static let maxPromptLength = 500
    
    /// Curated SF Symbol icons for actions
    static let availableSFSymbols = [
        // Magic & Stars
        "wand.and.stars", "sparkles", "star", "star.fill",
        // Text & Writing
        "text.badge.checkmark", "text.badge.xmark", "text.badge.plus", "text.badge.minus",
        "character.cursor.ibeam", "character", "textformat", "textformat.size",
        "textformat.abc", "textformat.abc.dottedunderline",
        // Formatting
        "bold", "italic", "underline", "strikethrough",
        "textformat.alt", "character.textbox",
        // Language & Translation
        "globe", "globe.americas", "globe.europe.africa", "globe.asia.australia",
        "character.book.closed", "book", "book.closed",
        // Arrows & Transform
        "arrow.triangle.2.circlepath", "arrow.clockwise", "arrow.counterclockwise",
        "arrow.up.arrow.down", "arrow.left.arrow.right", "arrow.turn.up.right",
        // Documents
        "doc", "doc.text", "doc.plaintext", "doc.richtext",
        "note.text", "square.and.pencil",
        // Communication
        "bubble.left", "bubble.right", "bubble.left.and.bubble.right",
        "text.bubble", "quote.bubble",
        // Tools
        "pencil", "pencil.line", "paintbrush", "paintbrush.pointed",
        "hammer", "wrench", "screwdriver",
        // Symbols
        "number", "textformat.123", "at", "exclamationmark.3",
        "questionmark", "ellipsis", "trash", "folder"
    ]
}


