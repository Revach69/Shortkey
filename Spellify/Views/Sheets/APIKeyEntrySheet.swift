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
    
    @FocusState private var isInputFocused: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Title
            HStack {
                Text("\(providerName) API Key")
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            Divider()
            
            // Content
            VStack(spacing: 16) {
                // Native secure input field
                NativeSecureTextField(
                    text: $apiKey,
                    placeholder: "sk-..."
                )
                .frame(height: 22)
                .focused($isInputFocused)
                
                // Get API key link
                HStack {
                    Link(destination: apiKeyURL) {
                        HStack(spacing: 4) {
                            Text(Strings.Settings.getAPIKey)
                                .font(.system(size: 13))
                            Image(systemName: "arrow.forward")
                                .font(.system(size: 11))
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            
            Divider()
            
            // Footer buttons
            HStack {
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
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .frame(width: 400, height: 180)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            // Auto-focus the input field
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isInputFocused = true
            }
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

