//
//  AIProviderSection.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Settings section for AI provider configuration (coordinator view)
struct AIProviderSection: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var aiProviderManager: AIProviderManager
    
    @State private var apiKey: String = ""
    @State private var isTesting: Bool = false
    @State private var showingKeyInput: Bool = false
    @State private var hasStoredKey: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            AIProviderHeader()
            
            // API Key input
            APIKeyField(
                apiKey: $apiKey,
                hasStoredKey: $hasStoredKey,
                showingKeyInput: $showingKeyInput,
                isTesting: $isTesting,
                onSave: saveAPIKey,
                onDelete: removeAPIKey,
                onTest: testConnection
            )
            
            // Model picker
            if !aiProviderManager.availableModels.isEmpty {
                ModelPickerRow(
                    selectedModel: Binding(
                        get: { aiProviderManager.selectedModel },
                        set: { _ in } // Model selection handled by callback
                    ),
                    availableModels: aiProviderManager.availableModels,
                    onModelSelected: { model in
                        aiProviderManager.selectModel(model)
                    }
                )
            }
            
            // Connection status
            ConnectionStatusRow(status: aiProviderManager.status)
        }
        .onAppear(perform: checkForStoredKey)
    }
    
    // MARK: - Actions
    
    private func checkForStoredKey() {
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

// MARK: - Preview

#Preview {
    AIProviderSection()
        .environmentObject(AIProviderManager())
        .padding()
        .frame(width: 500)
}
