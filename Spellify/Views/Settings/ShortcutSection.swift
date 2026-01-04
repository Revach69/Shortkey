//
//  ShortcutSection.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Settings section for keyboard shortcut configuration
struct ShortcutSection: View {
    
    @AppStorage("shortcutDisplay") private var shortcutDisplay = "⌘⇧S"
    @State private var isRecording = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: "keyboard")
                    .font(.title2)
                    .foregroundStyle(.orange)
                
                Text(Strings.Settings.shortcut)
                    .font(.headline)
            }
            
            // Shortcut recorder
            HStack {
                Text("")
                    .frame(width: 80, alignment: .trailing)
                
                ShortcutRecorderView(
                    shortcutDisplay: $shortcutDisplay,
                    isRecording: $isRecording
                )
                
                Spacer()
            }
        }
    }
}

// ShortcutRecorderView is now in Views/Components/ShortcutRecorderView.swift

#Preview {
    ShortcutSection()
        .padding()
        .frame(width: 500)
}


