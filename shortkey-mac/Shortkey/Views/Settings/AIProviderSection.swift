//
//  AIProviderSection.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// AI Provider settings section with modal-based API key entry
struct AIProviderSection: View {

    // MARK: - Properties

    @EnvironmentObject var aiProviderManager: AIProviderManager

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
            ProviderPickerRow(
                selectedProviderId: Binding(
                    get: { aiProviderManager.activeProviderId },
                    set: { newId in
                        Task {
                            await aiProviderManager.switchProvider(to: newId)
                            checkForStoredKey()
                        }
                    }
                ),
                providers: aiProviderManager.providers
            )

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
                apiKeyURL: aiProviderManager.activeProvider.apiKeyURL,
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

    private func checkForStoredKey() {
        let providerId = aiProviderManager.activeProviderId
        if let storedKey = KeychainService.shared.getAPIKey(for: providerId), !storedKey.isEmpty {
            hasStoredKey = true
        } else {
            hasStoredKey = false
        }
    }

    private func saveAPIKey() {
        guard !apiKey.isEmpty else { return }

        let providerId = aiProviderManager.activeProviderId

        do {
            try KeychainService.shared.saveAPIKey(apiKey, for: providerId)
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
        let providerId = aiProviderManager.activeProviderId
        KeychainService.shared.deleteAPIKey(for: providerId)
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
