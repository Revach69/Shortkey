//
//  ProviderStatusView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Shows the current AI provider connection status
struct ProviderStatusView: View {
    
    @EnvironmentObject var aiProviderManager: AIProviderManager
    
    private var hasStoredKey: Bool {
        switch aiProviderManager.status {
        case .notConfigured:
            return false
        case .connected, .connecting, .error:
            return true
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            // Left: Provider [• Model]
            HStack(spacing: 0) {
                Text(aiProviderManager.providerDisplayName)
                    .foregroundStyle(.primary)
                
                // Show model only when not "Not configured"
                if case .notConfigured = aiProviderManager.status {
                    // No model shown
                } else if case .connected(let model) = aiProviderManager.status {
                    Text(" " + Constants.textSeparator + " " + model)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            // Right: Connection status component
            ConnectionStatusView(
                status: aiProviderManager.status,
                fontSize: 14,
                hasStoredKey: hasStoredKey,
                onTest: {
                    Task {
                        let _ = await aiProviderManager.testConnection()
                    }
                }
            )
        }
        .font(.callout)
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 10)
    }
}

#Preview {
    VStack {
        ProviderStatusView()
            .environmentObject({
                let manager = AIProviderManager()
                return manager
            }())
    }
    .frame(width: 300)
}


