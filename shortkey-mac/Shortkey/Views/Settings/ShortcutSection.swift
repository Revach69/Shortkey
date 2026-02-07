//
//  ShortcutSection.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// Keyboard shortcut settings section using native "Inset Grouped" Form/Section pattern
struct ShortcutSection: View {
    
    @AppStorage("shortcutDisplay") private var shortcutDisplay = "⌘⇧S"
    @State private var isRecording = false
    @State private var showingShortcutSheet = false
    
    var body: some View {
        Section {
            SettingsRow(label: Strings.Common.shortcut) {
                ShortcutRecorderView(
                    shortcutDisplay: $shortcutDisplay,
                    isRecording: $isRecording,
                    showingSheet: $showingShortcutSheet
                )
            }
        } header: {
            Text(Strings.Settings.shortcut)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    Form {
        ShortcutSection()
    }
    .formStyle(.grouped)
    .frame(width: 500)
}
