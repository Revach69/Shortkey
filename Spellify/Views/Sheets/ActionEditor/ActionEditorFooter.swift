//
//  ActionEditorFooter.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Footer buttons for action editor (Delete, Cancel, Save)
struct ActionEditorFooter: View {
    
    let isEditing: Bool
    let isValid: Bool
    let onDelete: (() -> Void)?
    let onCancel: () -> Void
    let onSave: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Delete button (destructive, bottom-left, only when editing)
            if isEditing, let onDelete = onDelete {
                Button(action: onDelete) {
                    HStack(spacing: 6) {
                        Image(systemName: "trash")
                            .font(.system(size: 13))
                        Text(Strings.ActionEditor.delete)
                    }
                    .frame(minWidth: 80)
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.red)
                .help("Delete this action")
            }
            
            Spacer()
            
            // Cancel button (secondary)
            Button(action: onCancel) {
                Text(Strings.ActionEditor.cancel)
                    .frame(minWidth: 70)
            }
            .keyboardShortcut(.escape, modifiers: [])
            
            // Save button (primary, prominent)
            Button(action: onSave) {
                Text(Strings.ActionEditor.save)
                    .frame(minWidth: 70)
            }
            .keyboardShortcut(.return, modifiers: .command)
            .disabled(!isValid)
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20)
    }
}

#Preview {
    VStack {
        ActionEditorFooter(
            isEditing: false,
            isValid: true,
            onDelete: nil,
            onCancel: {},
            onSave: {}
        )
        Divider()
        ActionEditorFooter(
            isEditing: true,
            isValid: false,
            onDelete: {},
            onCancel: {},
            onSave: {}
        )
    }
}

