//
//  PopoverFooterView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Footer with Configure and Quit options
struct PopoverFooterView: View {
    
    @EnvironmentObject var actionsManager: ActionsManager
    @EnvironmentObject var aiProviderManager: AIProviderManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Configure button
            Button(action: openSettings) {
                HStack {
                    Text(Strings.Popover.configure)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(HoverButtonStyle())
            
            // Quit button
            Button(action: quitApp) {
                HStack {
                    Text(Strings.Popover.quit)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(HoverButtonStyle())
        }
        .padding(.vertical, 4)
    }
    
    private func openSettings() {
        DispatchQueue.main.async {
            // Close popover
            if let appDelegate = NSApp.delegate as? AppDelegate {
                appDelegate.closePopover()
            }
            
            // Small delay to let popover close
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Pass managers directly to settings
                SettingsWindowController.shared.showWindow(
                    actionsManager: actionsManager,
                    aiProviderManager: aiProviderManager
                )
            }
        }
    }
    
    private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

#Preview {
    PopoverFooterView()
        .environmentObject(ActionsManager())
        .environmentObject(AIProviderManager())
        .frame(width: 300)
}
