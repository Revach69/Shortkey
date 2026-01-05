//
//  SettingsRow.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// A standard settings row with leading label and trailing content
/// Represents the macOS System Settings "Inset Grouped" row pattern:
/// - Leading: Label text
/// - Trailing: Control/value (toggle, picker, button, etc.)
/// - Consistent alignment and spacing
struct SettingsRow<TrailingContent: View>: View {
    
    let label: String
    let trailingContent: TrailingContent
    
    init(label: String, @ViewBuilder trailingContent: () -> TrailingContent) {
        self.label = label
        self.trailingContent = trailingContent()
    }
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.primary)
            
            Spacer()
            
            trailingContent
        }
    }
}

#Preview {
    Form {
        Section("Example") {
            SettingsRow(label: "Example Setting") {
                Toggle("", isOn: .constant(true))
                    .labelsHidden()
            }
            
            SettingsRow(label: "Another Setting") {
                Text("Value")
                    .foregroundStyle(.secondary)
            }
        }
    }
    .formStyle(.grouped)
    .frame(width: 500)
}

