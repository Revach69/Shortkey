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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 2) {
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
        .padding(.vertical, 6)
        .padding(.horizontal, 6)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 4)
                .shadow(color: Color.black.opacity(0.08), radius: 1, x: 0, y: 1)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
        }
        .focusable()
        .focused($isFocused)
        .onAppear {
            // Auto-focus when view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
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

/// A single row in the action picker - macOS menu style
struct ActionPickerRow: View {
    
    let action: SpellAction
    let isSelected: Bool
    let isHovered: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: action.icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 16)
            
            Text(action.name)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.primary)
                .lineLimit(1)
            
            Spacer(minLength: 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background {
            if isSelected || isHovered {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.accentColor.opacity(0.1))
            }
        }
        .contentShape(Rectangle())
        .animation(.easeInOut(duration: 0.15), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isHovered)
    }
}

#Preview {
    ActionPickerView(
        actions: [
            SpellAction(name: "Fix Grammar", description: ""),
            SpellAction(name: "Translate to Spanish", description: ""),
            SpellAction(name: "Make Shorter", description: "")
        ],
        onSelect: { _ in },
        onDismiss: {}
    )
    .frame(width: 280)
    .padding(40)
    .background(Color.gray.opacity(0.2))
}


