//
//  TextAreaFormField.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Reusable multi-line text area form field with label and focus border
/// Provides consistent styling across all text areas in the app
struct TextAreaFormField: View {
    
    // MARK: - Properties
    
    let label: String
    let helperText: String?
    @Binding var text: String
    let placeholder: String
    let maxLength: Int?
    let minHeight: CGFloat
    let showCounter: Bool
    
    @FocusState private var isFocused: Bool
    
    // MARK: - Initializer
    
    init(
        label: String,
        helperText: String? = nil,
        text: Binding<String>,
        placeholder: String = "",
        maxLength: Int? = nil,
        minHeight: CGFloat = 120,
        showCounter: Bool = false
    ) {
        self.label = label
        self.helperText = helperText
        self._text = text
        self.placeholder = placeholder
        self.maxLength = maxLength
        self.minHeight = minHeight
        self.showCounter = showCounter
    }
    
    // MARK: - Computed Properties
    
    private var limitedText: Binding<String> {
        Binding(
            get: { text },
            set: { newValue in
                if let maxLength = maxLength {
                    text = String(newValue.prefix(maxLength))
                } else {
                    text = newValue
                }
            }
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label with optional helper text and counter
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                
                HStack {
                    if let helperText = helperText {
                        Text(helperText)
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if showCounter, let maxLength = maxLength {
                        Text("\(text.count)/\(maxLength)")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            // Text area
            TextEditor(text: limitedText)
                .font(.system(size: 14))
                .frame(minHeight: minHeight)
                .scrollContentBackground(.hidden)
                .padding(10)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isFocused ? Color.accentColor : Color.clear, lineWidth: 2)
                )
                .focused($isFocused)
        }
    }
}

// MARK: - Preview

#Preview("With Helper Text") {
    TextAreaFormField(
        label: "Prompt",
        helperText: "Tell the AI what to do with the selected text",
        text: .constant("Fix any grammar and spelling errors"),
        placeholder: "Enter your prompt",
        maxLength: 500,
        showCounter: true
    )
    .padding()
    .frame(width: 400)
}

#Preview("Simple") {
    TextAreaFormField(
        label: "Description",
        text: .constant(""),
        placeholder: "Enter description",
        maxLength: 200,
        showCounter: true
    )
    .padding()
    .frame(width: 400)
}

