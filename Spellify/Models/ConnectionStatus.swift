//
//  ConnectionStatus.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
import SwiftUI

/// Represents the connection status of an AI provider
enum ConnectionStatus: Equatable {
    case notConfigured
    case connecting
    case connected(model: String)
    case error(message: String)
    
    /// Whether the provider is ready to process requests
    var isReady: Bool {
        if case .connected = self {
            return true
        }
        return false
    }
    
    /// Human-readable status text
    var displayText: String {
        switch self {
        case .notConfigured:
            return "Not configured"
        case .connecting:
            return "Connecting..."
        case .connected:
            return "Connected"
        case .error(let message):
            return message
        }
    }
    
    /// Color for status indicator and text
    var statusColor: Color {
        switch self {
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



