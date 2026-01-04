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
    let onDelete: (() -> Void)?
    
    @State private var name: String = ""
    @State private var prompt: String = ""
    @State private var icon: String = "wand.and.stars"
    @State private var customIcon: String = ""
    
    // Character limit for prompt
    private let maxPromptLength = 500
    
    // Curated SF Symbol icons organized by category
    private let availableIcons = [
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
    
    private var isEditing: Bool {
        action != nil
    }
    
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !prompt.trimmingCharacters(in: .whitespaces).isEmpty &&
        prompt.count <= maxPromptLength
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(isEditing ? Strings.ActionEditor.editAction : Strings.ActionEditor.newAction)
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            Divider()
            
            // Form
            VStack(spacing: 20) {
                // Icon and Name on same line with labels
                HStack(alignment: .top, spacing: 12) {
                    // Icon Dropdown with label
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Icon")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        Menu {
                            ForEach(availableIcons, id: \.self) { iconName in
                                Button(action: {
                                    icon = iconName
                                }) {
                                    HStack {
                                        Image(systemName: iconName)
                                        if icon == iconName {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                            
                            // Custom icon option
                            Button("Browse All Symbols...") {
                                // This would open SF Symbols app or a browser
                                NSWorkspace.shared.open(URL(string: "https://developer.apple.com/sf-symbols/")!)
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: icon)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.primary)
                                    .frame(width: 20, height: 20)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                        .help("Choose Icon")
                    }
                    
                    // Name field with label
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Name")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        TextField("Action Name", text: $name, prompt: Text("e.g. Fix Grammar"))
                            .textFieldStyle(.plain)
                            .font(.system(size: 14))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                
                // Prompt
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Prompt")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            Text("Tell the AI what to do with the selected text")
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("\(prompt.count)/\(maxPromptLength)")
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundStyle(prompt.count > maxPromptLength ? .red : .secondary)
                        }
                    }
                    
                    TextEditor(text: $prompt)
                        .font(.system(size: 14))
                        .frame(minHeight: 120)
                        .scrollContentBackground(.hidden)
                        .padding(10)
                        .background(Color.secondary.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(
                                    prompt.count > maxPromptLength ? Color.red.opacity(0.5) : Color.secondary.opacity(0.2),
                                    lineWidth: 1
                                )
                        )
                        .onChange(of: prompt) { oldValue, newValue in
                            // Optionally enforce limit (uncomment to prevent typing beyond limit)
                            // if newValue.count > maxPromptLength {
                            //     prompt = String(newValue.prefix(maxPromptLength))
                            // }
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            Divider()
            
            // Footer Buttons - Apple HIG style
            HStack(spacing: 12) {
                // Delete button (destructive, bottom-left, only when editing)
                if isEditing, let onDelete = onDelete {
                    Button(action: {
                        onDelete()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "trash")
                                .font(.system(size: 13))
                            Text("Delete")
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
                    Text("Cancel")
                        .frame(minWidth: 70)
                }
                .keyboardShortcut(.escape, modifiers: [])
                
                // Save button (primary, prominent)
                Button(action: {
                    let newAction = SpellAction(
                        id: action?.id ?? UUID(),
                        name: name.trimmingCharacters(in: .whitespaces),
                        prompt: prompt.trimmingCharacters(in: .whitespaces),
                        icon: icon
                    )
                    onSave(newAction)
                }) {
                    Text("Save")
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
        .frame(width: 520, height: 420)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            if let action = action {
                name = action.name
                prompt = action.prompt
                icon = action.icon
            }
        }
    }
}

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
        action: SpellAction(name: "Fix Grammar", prompt: "Fix any grammar errors", icon: "text.badge.checkmark"),
        onSave: { _ in },
        onCancel: {},
        onDelete: {}
    )
}


