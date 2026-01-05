//
//  ShortcutSection.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Keyboard shortcut settings section using native "Inset Grouped" Form/Section pattern
struct ShortcutSection: View {
    
    @AppStorage("shortcutDisplay") private var shortcutDisplay = "⌘⇧S"
    @State private var isRecording = false
    
    var body: some View {
        Section {
            SettingsRow(label: Strings.Common.shortcut) {
                ShortcutRecorderView(
                    shortcutDisplay: $shortcutDisplay,
                    isRecording: $isRecording
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
