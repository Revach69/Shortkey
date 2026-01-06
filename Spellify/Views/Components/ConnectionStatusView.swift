//
//  ConnectionStatusView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Reusable connection status display component
/// Shows: ● Status Text [↻]
struct ConnectionStatusView: View {
    
    let status: ConnectionStatus
    let fontSize: CGFloat
    let hasStoredKey: Bool
    var onTest: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 6) {
            // Status dot
            Circle()
                .fill(status.statusColor)
                .frame(width: 6, height: 6)
            
            // Status text
            Text(status.displayText)
                .font(.system(size: fontSize))
                .foregroundStyle(.secondary)
            
            // Refresh button (only for error and connecting states)
            if hasStoredKey, let onTest = onTest {
                switch status {
                case .error, .connecting:
                    Button(action: onTest) {
                        if case .connecting = status {
                            ProgressView()
                                .scaleEffect(0.6)
                                .frame(width: 16, height: 16)
                        } else {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: fontSize))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(status == .connecting)
                    .help(Strings.Common.testConnection)
                case .notConfigured, .connected:
                    EmptyView()
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        // Not configured (no refresh)
        ConnectionStatusView(
            status: .notConfigured,
            fontSize: 13,
            hasStoredKey: false
        )
        
        // Connected (with refresh)
        ConnectionStatusView(
            status: .connected(model: "gpt-4o"),
            fontSize: 13,
            hasStoredKey: true,
            onTest: {}
        )
        
        // Error (with refresh)
        ConnectionStatusView(
            status: .error(message: "Invalid API key"),
            fontSize: 13,
            hasStoredKey: true,
            onTest: {}
        )
        
        // Connecting (with spinner)
        ConnectionStatusView(
            status: .connecting,
            fontSize: 13,
            hasStoredKey: true,
            onTest: {}
        )
    }
    .padding()
}

