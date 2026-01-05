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
    @State private var isTesting: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            StatusIndicator(status: aiProviderManager.status)
            
            Text(aiProviderManager.providerDisplayName)
                .foregroundStyle(.primary)
            
            Text(Constants.textSeparator)
                .foregroundStyle(.secondary)
            
            Text(aiProviderManager.status.displayText)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            
            Spacer()
            
            // Refresh/Test connection button
            Button(action: {
                Task {
                    isTesting = true
                    let _ = await aiProviderManager.testConnection()
                    isTesting = false
                }
            }) {
                if isTesting {
                    ProgressView()
                        .scaleEffect(0.6)
                        .frame(width: 14, height: 14)
                } else {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
            .help(Strings.Common.testConnection)
            .disabled(isTesting)
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


