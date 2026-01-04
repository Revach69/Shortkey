//
//  PreferencesSection.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI
import ServiceManagement

/// Settings section for general preferences
struct PreferencesSection: View {
    
    @State private var launchAtLogin: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            Text(Strings.Settings.preferences)
                .font(.headline)
            
            // Launch at login toggle
            HStack {
                Text("")
                    .frame(width: 80, alignment: .trailing)
                
                Toggle(Strings.Settings.launchAtLogin, isOn: $launchAtLogin)
                    .toggleStyle(.checkbox)
                    .onChange(of: launchAtLogin) { _, newValue in
                        updateLaunchAtLogin(newValue)
                    }
                
                Spacer()
            }
        }
        .onAppear {
            loadLaunchAtLoginState()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadLaunchAtLoginState() {
        if #available(macOS 13.0, *) {
            launchAtLogin = SMAppService.mainApp.status == .enabled
        }
    }
    
    private func updateLaunchAtLogin(_ enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to update launch at login: \(error)")
                // Revert the toggle if the operation failed
                launchAtLogin = !enabled
            }
        }
    }
}

#Preview {
    PreferencesSection()
        .padding()
        .frame(width: 500)
}


