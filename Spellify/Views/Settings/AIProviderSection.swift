//
//  AIProviderSection.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Settings section for AI provider configuration
struct AIProviderSection: View {
    
    @EnvironmentObject var aiProviderManager: AIProviderManager
    
    @State private var apiKey: String = ""
    @State private var isTesting: Bool = false
    @State private var showingKeyInput: Bool = false
    @State private var hasStoredKey: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: "brain")
                    .font(.title2)
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(Strings.Settings.openAITitle)
                        .font(.headline)
                    
                    HStack(spacing: 4) {
                        Text(Strings.Settings.openAIDescription)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        
                        Link(Strings.Settings.getAPIKey, destination: Constants.openAIKeyURL)
                            .font(.callout)
                    }
                }
            }
            
            // API Key input
            HStack(alignment: .top) {
                Text(Strings.Settings.apiKey)
                    .frame(width: 80, alignment: .trailing)
                    .padding(.top, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    if hasStoredKey && !showingKeyInput {
                        // Show masked key (read-only) with actions
                        HStack {
                            Text("sk-••••••••••••••••••••••••")
                                .font(.system(.body, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(6)
                            
                            // Change button
                            Button("Change") {
                                showingKeyInput = true
                                apiKey = ""
                            }
                            
                            // Delete button
                            Button("Delete") {
                                removeAPIKey()
                            }
                            .foregroundStyle(.red)
                        }
                    } else {
                        // Editable key input with Save/Cancel
                        HStack {
                            SecureTextField(text: $apiKey, placeholder: "sk-...")
                            
                            if hasStoredKey {
                                // Cancel button (only shown when changing existing key)
                                Button("Cancel") {
                                    showingKeyInput = false
                                    apiKey = ""
                                }
                            }
                            
                            // Save button
                            Button("Save") {
                                saveAPIKey()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(apiKey.isEmpty)
                        }
                        
                        // Test button below
                        if hasStoredKey || !apiKey.isEmpty {
                            Button(action: {
                                testConnection()
                            }) {
                                HStack(spacing: 4) {
                                    if isTesting {
                                        ProgressView()
                                            .scaleEffect(0.7)
                                            .frame(width: 12, height: 12)
                                    }
                                    Text(isTesting ? "Testing..." : "Test Connection")
                                }
                            }
                            .disabled(isTesting)
                        }
                    }
                }
            }
            
            // Model picker
            if !aiProviderManager.availableModels.isEmpty {
                HStack {
                    Text(Strings.Settings.model)
                        .frame(width: 80, alignment: .trailing)
                    
                    Picker("", selection: Binding(
                        get: { aiProviderManager.selectedModel },
                        set: { aiProviderManager.selectModel($0) }
                    )) {
                        ForEach(aiProviderManager.availableModels) { model in
                            Text(model.name).tag(model)
                        }
                    }
                    .labelsHidden()
                    .frame(maxWidth: 200)
                }
            }
            
            // Status
            HStack {
                Text("")
                    .frame(width: 80, alignment: .trailing)
                
                StatusIndicator(status: aiProviderManager.status)
                
                Text(statusText)
                    .font(.callout)
                    .foregroundStyle(statusColor)
            }
        }
        .onAppear {
            checkForStoredKey()
        }
    }
    
    // MARK: - Computed Properties
    
    private var statusText: String {
        switch aiProviderManager.status {
        case .connected:
            return Strings.Settings.connected
        case .connecting:
            return "Testing..."
        case .notConfigured:
            return Strings.Settings.notConfigured
        case .error(let message):
            return message
        }
    }
    
    private var statusColor: Color {
        switch aiProviderManager.status {
        case .connected:
            return .green
        case .connecting:
            return .orange
        case .notConfigured:
            return .secondary
        case .error:
            return .red
        }
    }
    
    // MARK: - Actions
    
    private func checkForStoredKey() {
        // Check if there's a key in keychain
        if let storedKey = KeychainService.shared.getAPIKey(for: "openai"), !storedKey.isEmpty {
            hasStoredKey = true
        } else {
            hasStoredKey = false
        }
    }
    
    private func saveAPIKey() {
        guard !apiKey.isEmpty else { return }
        
        // Save to keychain
        KeychainService.shared.saveAPIKey(apiKey, for: "openai")
        
        // Update UI state
        hasStoredKey = true
        showingKeyInput = false
        
        // Configure provider
        Task {
            await aiProviderManager.configure(apiKey: apiKey)
            apiKey = "" // Clear the text field
        }
    }
    
    private func removeAPIKey() {
        // Remove from keychain
        KeychainService.shared.deleteAPIKey(for: "openai")
        hasStoredKey = false
        showingKeyInput = false
        apiKey = ""
        
        // Reset provider
        Task {
            await aiProviderManager.configure(apiKey: "")
        }
    }
    
    private func testConnection() {
        isTesting = true
        
        Task {
            // If testing with a new key, save it first
            if !apiKey.isEmpty {
                await aiProviderManager.configure(apiKey: apiKey)
            }
            
            let _ = await aiProviderManager.testConnection()
            isTesting = false
        }
    }
}

#Preview {
    AIProviderSection()
        .environmentObject(AIProviderManager())
        .padding()
        .frame(width: 500)
}


