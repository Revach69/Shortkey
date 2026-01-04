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
            HStack {
                Text(Strings.Settings.apiKey)
                    .frame(width: 80, alignment: .trailing)
                
                SecureTextField(text: $apiKey, placeholder: "sk-...")
                
                Button(Strings.Settings.test) {
                    testConnection()
                }
                .disabled(apiKey.isEmpty || isTesting)
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
    
    private func testConnection() {
        isTesting = true
        
        Task {
            await aiProviderManager.configure(apiKey: apiKey)
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


