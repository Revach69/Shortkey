//
//  PopoverFooterView.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI

/// Footer with Settings, About, and Quit options
struct PopoverFooterView: View {
    
    @EnvironmentObject var actionsManager: ActionsManager
    @EnvironmentObject var aiProviderManager: AIProviderManager
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Binding var showingAbout: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: openSettings) {
                HStack {
                    Text(Strings.Popover.configure)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(HoverButtonStyle())
            
            Button(action: {
                showingAbout = true
            }) {
                HStack {
                    Text(Strings.Popover.about)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(HoverButtonStyle())
            
            Button(action: quitApp) {
                HStack {
                    Text(Strings.Popover.quit)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(HoverButtonStyle())
        }
        .padding(.vertical, 4)
    }
    
    private func openSettings() {
        DispatchQueue.main.async {
            if let appDelegate = NSApp.delegate as? AppDelegate {
                appDelegate.closePopover()
            }
            
            // Small delay to let popover close
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                SettingsWindowController.shared.showWindow(
                    actionsManager: actionsManager,
                    aiProviderManager: aiProviderManager,
                    subscriptionManager: subscriptionManager
                )
            }
        }
    }
    
    private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

#Preview {
    PopoverFooterView(showingAbout: .constant(false))
        .environmentObject(ActionsManager(subscriptionManager: .shared))
        .environmentObject(SubscriptionManager.shared)
        .environmentObject(AIProviderManager())
        .frame(width: 300)
}
