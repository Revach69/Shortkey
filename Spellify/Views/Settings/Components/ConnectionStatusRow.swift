//
//  ConnectionStatusRow.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Connection status display row
struct ConnectionStatusRow: View {
    
    let status: ConnectionStatus
    
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
        HStack {
            Text(Strings.Common.status)
                .frame(width: 80, alignment: .trailing)
            
            StatusIndicator(status: status)
            
            Text(statusText)
                .font(.callout)
                .foregroundStyle(statusColor)
        }
    }
}

#Preview {
    VStack {
        ConnectionStatusRow(status: .connected(model: "gpt-4o"))
        ConnectionStatusRow(status: .connecting)
        ConnectionStatusRow(status: .notConfigured)
        ConnectionStatusRow(status: .error(message: "Invalid API key"))
    }
    .padding()
}

