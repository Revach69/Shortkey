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
    
    @Binding var actionEditorMode: MenuBarPopoverView.ActionEditorMode?
    
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
                    actionEditorMode = .edit(action)
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
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                }
                .buttonStyle(HoverButtonStyle())
            }
            
            // Add action button
            Button(action: {
                actionEditorMode = .add
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundStyle(.secondary)
                    Text(Strings.Popover.addAction)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(HoverButtonStyle())
            .padding(.bottom, 4)
        }
    }
}

#Preview {
    ActionsListView(
        actionEditorMode: .constant(nil)
    )
    .environmentObject(ActionsManager())
    .frame(width: 300)
}


