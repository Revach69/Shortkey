//
//  StatusIndicator.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// A colored dot indicating connection status
struct StatusIndicator: View {
    
    let status: ConnectionStatus
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
    }
    
    private var color: Color {
        switch status {
        case .connected:
            return .green
        case .connecting:
            return .orange
        case .notConfigured:
            return .yellow
        case .error:
            return .red
        }
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



