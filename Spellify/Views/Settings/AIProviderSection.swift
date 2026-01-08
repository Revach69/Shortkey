//
//  AIProviderSection.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// AI Provider settings section with modal-based API key entry
struct AIProviderSection: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var aiProviderManager: AIProviderManager
    
    @State private var selectedProvider: String = "OpenAI"
    @State private var apiKey: String = ""
    @State private var hasStoredKey: Bool = false
    @State private var showingAPIKeyModal: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        Section {
            SettingsRow(label: Strings.Common.status) {
                ConnectionStatusView(
                    status: aiProviderManager.status,
                    fontSize: 13,
                    hasStoredKey: hasStoredKey,
                    onTest: {
                        Task {
                            let _ = await aiProviderManager.testConnection()
                        }
                    },
                    onDisconnect: removeAPIKey
                )
            }
            
            // Provider picker
            ProviderPickerRow(selectedProvider: $selectedProvider)
            
            // API Key row with buttons (no inline input)
            APIKeyField(
                hasStoredKey: $hasStoredKey,
                onAdd: {
                    apiKey = ""
                    showingAPIKeyModal = true
                },
                onEdit: {
                    apiKey = ""
                    showingAPIKeyModal = true
                }
            )
            
            // Model picker row (only when connected)
            if !aiProviderManager.availableModels.isEmpty {
                ModelPickerRow(
                    selectedModel: Binding(
                        get: { aiProviderManager.selectedModel },
                        set: { _ in }
                    ),
                    availableModels: aiProviderManager.availableModels,
                    onModelSelected: { model in
                        aiProviderManager.selectModel(model)
                    }
                )
            }
            
        } header: {
            Text(Strings.Settings.aiProvider)
        }
        .onAppear(perform: checkForStoredKey)
        .sheet(isPresented: $showingAPIKeyModal) {
            APIKeyEntrySheet(
                providerName: aiProviderManager.providerDisplayName,
                apiKeyURL: getProviderAPIKeyURL(),
                apiKey: $apiKey,
                onSave: saveAPIKey,
                onCancel: {
                    showingAPIKeyModal = false
                    apiKey = ""
                }
            )
        }
    }
    
    // MARK: - Actions
    
    private func getProviderAPIKeyURL() -> URL {
        // For now, always OpenAI. When we add more providers, get from aiProviderManager.provider
        URL(string: "https://platform.openai.com/api-keys")!
    }
    
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
            showingAPIKeyModal = false
            
            // Automatically test connection after saving
            Task {
                await aiProviderManager.configure(apiKey: apiKey)
                apiKey = ""
                let _ = await aiProviderManager.testConnection()
            }
        } catch {
            NotificationManager.shared.showError(
                "Unable to securely store your API key. Please try again."
            )
        }
    }
    
    private func removeAPIKey() {
        KeychainService.shared.deleteAPIKey(for: "openai")
        hasStoredKey = false
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
