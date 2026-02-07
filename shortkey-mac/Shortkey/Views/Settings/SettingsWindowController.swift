//
//  SettingsWindowController.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
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
    
    func showWindow(
        actionsManager: ActionsManager,
        aiProviderManager: AIProviderManager,
        subscriptionManager: SubscriptionManager
    ) {
        if let window = window {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        let settingsView = SettingsView()
            .environmentObject(actionsManager)
            .environmentObject(aiProviderManager)
            .environmentObject(subscriptionManager)
        
        let hostingController = NSHostingController(rootView: settingsView)
        
        let window = NSWindow(contentViewController: hostingController)
        window.title = Strings.Settings.title
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.setContentSize(NSSize(width: LayoutConstants.settingsWidth, height: LayoutConstants.settingsHeight))
        window.center()
        window.isReleasedWhenClosed = false
        
        self.window = window
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func closeWindow() {
        window?.close()
    }
}
