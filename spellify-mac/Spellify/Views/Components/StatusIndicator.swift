//
//  StatusIndicator.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// A colored dot indicating connection status
/// Reusable component that delegates color logic to ConnectionStatus model
struct StatusIndicator: View {
    
    let status: ConnectionStatus
    
    var body: some View {
        Circle()
            .fill(status.statusColor)
            .frame(width: 8, height: 8)
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack {
            StatusIndicator(status: .connected(model: "gpt-4o"))
            Text("Connected")
        }
        HStack {
            StatusIndicator(status: .connecting)
            Text("Connecting")
        }
        HStack {
            StatusIndicator(status: .notConfigured)
            Text("Not Configured")
        }
        HStack {
            StatusIndicator(status: .error(message: "Error"))
            Text("Error")
        }
    }
    .padding()
}



