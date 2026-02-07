//
//  ShortcutEditorSheet.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// Sheet modal for editing keyboard shortcuts (consistent with API Key modal pattern)
struct ShortcutEditorSheet: View {
    
    // MARK: - Properties
    
    let currentShortcut: String
    @Binding var tempShortcut: String
    @Binding var isRecording: Bool
    let onSave: (String) -> Void
    let onCancel: () -> Void
    let onClear: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        SettingsModalContainer(
            title: "Edit Keyboard Shortcut",
            width: 400,
            height: 220
        ) {
            // Instruction text
            HStack {
                Text("Press your desired shortcut")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            
            // Recording input field
            ShortcutRecorderInputView(
                shortcutDisplay: $tempShortcut,
                isRecording: $isRecording
            )
            .frame(height: 50)
        } footer: {
            // Clear button (left side)
            Button(Strings.Common.clear) {
                onClear()
            }
            .disabled(tempShortcut.isEmpty)
            
            Spacer()
            
            // Cancel button
            Button(Strings.Common.cancel) {
                onCancel()
            }
            .keyboardShortcut(.cancelAction)
            
            // Save button
            Button(Strings.Common.save) {
                if !tempShortcut.isEmpty {
                    onSave(tempShortcut)
                }
            }
            .buttonStyle(.borderedProminent)
            .keyboardShortcut(.defaultAction)
            .disabled(tempShortcut.isEmpty)
        }
        .onAppear {
            isRecording = true
        }
    }
}

// MARK: - Preview

#Preview {
    ShortcutEditorSheet(
        currentShortcut: "⌘⇧S",
        tempShortcut: .constant(""),
        isRecording: .constant(false),
        onSave: { _ in },
        onCancel: {},
        onClear: {}
    )
}

