//
//  PreferencesSection.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import SwiftUI
import ServiceManagement

/// General preferences section using native "Inset Grouped" Form/Section pattern
struct PreferencesSection: View {
    
    @State private var launchAtLogin: Bool = false
    
    var body: some View {
        Section {
            SettingsRow(label: Strings.Settings.launchAtLogin) {
                Toggle("", isOn: $launchAtLogin)
                    .toggleStyle(.switch)
                    .labelsHidden()
                    .onChange(of: launchAtLogin) { _, newValue in
                        updateLaunchAtLogin(newValue)
                    }
            }
        } header: {
            Text(Strings.Settings.preferences)
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
                withAnimation {
                    launchAtLogin = !enabled
                }
            }
        }
    }
}

#Preview {
    Form {
        PreferencesSection()
    }
    .formStyle(.grouped)
    .frame(width: 500)
}
