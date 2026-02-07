//
//  HoverButtonStyle.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// A button style that applies a subtle background on hover, following Apple's menu item design pattern
struct HoverButtonStyle: ButtonStyle {
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(isHovered || configuration.isPressed ? Color.accentColor.opacity(0.1) : Color.clear)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}


