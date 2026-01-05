//
//  ConnectionStatusRow.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Connection status display row with optional refresh/test button
struct ConnectionStatusRow: View {
    
    let status: ConnectionStatus
    var onTest: (() -> Void)? = nil
    
    private var statusText: String {
        switch status {
        case .connected:
            return Strings.Settings.connected
        case .connecting:
            return Strings.Common.testing
        case .notConfigured:
            return Strings.Settings.notConfigured
        case .error(let message):
            return message
        }
    }
    
    private var statusColor: Color {
        switch status {
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
    
    var body: some View {
        HStack(spacing: 8) {
            Text(Strings.Common.status)
                .font(.system(size: 13))
                .foregroundStyle(.primary)
            
            Spacer()
            
            StatusIndicator(status: status)
            
            Text(statusText)
                .font(.system(size: 13))
                .foregroundStyle(statusColor)
            
            // Optional refresh/test button
            if let onTest = onTest {
                Button(action: onTest) {
                    if case .connecting = status {
                        ProgressView()
                            .scaleEffect(0.6)
                            .frame(width: 16, height: 16)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
                .disabled(status == .connecting)
                .help(Strings.Common.testConnection)
            }
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        ConnectionStatusRow(status: .connected(model: "gpt-4o"), onTest: {})
        ConnectionStatusRow(status: .connecting, onTest: {})
        ConnectionStatusRow(status: .notConfigured)
        ConnectionStatusRow(status: .error(message: "Invalid API key"), onTest: {})
    }
    .padding()
}
