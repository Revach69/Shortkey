//
//  ActionEditorSheet.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Sheet for creating or editing an action
struct ActionEditorSheet: View {
    
    let action: SpellAction?
    let onSave: (SpellAction) -> Void
    let onCancel: () -> Void
    
    @State private var name: String = ""
    @State private var prompt: String = ""
    
    private var isEditing: Bool {
        action != nil
    }
    
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !prompt.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text(isEditing ? Strings.ActionEditor.editAction : Strings.ActionEditor.newAction)
                .font(.headline)
                .padding()
            
            Divider()
            
            // Form
            Form {
                TextField(Strings.ActionEditor.name, text: $name, prompt: Text(Strings.ActionEditor.namePlaceholder))
                    .textFieldStyle(.roundedBorder)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(Strings.ActionEditor.prompt)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                    TextEditor(text: $prompt)
                        .font(.body)
                        .frame(minHeight: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                }
            }
            .padding()
            
            Divider()
            
            // Buttons
            HStack {
                Button(Strings.ActionEditor.cancel) {
                    onCancel()
                }
                .keyboardShortcut(.escape, modifiers: [])
                
                Spacer()
                
                Button(Strings.ActionEditor.save) {
                    let newAction = SpellAction(
                        id: action?.id ?? UUID(),
                        name: name.trimmingCharacters(in: .whitespaces),
                        prompt: prompt.trimmingCharacters(in: .whitespaces)
                    )
                    onSave(newAction)
                }
                .keyboardShortcut(.return, modifiers: .command)
                .disabled(!isValid)
            }
            .padding()
        }
        .frame(width: 400, height: 300)
        .onAppear {
            if let action = action {
                name = action.name
                prompt = action.prompt
            }
        }
    }
}

#Preview("New Action") {
    ActionEditorSheet(
        action: nil,
        onSave: { _ in },
        onCancel: {}
    )
}

#Preview("Edit Action") {
    ActionEditorSheet(
        action: SpellAction(name: "Fix Grammar", prompt: "Fix any grammar errors"),
        onSave: { _ in },
        onCancel: {}
    )
}


