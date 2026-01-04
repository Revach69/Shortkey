//
//  ActionRowView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// A single action row with name and edit/delete buttons
struct ActionRowView: View {
    
    let action: SpellAction
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        HStack {
            Text(action.name)
                .lineLimit(1)
            
            Spacer()
            
            if isHovered {
                HStack(spacing: 4) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help("Edit")
                    
                    Button(action: onDelete) {
                        Image(systemName: "xmark")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help("Delete")
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(isHovered ? Color.primary.opacity(0.05) : Color.clear)
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        ActionRowView(
            action: SpellAction(name: "Fix Grammar", prompt: "Fix grammar"),
            onEdit: {},
            onDelete: {}
        )
        ActionRowView(
            action: SpellAction(name: "Translate to Spanish", prompt: "Translate"),
            onEdit: {},
            onDelete: {}
        )
    }
    .frame(width: 300)
}


