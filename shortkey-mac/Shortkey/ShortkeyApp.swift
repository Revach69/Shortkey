//
//  ShortkeyApp.swift
//  Shortkey
//
//  Created by Dror Lapidot on 04/01/2026.
//

import SwiftUI

@main
struct ShortkeyApp: App {
    
    // Use AppDelegate for menu bar functionality
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Empty Settings scene - we'll use a custom window for settings
        Settings {
            EmptyView()
        }
    }
}
