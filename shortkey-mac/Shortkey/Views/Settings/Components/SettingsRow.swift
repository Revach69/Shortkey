//
//  SettingsRow.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// A standard settings row with leading label and trailing content
/// Represents the macOS System Settings "Inset Grouped" row pattern:
/// - Leading: Label text or custom view
/// - Trailing: Control/value (toggle, picker, button, etc.)
/// - Consistent alignment and spacing
struct SettingsRow<LeadingContent: View, TrailingContent: View>: View {
    
    let leadingContent: LeadingContent
    let trailingContent: TrailingContent
    
    // Simple string label initializer
    init(label: String, @ViewBuilder trailingContent: () -> TrailingContent) where LeadingContent == Text {
        self.leadingContent = Text(label).foregroundStyle(.primary)
        self.trailingContent = trailingContent()
    }
    
    // Custom label view initializer
    init(@ViewBuilder leadingContent: () -> LeadingContent, @ViewBuilder trailingContent: () -> TrailingContent) {
        self.leadingContent = leadingContent()
        self.trailingContent = trailingContent()
    }
    
    var body: some View {
        HStack {
            leadingContent
            
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

