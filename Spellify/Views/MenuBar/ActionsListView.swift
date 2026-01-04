//
//  ActionsListView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// List of actions with edit/delete capabilities
struct ActionsListView: View {
    
    @EnvironmentObject var actionsManager: ActionsManager
    
    @Binding var showingActionEditor: Bool
    @Binding var editingAction: SpellAction?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header
            Text(Strings.Popover.actions)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 8)
            
            // Actions list
            ForEach(actionsManager.actions) { action in
                Button(action: {
                    editingAction = action
                    showingActionEditor = true
                }) {
                    HStack(spacing: 12) {
                        // Icon
                        Image(systemName: action.icon)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                            .frame(width: 16)
                        
                        // Name
                        Text(action.name)
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(HoverButtonStyle())
            }
            
            // Add action button
            Button(action: {
                editingAction = nil
                showingActionEditor = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundStyle(.secondary)
                    Text(Strings.Popover.addAction)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(HoverButtonStyle())
            .padding(.bottom, 4)
        }
    }
}

/// Button style with hover effect
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

#Preview {
    ActionsListView(
        showingActionEditor: .constant(false),
        editingAction: .constant(nil)
    )
    .environmentObject(ActionsManager())
    .frame(width: 300)
}


