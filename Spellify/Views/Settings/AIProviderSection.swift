//
//  AIProviderSection.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// AI Provider settings section with inline button design
struct AIProviderSection: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var aiProviderManager: AIProviderManager
    
    @State private var selectedProvider: String = "OpenAI"
    @State private var apiKey: String = ""
    @State private var showingKeyInput: Bool = false
    @State private var hasStoredKey: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        Section {
            // Provider picker row
            ProviderPickerRow(selectedProvider: $selectedProvider)
            
            // API Key row with inline buttons
            APIKeyField(
                apiKey: $apiKey,
                hasStoredKey: $hasStoredKey,
                showingKeyInput: $showingKeyInput,
                onSave: saveAPIKey,
                onDelete: removeAPIKey
            )
            
            // Model picker row (only when connected)
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
            
            // Connection status row (with refresh button)
            if hasStoredKey {
                ConnectionStatusRow(
                    status: aiProviderManager.status,
                    onTest: {
                        Task {
                            await aiProviderManager.testConnection()
                        }
                    }
                )
            }
            
        } header: {
            // Section header with subtitle and link
            VStack(alignment: .leading, spacing: 4) {
                Text(Strings.Settings.aiProvider)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.primary)
                
                HStack(spacing: 4) {
                    Text(Strings.Settings.aiProviderDescription)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    
                    Link(Strings.Settings.getAPIKey, destination: Constants.openAIKeyURL)
                        .font(.system(size: 11))
                }
            }
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
        
        do {
            try KeychainService.shared.saveAPIKey(apiKey, for: "openai")
            hasStoredKey = true
            showingKeyInput = false
            
            // Automatically test connection after saving
            Task {
                await aiProviderManager.configure(apiKey: apiKey)
                apiKey = ""
                await aiProviderManager.testConnection()
            }
        } catch {
            // Show error notification
            NotificationManager.shared.showNotification(
                title: "Failed to Save API Key",
                message: "Unable to securely store your API key. Please try again."
            )
        }
    }
    
    private func removeAPIKey() {
        KeychainService.shared.deleteAPIKey(for: "openai")
        hasStoredKey = false
        showingKeyInput = false
        apiKey = ""
        
        Task {
            await aiProviderManager.configure(apiKey: "")
        }
    }
}

// MARK: - Preview

#Preview {
    Form {
        AIProviderSection()
            .environmentObject(AIProviderManager())
    }
    .formStyle(.grouped)
    .frame(width: 500)
}
