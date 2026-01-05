//
//  APIKeyField.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Inline compact API key management with clean text button styling
struct APIKeyField: View {
    
    @Binding var apiKey: String
    @Binding var hasStoredKey: Bool
    @Binding var showingKeyInput: Bool
    
    let onSave: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        SettingsRow {
            // Custom label with help icon
            HStack(spacing: 4) {
                Text(Strings.Settings.apiKey)
                    .foregroundStyle(.primary)
                
                Button(action: {
                    NSWorkspace.shared.open(Constants.openAIKeyURL)
                }) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help(Strings.Settings.getAPIKey)
            }
        } trailingContent: {
            if hasStoredKey && !showingKeyInput {
                // View state: masked key + clean text buttons
                HStack(spacing: 8) {
                    Text(Constants.maskedAPIKey)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.secondary)
                    
                    // Edit button (clean text, no border)
                    Button(Strings.Common.edit) {
                        showingKeyInput = true
                        apiKey = ""
                    }
                    .controlSize(.regular)
                    
                    // Remove button (clean text, no border, red)
                    Button(Strings.Common.disconnect) {
                        onDelete()
                    }
                    .controlSize(.regular)
                    .foregroundStyle(.red)
                }
            } else {
                // Input state: input field + buttons
                HStack(spacing: 8) {
                    SecureTextField(text: $apiKey, placeholder: "")
                        .frame(height: 22)
                    
                    if hasStoredKey {
                        // Cancel button (clean text, no border)
                        Button(Strings.Common.cancel) {
                            showingKeyInput = false
                            apiKey = ""
                        }
                        .controlSize(.regular)
                    }
                    
                    // Save button (prominent style)
                    Button(Strings.Common.save) {
                        onSave()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    .disabled(apiKey.isEmpty)
                }
            }
        }
    }
}

#Preview {
    Form {
        Section("API Key States") {
            // Empty state (inline input)
            APIKeyField(
                apiKey: .constant(""),
                hasStoredKey: .constant(false),
                showingKeyInput: .constant(false),
                onSave: {},
                onDelete: {}
            )
            
            Divider()
            
            // View state (with stored key)
            APIKeyField(
                apiKey: .constant(""),
                hasStoredKey: .constant(true),
                showingKeyInput: .constant(false),
                onSave: {},
                onDelete: {}
            )
            
            Divider()
            
            // Edit state (changing key)
            APIKeyField(
                apiKey: .constant("test-key"),
                hasStoredKey: .constant(true),
                showingKeyInput: .constant(true),
                onSave: {},
                onDelete: {}
            )
        }
    }
    .formStyle(.grouped)
    .frame(width: 500)
}
