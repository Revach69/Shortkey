//
//  ActionEditorSheet.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Sheet for creating or editing an action (coordinator view)
struct ActionEditorSheet: View {
    
    // MARK: - Properties
    
    let action: SpellAction?
    let onSave: (SpellAction) -> Void
    let onCancel: () -> Void
    let onDelete: (() -> Void)?
    
    @State private var name: String = ""
    @State private var prompt: String = ""
    @State private var icon: String = "wand.and.stars"
    
    // MARK: - Computed Properties
    
    private var isEditing: Bool {
        action != nil
    }
    
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !prompt.trimmingCharacters(in: .whitespaces).isEmpty &&
        prompt.count <= Constants.maxPromptLength
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ActionEditorHeader(isEditing: isEditing)
            
            Divider()
            
            // Form
            VStack(spacing: 20) {
                // Icon and Name on same line
                HStack(alignment: .top, spacing: 12) {
                    ActionIconPicker(selectedIcon: $icon)
                    ActionNameField(name: $name)
                }
                
                // Prompt
                ActionPromptEditor(prompt: $prompt)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            Divider()
            
            // Footer
            ActionEditorFooter(
                isEditing: isEditing,
                isValid: isValid,
                onDelete: onDelete,
                onCancel: onCancel,
                onSave: handleSave
            )
        }
        .frame(width: 520, height: 420)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear(perform: loadActionData)
    }
    
    // MARK: - Methods
    
    private func loadActionData() {
        guard let action = action else { return }
        name = action.name
        prompt = action.prompt
        icon = action.icon
    }
    
    private func handleSave() {
        let newAction = SpellAction(
            id: action?.id ?? UUID(),
            name: name.trimmingCharacters(in: .whitespaces),
            prompt: prompt.trimmingCharacters(in: .whitespaces),
            icon: icon
        )
        onSave(newAction)
    }
}

// MARK: - Previews

#Preview("New Action") {
    ActionEditorSheet(
        action: nil,
        onSave: { _ in },
        onCancel: {},
        onDelete: nil
    )
}

#Preview("Edit Action") {
    ActionEditorSheet(
        action: SpellAction(
            name: "Fix Grammar",
            prompt: "Fix any grammar errors",
            icon: "text.badge.checkmark"
        ),
        onSave: { _ in },
        onCancel: {},
        onDelete: {}
    )
}
