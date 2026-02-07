//
//  ActionPickerView.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// Represents an item in the picker (action or chain)
private enum PickerItem: Identifiable {
    case action(SpellAction)
    case chain(ActionChain)

    var id: UUID {
        switch self {
        case .action(let action): return action.id
        case .chain(let chain): return chain.id
        }
    }

    var name: String {
        switch self {
        case .action(let action): return action.name
        case .chain(let chain): return chain.name
        }
    }

    var icon: String {
        switch self {
        case .action(let action): return action.icon
        case .chain(let chain): return chain.icon
        }
    }

    var subtitle: String? {
        switch self {
        case .action: return nil
        case .chain(let chain):
            return "\(chain.steps.count) steps"
        }
    }
}

/// SwiftUI content for the action picker panel
struct ActionPickerView: View {

    let actions: [SpellAction]
    let chains: [ActionChain]
    let actionsManager: ActionsManager?
    let onSelectAction: (SpellAction) -> Void
    let onSelectChain: (ActionChain) -> Void
    let onDismiss: () -> Void

    @State private var selectedIndex: Int = 0
    @State private var hoveredIndex: Int?
    @FocusState private var isFocused: Bool

    private var items: [PickerItem] {
        var result: [PickerItem] = actions.map { .action($0) }
        for chain in chains {
            result.append(.chain(chain))
        }
        return result
    }

    var body: some View {
        VStack(spacing: 2) {
            ForEach(Array(actions.enumerated()), id: \.element.id) { index, action in
                ActionPickerRow(
                    name: action.name,
                    icon: action.icon,
                    subtitle: nil,
                    isSelected: index == selectedIndex,
                    isHovered: index == hoveredIndex
                )
                .onTapGesture {
                    onSelectAction(action)
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

            if !chains.isEmpty {
                Divider()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 2)

                ForEach(Array(chains.enumerated()), id: \.element.id) { chainIndex, chain in
                    let globalIndex = actions.count + chainIndex
                    ActionPickerRow(
                        name: chain.name,
                        icon: chain.icon,
                        subtitle: stepNames(for: chain),
                        isSelected: globalIndex == selectedIndex,
                        isHovered: globalIndex == hoveredIndex
                    )
                    .onTapGesture {
                        onSelectChain(chain)
                    }
                    .onHover { hovering in
                        if hovering {
                            hoveredIndex = globalIndex
                            selectedIndex = globalIndex
                        } else {
                            hoveredIndex = nil
                        }
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
            selectedIndex = min(items.count - 1, selectedIndex + 1)
            return .handled
        }
        .onKeyPress(.return) {
            if selectedIndex < items.count {
                let item = items[selectedIndex]
                switch item {
                case .action(let action):
                    onSelectAction(action)
                case .chain(let chain):
                    onSelectChain(chain)
                }
            }
            return .handled
        }
        .onKeyPress(.escape) {
            onDismiss()
            return .handled
        }
    }

    private func stepNames(for chain: ActionChain) -> String {
        let names = chain.steps.compactMap { step in
            actionsManager?.action(for: step.actionId)?.name
        }
        return names.joined(separator: " → ")
    }
}

/// A single row in the action picker - macOS menu style
struct ActionPickerRow: View {

    let name: String
    let icon: String
    let subtitle: String?
    let isSelected: Bool
    let isHovered: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 16)

            VStack(alignment: .leading, spacing: 1) {
                Text(name)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, subtitle != nil ? 6 : 8)
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
        chains: [],
        actionsManager: nil,
        onSelectAction: { _ in },
        onSelectChain: { _ in },
        onDismiss: {}
    )
    .frame(width: 280)
    .padding(40)
    .background(Color.gray.opacity(0.2))
}
