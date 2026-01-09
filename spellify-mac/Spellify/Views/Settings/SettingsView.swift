//
//  SettingsView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Main settings view container using native macOS "Inset Grouped" style
/// 
/// **What is "Inset Grouped"?**
/// - Native Form + Section layout with system-provided grouped appearance
/// - Rounded section backgrounds with subtle insets
/// - System-managed spacing, colors, and separators
/// - No custom borders, shadows, or card containers
/// - Matches macOS System Settings visual style
struct SettingsView: View {
    
    @EnvironmentObject var aiProviderManager: AIProviderManager
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @EnvironmentObject var actionsManager: ActionsManager
    
    var body: some View {
        Form {
            AIProviderSection()
            
            SubscriptionSection()
            
            ShortcutSection()
            
            PreferencesSection()
        }
        .formStyle(.grouped)
        .frame(minWidth: LayoutConstants.settingsWidth, minHeight: LayoutConstants.settingsHeight)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AIProviderManager())
        .environmentObject(SubscriptionManager.shared)
        .environmentObject(ActionsManager(subscriptionManager: .shared))
}
