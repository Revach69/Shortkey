//
//  SettingsView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Main settings view container
struct SettingsView: View {
    
    @EnvironmentObject var aiProviderManager: AIProviderManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AIProviderSection()
                
                Divider()
                
                ShortcutSection()
                
                Divider()
                
                PreferencesSection()
            }
            .padding(20)
        }
        .frame(minWidth: Constants.settingsWidth, minHeight: Constants.settingsHeight)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AIProviderManager())
}


