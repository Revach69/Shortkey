//
//  AppDelegate.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import AppKit
import SwiftUI

/// Main application delegate that manages the menu bar status item and popover
@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Properties
    
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var eventMonitor: Any?
    
    // MARK: - Managers (will be injected into views)
    
    let subscriptionManager = SubscriptionManager.shared
    lazy var actionsManager = ActionsManager(subscriptionManager: subscriptionManager)
    let aiProviderManager = AIProviderManager()
    let notificationManager = NotificationManager()
    
    // MARK: - NSApplicationDelegate
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        setupPopover()
        setupEventMonitor()
        setupHotKey()
        setupShortkeyController()
        
        if !AccessibilityService.shared.hasAccessibilityPermissions {
            AccessibilityService.shared.requestAccessibilityPermissions()
        }
        
        // Register device with backend on first launch
        Task {
            do {
                try await ShortkeyBackendService.shared.registerDeviceIfNeeded()
            } catch {
                AppLogger.error("Failed to register device: \(error.localizedDescription)")
            }
        }
        
        Task {
            await aiProviderManager.validateOnLaunch()
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
        }
        HotKeyManager.shared.stop()
    }
    
    // MARK: - Setup
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "wand.and.stars", accessibilityDescription: "Shortkey")
            button.action = #selector(togglePopover)
            button.target = self
        }
    }
    
    private func setupPopover() {
        popover = NSPopover()
        popover?.contentSize = NSSize(width: LayoutConstants.popoverWidth, height: LayoutConstants.popoverHeight)
        popover?.behavior = .transient
        popover?.animates = true
        
        let popoverView = MenuBarPopoverView()
            .environmentObject(subscriptionManager)
            .environmentObject(actionsManager)
            .environmentObject(aiProviderManager)
        
        popover?.contentViewController = NSHostingController(rootView: popoverView)
    }
    
    private func setupEventMonitor() {
        // Close popover when clicking outside
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            if let popover = self?.popover, popover.isShown {
                popover.performClose(nil)
            }
        }
    }
    
    private func setupHotKey() {
        HotKeyManager.shared.start { [weak self] in
            self?.handleHotKeyPressed()
        }
    }
    
    private func setupShortkeyController() {
        ShortkeyController.shared.configure(
            actionsManager: actionsManager,
            aiProviderManager: aiProviderManager
        )
    }
    
    // MARK: - Actions
    
    @objc private func togglePopover() {
        guard let button = statusItem?.button, let popover = popover else { return }
        
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            
            // Make popover window key to receive keyboard events
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    private func handleHotKeyPressed() {
        ShortkeyController.shared.handleHotKeyPressed()
    }
    
    func showPopover() {
        guard let button = statusItem?.button, let popover = popover else { return }
        if !popover.isShown {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    func closePopover() {
        popover?.performClose(nil)
    }
}

