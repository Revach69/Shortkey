//
//  APIKeyEntrySheet.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Dedicated modal for entering or editing API keys
struct APIKeyEntrySheet: View {
    
    // MARK: - Properties
    
    let providerName: String
    let apiKeyURL: URL
    @Binding var apiKey: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    
    // MARK: - Body
    
    var body: some View {
        SettingsModalContainer(
            title: "\(providerName) API Key",
            width: 400,
            height: 220
        ) {
            InputFormField(
                label: "Enter your key",
                text: $apiKey,
                placeholder: "sk-...",
                isSecure: true
            )
            
            HStack {
                Link(destination: apiKeyURL) {
                    Text(Strings.Settings.getAPIKey)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
        } footer: {
            Spacer()
            
            Button(Strings.Common.cancel) {
                onCancel()
            }
            .keyboardShortcut(.cancelAction)
            
            Button(Strings.Settings.saveAndTest) {
                onSave()
            }
            .buttonStyle(.borderedProminent)
            .keyboardShortcut(.defaultAction)
            .disabled(apiKey.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
}

// MARK: - Preview

#Preview("Empty") {
    APIKeyEntrySheet(
        providerName: "OpenAI",
        apiKeyURL: URL(string: "https://platform.openai.com/api-keys")!,
        apiKey: .constant(""),
        onSave: {},
        onCancel: {}
    )
}

#Preview("With Key") {
    APIKeyEntrySheet(
        providerName: "OpenAI",
        apiKeyURL: URL(string: "https://platform.openai.com/api-keys")!,
        apiKey: .constant("sk-test-key-12345"),
        onSave: {},
        onCancel: {}
    )
}

