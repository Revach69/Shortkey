//
//  ConnectionStatusView.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// Reusable connection status display component
/// 
/// Displays AI provider connection status with:
/// - Colored status dot (yellow/green/orange/red)
/// - Status text (secondary color)
/// - Optional refresh button (only for error states)
///
/// Usage:
/// ```swift
/// ConnectionStatusView(
///     status: .connected(model: "gpt-4o"),
///     fontSize: 13,
///     hasStoredKey: true,
///     onTest: { await testConnection() }
/// )
/// ```
struct ConnectionStatusView: View {
    
    // MARK: - Properties
    
    let status: ConnectionStatus
    let fontSize: CGFloat
    let hasStoredKey: Bool
    var onTest: (() -> Void)?
    var onDisconnect: (() -> Void)?
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 6) {
            StatusIndicator(status: status)
                .frame(width: 6, height: 6)
            
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
            
            // Disconnect button (only when connected)
            if case .connected = status, let onDisconnect = onDisconnect {
                Button(Strings.Common.disconnect) {
                    onDisconnect()
                }
                .foregroundStyle(.red)
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

