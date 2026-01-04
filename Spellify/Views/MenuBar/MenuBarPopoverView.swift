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
    
    @State private var showingActionEditor = false
    @State private var editingAction: SpellAction?
    
    var body: some View {
        VStack(spacing: 0) {
            PopoverHeaderView()
            
            Divider()
            
            ActionsListView(
                showingActionEditor: $showingActionEditor,
                editingAction: $editingAction
            )
            
            Divider()
            
            ProviderStatusView()
            
            Divider()
            
            PopoverFooterView()
        }
        .frame(width: Constants.popoverWidth)
        .sheet(isPresented: $showingActionEditor) {
            ActionEditorSheet(
                action: editingAction,
                onSave: { action in
                    if editingAction != nil {
                        actionsManager.update(action)
                    } else {
                        actionsManager.add(action)
                    }
                    showingActionEditor = false
                    editingAction = nil
                },
                onCancel: {
                    showingActionEditor = false
                    editingAction = nil
                }
            )
        }
    }
}

#Preview {
    MenuBarPopoverView()
        .environmentObject(ActionsManager())
        .environmentObject(AIProviderManager())
}


