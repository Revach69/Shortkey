//
//  KeyboardKeyView.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// A single keyboard key visual representation
struct KeyboardKeyView: View {
    
    let symbol: String
    
    var body: some View {
        Text(symbol)
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(.primary)
            .frame(minWidth: 18, minHeight: 18)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color(NSColor.separatorColor), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 4) {
        KeyboardKeyView(symbol: "⌘")
        KeyboardKeyView(symbol: "⇧")
        KeyboardKeyView(symbol: "S")
    }
    .padding()
}

