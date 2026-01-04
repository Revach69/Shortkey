//
//  ShortcutSection.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Settings section for keyboard shortcut configuration
struct ShortcutSection: View {
    
    @AppStorage("shortcutDisplay") private var shortcutDisplay = "⌘⇧S"
    @State private var isRecording = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: "keyboard")
                    .font(.title2)
                    .foregroundStyle(.orange)
                
                Text(Strings.Settings.shortcut)
                    .font(.headline)
            }
            
            // Shortcut recorder
            HStack {
                Text("")
                    .frame(width: 80, alignment: .trailing)
                
                ShortcutRecorderView(
                    shortcutDisplay: $shortcutDisplay,
                    isRecording: $isRecording
                )
                
                Spacer()
            }
        }
    }
}

/// View for recording keyboard shortcuts
struct ShortcutRecorderView: View {
    
    @Binding var shortcutDisplay: String
    @Binding var isRecording: Bool
    
    var body: some View {
        Button(action: {
            isRecording.toggle()
        }) {
            HStack {
                if isRecording {
                    Text("Press shortcut...")
                        .foregroundStyle(.secondary)
                } else {
                    Text(shortcutDisplay)
                        .font(.system(.body, design: .monospaced))
                }
            }
            .frame(minWidth: 120)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isRecording ? Color.accentColor.opacity(0.1) : Color.secondary.opacity(0.1))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isRecording ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .onKeyPress { keyPress in
            guard isRecording else { return .ignored }
            
            // Build shortcut string from modifiers and key
            var parts: [String] = []
            
            if keyPress.modifiers.contains(.command) {
                parts.append("⌘")
            }
            if keyPress.modifiers.contains(.shift) {
                parts.append("⇧")
            }
            if keyPress.modifiers.contains(.option) {
                parts.append("⌥")
            }
            if keyPress.modifiers.contains(.control) {
                parts.append("⌃")
            }
            
            // Add the key character
            let keyChar = keyPress.characters.uppercased()
            if !keyChar.isEmpty {
                parts.append(keyChar)
            }
            
            if parts.count >= 2 { // At least one modifier + one key
                shortcutDisplay = parts.joined()
                isRecording = false
                
                // TODO: Register the actual hotkey with HotKeyManager
                
                return .handled
            }
            
            return .ignored
        }
    }
}

#Preview {
    ShortcutSection()
        .padding()
        .frame(width: 500)
}


