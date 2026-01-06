//
//  NativeSecureTextField.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI
import AppKit

/// Native NSSecureTextField wrapper for authentic macOS appearance
struct NativeSecureTextField: NSViewRepresentable {
    
    @Binding var text: String
    let placeholder: String
    
    func makeNSView(context: Context) -> NSSecureTextField {
        let textField = NSSecureTextField()
        
        // Native styling
        textField.bezelStyle = .roundedBezel
        textField.isBordered = true
        textField.isBezeled = true
        textField.drawsBackground = true
        
        // Font and alignment
        textField.font = .systemFont(ofSize: 13)
        textField.alignment = .left
        
        // Placeholder
        textField.placeholderString = placeholder
        
        // Delegate for text updates
        textField.delegate = context.coordinator
        
        // Focus ring
        textField.focusRingType = .default
        
        return textField
    }
    
    func updateNSView(_ nsView: NSSecureTextField, context: Context) {
        // Update text if it changed externally
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
        
        // Update placeholder
        nsView.placeholderString = placeholder
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: NativeSecureTextField
        
        init(_ parent: NativeSecureTextField) {
            self.parent = parent
        }
        
        func controlTextDidChange(_ notification: Notification) {
            guard let textField = notification.object as? NSSecureTextField else { return }
            parent.text = textField.stringValue
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        NativeSecureTextField(
            text: .constant(""),
            placeholder: "Enter API key"
        )
        .frame(height: 22)
        
        NativeSecureTextField(
            text: .constant("sk-test-key-12345"),
            placeholder: "Enter API key"
        )
        .frame(height: 22)
    }
    .padding()
    .frame(width: 400)
}

