//
//  AboutSheet.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI

/// Minimal About window showing app info
struct AboutSheet: View {
    
    // MARK: - Properties
    
    let onClose: () -> Void
    
    // MARK: - Computed Properties
    
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }
    
    // MARK: - Body
    
    var body: some View {
        SettingsModalContainer(
            title: "About",
            width: 320,
            height: 280
        ) {
            VStack(spacing: 16) {
                // App Icon
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)
                
                // App Name
                Text("Spellify")
                    .font(.system(size: 24, weight: .semibold))
                
                // Version
                Text(appVersion)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                
                // Copyright
                Text("© 2026 Dror Lapidot")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }
        } footer: {
            Spacer()
            
            Button("Close") {
                onClose()
            }
            .keyboardShortcut(.defaultAction)
            .buttonStyle(.borderedProminent)
            .controlSize(.regular)
        }
    }
}

// MARK: - Preview

#Preview {
    AboutSheet(onClose: {})
}

