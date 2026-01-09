//
//  ConnectionStatus.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation
import SwiftUI

/// Represents the connection status of an AI provider
///
/// Cases:
/// - `notConfigured`: No API key configured (yellow)
/// - `connecting`: Testing connection (orange)
/// - `connected(model)`: Successfully connected with model name (green)
/// - `error(message)`: Connection failed with error message (red)
enum ConnectionStatus: Equatable {
    case notConfigured
    case connecting
    case connected(model: String)
    case error(message: String)
    
    // MARK: - Computed Properties
    
    var isReady: Bool {
        if case .connected = self {
            return true
        }
        return false
    }
    
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



