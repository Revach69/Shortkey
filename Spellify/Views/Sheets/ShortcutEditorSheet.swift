//
//  ShortcutEditorSheet.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
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
        VStack(spacing: 0) {
            // Title
            HStack {
                Text("Edit Keyboard Shortcut")
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            Divider()
            
            // Content
            VStack(spacing: 12) {
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
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            
            Divider()
            
            // Footer buttons
            HStack {
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
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .frame(width: 400, height: 210)
        .background(Color(NSColor.windowBackgroundColor))
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

