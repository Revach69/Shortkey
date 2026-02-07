//
//  ActionRowView.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// A single action row with name and edit/delete buttons
struct ActionRowView: View {
    
    let action: SpellAction
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: action.icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 16)
            
            Text(action.name)
                .lineLimit(1)
            
            Spacer()
            
            if isHovered {
                HStack(spacing: 4) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                            .frame(width: 24, height: 24)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                    .help("Edit")
                    
                    Button(action: onDelete) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                            .frame(width: 24, height: 24)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                    .help("Delete")
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(isHovered ? Color.accentColor.opacity(0.08) : Color.clear)
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        ActionRowView(
            action: SpellAction(name: "Fix Grammar", description: "Fix grammar", icon: "text.badge.checkmark"),
            onEdit: {},
            onDelete: {}
        )
        ActionRowView(
            action: SpellAction(name: "Translate to Spanish", description: "Translate", icon: "globe"),
            onEdit: {},
            onDelete: {}
        )
    }
    .frame(width: 300)
}


