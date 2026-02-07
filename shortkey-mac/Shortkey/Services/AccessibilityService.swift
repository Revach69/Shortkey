//
//  AccessibilityService.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
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
    
    var hasAccessibilityPermissions: Bool {
        AXIsProcessTrusted()
    }
    
    func requestAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        AXIsProcessTrustedWithOptions(options as CFDictionary)
    }
    
    func getSelectedText() async -> String? {
        let savedContent = saveClipboard()
        pasteboard.clearContents()
        simulateCopy()
        
        // Wait for clipboard to update
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        let selectedText = pasteboard.string(forType: .string)
        restoreClipboard(savedContent)
        
        return selectedText?.isEmpty == false ? selectedText : nil
    }
    
    func replaceSelectedText(with newText: String) async {
        let savedContent = saveClipboard()
        
        pasteboard.clearContents()
        pasteboard.setString(newText, forType: .string)
        simulatePaste()
        
        // Wait for paste to complete
        try? await Task.sleep(nanoseconds: 100_000_000)
        
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
        
        if let keyDown = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true) {
            keyDown.flags = modifiers
            keyDown.post(tap: .cghidEventTap)
        }
        
        if let keyUp = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false) {
            keyUp.flags = modifiers
            keyUp.post(tap: .cghidEventTap)
        }
    }
}



