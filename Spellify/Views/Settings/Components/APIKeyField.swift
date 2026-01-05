//
//  APIKeyField.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// API key input field with save/change/delete/test actions
struct APIKeyField: View {
    
    @Binding var apiKey: String
    @Binding var hasStoredKey: Bool
    @Binding var showingKeyInput: Bool
    @Binding var isTesting: Bool
    
    let onSave: () -> Void
    let onDelete: () -> Void
    let onTest: () -> Void
    
    var body: some View {
        HStack(alignment: .top) {
            Text(Strings.Settings.apiKey)
                .frame(width: 80, alignment: .trailing)
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                if hasStoredKey && !showingKeyInput {
                    // Show masked key (read-only) with actions
                    HStack {
                        Text(Constants.maskedAPIKey)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(6)
                        
                        Button(Strings.Common.change) {
                            showingKeyInput = true
                            apiKey = ""
                        }
                        
                        Button(Strings.Common.delete) {
                            onDelete()
                        }
                        .foregroundStyle(.red)
                    }
                } else {
                    // Editable key input with Save/Cancel
                    HStack {
                        SecureTextField(text: $apiKey, placeholder: "sk-...")
                        
                        if hasStoredKey {
                            Button(Strings.Common.cancel) {
                                showingKeyInput = false
                                apiKey = ""
                            }
                        }
                        
                        Button(Strings.Common.save) {
                            onSave()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(apiKey.isEmpty)
                    }
                    
                    // Test button below
                    if hasStoredKey || !apiKey.isEmpty {
                        Button(action: onTest) {
                            HStack(spacing: 4) {
                                if isTesting {
                                    ProgressView()
                                        .scaleEffect(0.7)
                                        .frame(width: 12, height: 12)
                                }
                                Text(isTesting ? Strings.Common.testing : Strings.Common.testConnection)
                            }
                        }
                        .disabled(isTesting)
                    }
                }
            }
        }
    }
}

#Preview {
    VStack {
        APIKeyField(
            apiKey: .constant(""),
            hasStoredKey: .constant(false),
            showingKeyInput: .constant(true),
            isTesting: .constant(false),
            onSave: {},
            onDelete: {},
            onTest: {}
        )
        
        Divider()
        
        APIKeyField(
            apiKey: .constant(""),
            hasStoredKey: .constant(true),
            showingKeyInput: .constant(false),
            isTesting: .constant(false),
            onSave: {},
            onDelete: {},
            onTest: {}
        )
    }
    .padding()
    .frame(width: 500)
}

