//
//  AccessibilityService.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import AppKit
import Carbon.HIToolbox

/// Service for getting and replacing selected text using accessibility features
final class AccessibilityService {
    
    // MARK: - Singleton
    
    static let shared = AccessibilityService()
    
    // MARK: - Properties
    
    private let pasteboard = NSPasteboard.general
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Checks if accessibility permissions are granted
    var hasAccessibilityPermissions: Bool {
        AXIsProcessTrusted()
    }
    
    /// Requests accessibility permissions if not already granted
    func requestAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        AXIsProcessTrustedWithOptions(options as CFDictionary)
    }
    
    /// Gets the currently selected text by simulating Cmd+C
    /// Returns nil if no text is selected or copy failed
    func getSelectedText() async -> String? {
        // Save current clipboard content
        let savedContent = saveClipboard()
        
        // Clear clipboard
        pasteboard.clearContents()
        
        // Simulate Cmd+C
        simulateCopy()
        
        // Wait for clipboard to update
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        // Get text from clipboard
        let selectedText = pasteboard.string(forType: .string)
        
        // Restore original clipboard content
        restoreClipboard(savedContent)
        
        return selectedText?.isEmpty == false ? selectedText : nil
    }
    
    /// Replaces the selected text with new text by simulating Cmd+V
    func replaceSelectedText(with newText: String) async {
        // Save current clipboard content
        let savedContent = saveClipboard()
        
        // Put new text in clipboard
        pasteboard.clearContents()
        pasteboard.setString(newText, forType: .string)
        
        // Simulate Cmd+V
        simulatePaste()
        
        // Wait for paste to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        
        // Restore original clipboard content
        restoreClipboard(savedContent)
    }
    
    // MARK: - Private Methods
    
    private func saveClipboard() -> [NSPasteboard.PasteboardType: Data] {
        var content: [NSPasteboard.PasteboardType: Data] = [:]
        
        for type in pasteboard.types ?? [] {
            if let data = pasteboard.data(forType: type) {
                content[type] = data
            }
        }
        
        return content
    }
    
    private func restoreClipboard(_ content: [NSPasteboard.PasteboardType: Data]) {
        guard !content.isEmpty else { return }
        
        pasteboard.clearContents()
        
        for (type, data) in content {
            pasteboard.setData(data, forType: type)
        }
    }
    
    private func simulateCopy() {
        simulateKeyPress(keyCode: UInt16(kVK_ANSI_C), modifiers: .maskCommand)
    }
    
    private func simulatePaste() {
        simulateKeyPress(keyCode: UInt16(kVK_ANSI_V), modifiers: .maskCommand)
    }
    
    private func simulateKeyPress(keyCode: UInt16, modifiers: CGEventFlags) {
        let source = CGEventSource(stateID: .hidSystemState)
        
        // Key down
        if let keyDown = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true) {
            keyDown.flags = modifiers
            keyDown.post(tap: .cghidEventTap)
        }
        
        // Key up
        if let keyUp = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false) {
            keyUp.flags = modifiers
            keyUp.post(tap: .cghidEventTap)
        }
    }
}


