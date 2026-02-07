//
//  SecureTextField.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// A simple secure text field without show/hide toggle
struct SecureTextField: View {
    
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .textFieldStyle(.roundedBorder)
    }
}

#Preview {
    SecureTextField(text: .constant("sk-test-key-12345"), placeholder: "")
        .padding()
        .frame(width: 300)
}
