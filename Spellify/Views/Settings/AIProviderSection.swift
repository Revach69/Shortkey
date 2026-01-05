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
            // Provider picker (no inline status anymore)
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
            
        } header: {
            // Header with status on the right
            HStack {
                Text(Strings.Settings.aiProvider)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                // Connection status component
                ConnectionStatusView(
                    status: aiProviderManager.status,
                    fontSize: 13,
                    hasStoredKey: hasStoredKey,
                    onTest: {
                        Task {
                            let _ = await aiProviderManager.testConnection()
                        }
                    }
                )
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
                let _ = await aiProviderManager.testConnection()
            }
        } catch {
            // Show error notification
            NotificationManager.shared.showError(
                "Unable to securely store your API key. Please try again."
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
