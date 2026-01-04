//
//  SettingsWindowController.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import AppKit
import SwiftUI

/// Controller for the settings window
final class SettingsWindowController {
    
    // MARK: - Singleton
    
    static let shared = SettingsWindowController()
    
    // MARK: - Properties
    
    private var window: NSWindow?
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    func showWindow(actionsManager: ActionsManager, aiProviderManager: AIProviderManager) {
        print("⚙️ [SettingsController] showWindow() called with managers")
        
        if let window = window {
            print("⚙️ [SettingsController] Window exists, bringing to front")
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            print("⚙️ [SettingsController] Window activated")
            return
        }
        
        print("⚙️ [SettingsController] Creating new window...")
        
        let settingsView = SettingsView()
            .environmentObject(actionsManager)
            .environmentObject(aiProviderManager)
        
        let hostingController = NSHostingController(rootView: settingsView)
        
        let window = NSWindow(contentViewController: hostingController)
        window.title = Strings.Settings.title
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.setContentSize(NSSize(width: Constants.settingsWidth, height: Constants.settingsHeight))
        window.center()
        window.isReleasedWhenClosed = false
        
        self.window = window
        
        print("⚙️ [SettingsController] Window created, showing...")
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        print("⚙️ [SettingsController] Window should be visible now!")
    }
    
    func closeWindow() {
        window?.close()
    }
}
