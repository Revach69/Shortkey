//
//  ActionNameField.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Name input field for action editor
struct ActionNameField: View {
    
    @Binding var name: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Strings.ActionEditor.name)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
            
            TextField(Strings.ActionEditor.name, text: $name, prompt: Text(Strings.ActionEditor.namePlaceholder))
                .textFieldStyle(.plain)
                .font(.system(size: 14))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(6)
        }
    }
}

#Preview {
    ActionNameField(name: .constant("Fix Grammar"))
        .padding()
        .frame(width: 300)
}

