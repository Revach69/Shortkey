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
    
    private var limitedPrompt: Binding<String> {
        Binding(
            get: { prompt },
            set: { newValue in
                prompt = String(newValue.prefix(Constants.maxPromptLength))
            }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(Strings.ActionEditor.prompt)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                
                HStack {
                    Text(Strings.ActionEditor.promptHelper)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(prompt.count)/\(Constants.maxPromptLength)")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
            }
            
            TextEditor(text: limitedPrompt)
                .font(.system(size: 14))
                .frame(minHeight: 120)
                .scrollContentBackground(.hidden)
                .padding(10)
                .background(Color.secondary.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
        }
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

