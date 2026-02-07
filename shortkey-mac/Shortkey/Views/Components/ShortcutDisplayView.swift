//
//  ShortcutDisplayView.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// Displays a keyboard shortcut as individual key views
struct ShortcutDisplayView: View {
    
    let shortcut: String
    
    private var keys: [String] {
        // Parse shortcut string like "⌘⇧S" into ["⌘", "⇧", "S"]
        var result: [String] = []
        
        for char in shortcut {
            let charString = String(char)
            // Skip spaces and pluses
            if charString != " " && charString != "+" {
                result.append(charString)
            }
        }
        
        return result
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(keys, id: \.self) { key in
                KeyboardKeyView(symbol: key)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        ShortcutDisplayView(shortcut: "⌘⇧S")
        ShortcutDisplayView(shortcut: "⌘K")
        ShortcutDisplayView(shortcut: "⌃⌥⌘T")
    }
    .padding()
}

