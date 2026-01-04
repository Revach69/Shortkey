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
                ActionRowView(
                    action: action,
                    onEdit: {
                        editingAction = action
                        showingActionEditor = true
                    },
                    onDelete: {
                        actionsManager.delete(action)
                    }
                )
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
            .buttonStyle(.plain)
            .padding(.bottom, 4)
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


