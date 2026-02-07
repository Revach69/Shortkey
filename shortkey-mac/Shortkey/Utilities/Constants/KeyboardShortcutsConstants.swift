//
//  KeyboardShortcutsConstants.swift
//  Shortkey
//
//  Default keyboard shortcut constants
//

import Foundation
import Carbon.HIToolbox

enum KeyboardShortcutsConstants {
    
    // MARK: - Default Shortcut
    
    /// Default keyboard shortcut key code (S)
    static let defaultKeyCode: UInt32 = UInt32(kVK_ANSI_S)
    
    /// Default keyboard shortcut modifiers (Cmd + Shift)
    static let defaultModifiers: UInt32 = UInt32(cmdKey | shiftKey)
}
