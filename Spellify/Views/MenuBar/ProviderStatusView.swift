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


