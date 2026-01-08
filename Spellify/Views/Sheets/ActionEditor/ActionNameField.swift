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
        InputFormField(
            label: Strings.ActionEditor.name,
            text: $name,
            placeholder: Strings.ActionEditor.namePlaceholder,
            maxLength: BusinessRules.maxNameLength,
            showCounter: true
        )
    }
}

#Preview {
    ActionNameField(name: .constant("Fix Grammar"))
        .padding()
        .frame(width: 300)
}

