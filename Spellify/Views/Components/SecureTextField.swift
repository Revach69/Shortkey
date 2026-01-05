//
//  SecureTextField.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// A secure text field for API key input with show/hide toggle
struct SecureTextField: View {
    
    @Binding var text: String
    let placeholder: String
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        HStack {
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .textFieldStyle(.roundedBorder)
            
            Button(action: {
                isSecure.toggle()
            }) {
                Image(systemName: isSecure ? "eye" : "eye.slash")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help(isSecure ? "Show" : "Hide")
        }
    }
}

#Preview {
    SecureTextField(text: .constant("sk-test-key-12345"), placeholder: "API Key")
        .padding()
        .frame(width: 300)
}



