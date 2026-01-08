//
//  ActionDescriptionEditor.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Description text editor with character counter
struct ActionDescriptionEditor: View {
    
    @Binding var description: String
    
    var body: some View {
        TextAreaFormField(
            label: Strings.ActionEditor.description,
            helperText: Strings.ActionEditor.descriptionHelper,
            text: $description,
            placeholder: Strings.ActionEditor.descriptionPlaceholder,
            maxLength: BusinessRules.maxDescriptionLength,
            minHeight: 120,
            showCounter: true
        )
    }
}

#Preview {
    VStack {
        ActionDescriptionEditor(description: .constant("Fix any grammar and spelling errors"))
        ActionDescriptionEditor(description: .constant(String(repeating: "A", count: 550)))
    }
    .padding()
    .frame(width: 400)
}

