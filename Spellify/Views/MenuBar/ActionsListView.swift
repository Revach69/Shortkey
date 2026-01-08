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
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @Binding var actionEditorMode: MenuBarPopoverView.ActionEditorMode?
    
    @State private var showPaywall = false
    
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
                // Check if user can add more actions
                if actionsManager.canAddAction {
                    actionEditorMode = .add
                } else {
                    // Show paywall
                    showPaywall = true
                }
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
        .sheet(isPresented: $showPaywall) {
            PaywallSheet()
                .environmentObject(subscriptionManager)
        }
    }
}

#Preview {
    ActionsListView(
        actionEditorMode: .constant(nil)
    )
    .environmentObject(ActionsManager(subscriptionManager: .shared))
    .environmentObject(SubscriptionManager.shared)
    .frame(width: 300)
}


