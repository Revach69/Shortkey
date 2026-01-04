//
//  ActionPickerView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// SwiftUI content for the action picker panel
struct ActionPickerView: View {
    
    let actions: [SpellAction]
    let onSelect: (SpellAction) -> Void
    let onDismiss: () -> Void
    
    @State private var selectedIndex: Int = 0
    @State private var hoveredIndex: Int?
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(actions.enumerated()), id: \.element.id) { index, action in
                ActionPickerRow(
                    action: action,
                    isSelected: index == selectedIndex,
                    isHovered: index == hoveredIndex
                )
                .onTapGesture {
                    onSelect(action)
                }
                .onHover { hovering in
                    if hovering {
                        hoveredIndex = index
                        selectedIndex = index
                    } else {
                        hoveredIndex = nil
                    }
                }
            }
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onKeyPress(.upArrow) {
            selectedIndex = max(0, selectedIndex - 1)
            return .handled
        }
        .onKeyPress(.downArrow) {
            selectedIndex = min(actions.count - 1, selectedIndex + 1)
            return .handled
        }
        .onKeyPress(.return) {
            if selectedIndex < actions.count {
                onSelect(actions[selectedIndex])
            }
            return .handled
        }
        .onKeyPress(.escape) {
            onDismiss()
            return .handled
        }
    }
}

/// A single row in the action picker
struct ActionPickerRow: View {
    
    let action: SpellAction
    let isSelected: Bool
    let isHovered: Bool
    
    var body: some View {
        HStack {
            Text(action.name)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isSelected || isHovered ? Color.accentColor.opacity(0.2) : Color.clear)
        .cornerRadius(4)
        .contentShape(Rectangle())
    }
}

#Preview {
    ActionPickerView(
        actions: [
            SpellAction(name: "Fix Grammar", prompt: ""),
            SpellAction(name: "Translate to Spanish", prompt: ""),
            SpellAction(name: "Make Shorter", prompt: "")
        ],
        onSelect: { _ in },
        onDismiss: {}
    )
    .frame(width: 250)
}


