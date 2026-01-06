//
//  SettingsModalContainer.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Reusable container for settings modal sheets
/// Provides consistent styling, padding, and layout for all settings modals
struct SettingsModalContainer<Content: View, Footer: View>: View {
    
    // MARK: - Properties
    
    let title: String
    let width: CGFloat
    let height: CGFloat
    @ViewBuilder let content: () -> Content
    @ViewBuilder let footer: () -> Footer
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Title
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            Divider()
            
            // Content
            VStack(spacing: 12) {
                content()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            
            Divider()
            
            // Footer buttons
            HStack {
                footer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .frame(width: width, height: height)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// MARK: - Convenience Initializer (for modals without content divider)

extension SettingsModalContainer {
    
    /// Initializer for modals that don't need a divider above content (like About)
    init(
        title: String,
        width: CGFloat,
        height: CGFloat,
        showContentDivider: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.title = title
        self.width = width
        self.height = height
        self.content = content
        self.footer = footer
    }
}

// MARK: - Preview

#Preview("Standard Modal") {
    SettingsModalContainer(
        title: "Sample Modal",
        width: 400,
        height: 200
    ) {
        Text("Content goes here")
            .frame(maxWidth: .infinity, alignment: .leading)
    } footer: {
        Spacer()
        
        Button("Cancel") {}
        
        Button("Save") {}
            .buttonStyle(.borderedProminent)
    }
}

#Preview("About Style") {
    SettingsModalContainer(
        title: "About",
        width: 320,
        height: 280
    ) {
        VStack(spacing: 16) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 64))
                .foregroundStyle(.blue)
            
            Text("Spellify")
                .font(.system(size: 24, weight: .semibold))
        }
    } footer: {
        Spacer()
        
        Button("OK") {}
            .buttonStyle(.borderedProminent)
    }
}

