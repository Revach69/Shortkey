//
//  InputFormField.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI
import Combine

/// Reusable single-line form input field with label and focus border
/// Provides consistent styling across all input fields in the app
struct InputFormField: View {
    
    // MARK: - Properties
    
    let label: String
    @Binding var text: String
    let placeholder: String
    let isSecure: Bool
    let maxLength: Int?
    let showCounter: Bool
    
    @FocusState private var isFocused: Bool
    
    // MARK: - Initializers
    
    /// Standard text input field
    init(
        label: String,
        text: Binding<String>,
        placeholder: String = "",
        maxLength: Int? = nil,
        showCounter: Bool = false
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.isSecure = false
        self.maxLength = maxLength
        self.showCounter = showCounter
    }
    
    /// Secure text input field (for passwords/API keys)
    init(
        label: String,
        text: Binding<String>,
        placeholder: String = "",
        isSecure: Bool
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.maxLength = nil
        self.showCounter = false
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Label with optional character counter
            HStack {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if showCounter, let maxLength = maxLength {
                    Text("\(text.count)/\(maxLength)")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
            }
            
            // Input field
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle(.plain)
                } else {
                    TextField(placeholder, text: $text)
                        .textFieldStyle(.plain)
                }
            }
            .font(.system(size: 14))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isFocused ? Color.accentColor : Color.clear, lineWidth: 2)
            )
            .focused($isFocused)
            .onReceive(Just(text)) { _ in
                if let maxLength = maxLength, text.count > maxLength {
                    text = String(text.prefix(maxLength))
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Text Field") {
    VStack(spacing: 20) {
        InputFormField(
            label: "Name",
            text: .constant("Fix Grammar"),
            placeholder: "Enter action name",
            maxLength: 50,
            showCounter: true
        )
        
        InputFormField(
            label: "Email",
            text: .constant(""),
            placeholder: "Enter your email"
        )
    }
    .padding()
    .frame(width: 400)
}

#Preview("Secure Field") {
    InputFormField(
        label: "API Key",
        text: .constant(""),
        placeholder: "sk-...",
        isSecure: true
    )
    .padding()
    .frame(width: 400)
}

