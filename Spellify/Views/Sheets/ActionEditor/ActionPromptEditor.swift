//
//  ActionPromptEditor.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Prompt text editor with character counter
struct ActionPromptEditor: View {
    
    @Binding var prompt: String
    
    var body: some View {
        TextAreaFormField(
            label: Strings.ActionEditor.prompt,
            helperText: Strings.ActionEditor.promptHelper,
            text: $prompt,
            placeholder: Strings.ActionEditor.promptPlaceholder,
            maxLength: Constants.maxPromptLength,
            minHeight: 120,
            showCounter: true
        )
    }
}

#Preview {
    VStack {
        ActionPromptEditor(prompt: .constant("Fix any grammar and spelling errors"))
        ActionPromptEditor(prompt: .constant(String(repeating: "A", count: 550)))
    }
    .padding()
    .frame(width: 400)
}

