//
//  APIKeyField.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Button-based API key management (no inline editing)
struct APIKeyField: View {
    
    @Binding var hasStoredKey: Bool
    let onAdd: () -> Void
    let onEdit: () -> Void
    let onDisconnect: () -> Void
    
    var body: some View {
        SettingsRow(label: Strings.Settings.apiKey) {
            if hasStoredKey {
                // Has key state: masked key + Edit + Disconnect buttons
                HStack(spacing: 8) {
                    Text(Constants.maskedAPIKey)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.secondary)
                    
                    // Edit button
                    Button(Strings.Settings.edit) {
                        onEdit()
                    }
                    .controlSize(.regular)
                    
                    // Disconnect button
                    Button(Strings.Common.disconnect) {
                        onDisconnect()
                    }
                    .controlSize(.regular)
                    .foregroundStyle(.red)
                }
            } else {
                // Empty state: Add API Key button
                Button(Strings.Settings.addAPIKey) {
                    onAdd()
                }
                .controlSize(.regular)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    Form {
        Section("API Key States") {
            // Empty state
            APIKeyField(
                hasStoredKey: .constant(false),
                onAdd: {},
                onEdit: {},
                onDisconnect: {}
            )
            
            Divider()
            
            // Has key state
            APIKeyField(
                hasStoredKey: .constant(true),
                onAdd: {},
                onEdit: {},
                onDisconnect: {}
            )
        }
    }
    .formStyle(.grouped)
    .frame(width: 500)
}
