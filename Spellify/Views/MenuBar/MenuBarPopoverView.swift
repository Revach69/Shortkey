//
//  MenuBarPopoverView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Main popover view displayed when clicking the menu bar icon
struct MenuBarPopoverView: View {
    
    @EnvironmentObject var actionsManager: ActionsManager
    @EnvironmentObject var aiProviderManager: AIProviderManager
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @State private var showingActionEditor = false
    @State private var editingAction: SpellAction?
    @State private var actionEditorMode: ActionEditorMode?
    @State private var showingAbout = false
    
    enum ActionEditorMode: Identifiable {
        case add
        case edit(SpellAction)
        
        var id: String {
            switch self {
            case .add: return "add"
            case .edit(let action): return action.id.uuidString
            }
        }
        
        var action: SpellAction? {
            switch self {
            case .add: return nil
            case .edit(let action): return action
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            PopoverHeaderView()
            
            ProviderStatusView()
            
            Divider()
            
            ActionsListView(
                actionEditorMode: $actionEditorMode
            )
            
            Divider()
            
            PopoverFooterView(showingAbout: $showingAbout)
        }
        .frame(width: Layout.popoverWidth)
        .sheet(item: $actionEditorMode) { mode in
            ActionEditorSheet(
                action: mode.action,
                onSave: { action in
                    if case .edit = mode {
                        actionsManager.update(action)
                    } else {
                        actionsManager.add(action)
                    }
                    actionEditorMode = nil
                },
                onCancel: {
                    actionEditorMode = nil
                },
                onDelete: mode.action != nil ? {
                    if let action = mode.action {
                        actionsManager.delete(action)
                    }
                    actionEditorMode = nil
                } : nil
            )
        }
        .sheet(isPresented: $showingAbout) {
            AboutSheet(onClose: {
                showingAbout = false
            })
        }
    }
}

#Preview {
    MenuBarPopoverView()
        .environmentObject(ActionsManager(subscriptionManager: .shared))
        .environmentObject(AIProviderManager())
        .environmentObject(SubscriptionManager.shared)
}


