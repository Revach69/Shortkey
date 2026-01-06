//
//  ActionPickerPanel.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import AppKit
import SwiftUI

/// Custom NSPanel that can become key window for keyboard input
class KeyablePanel: NSPanel {
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return false
    }
}

/// Controller for the floating action picker panel
final class ActionPickerPanelController {
    
    // MARK: - Singleton
    
    static let shared = ActionPickerPanelController()
    
    // MARK: - Properties
    
    private var panel: NSPanel?
    private var onActionSelected: ((SpellAction) -> Void)?
    private var onDismiss: (() -> Void)?
    
    // Event monitors
    private var localMouseMonitor: Any?
    private var globalMouseMonitor: Any?
    private var keyMonitor: Any?
    private var appSwitchObserver: Any?
    private var windowResignObserver: Any?
    private var screenChangeObserver: Any?
    private var spaceChangeObserver: Any?
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Shows the action picker near the mouse cursor
    func show(
        actions: [SpellAction],
        onSelect: @escaping (SpellAction) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.onActionSelected = onSelect
        self.onDismiss = onDismiss
        
        // Create panel with custom subclass that can become key
        let panel = KeyablePanel(
            contentRect: NSRect(x: 0, y: 0, width: 280, height: 0),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        panel.level = .floating
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = false // We'll use SwiftUI's shadow instead
        panel.isMovable = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.hidesOnDeactivate = false // Don't auto-hide, we control dismissal
        panel.becomesKeyOnlyIfNeeded = true // Allow panel to become key for keyboard input
        
        // Create SwiftUI content
        let pickerView = ActionPickerView(
            actions: actions,
            onSelect: { [weak self] action in
                self?.selectAction(action)
            },
            onDismiss: { [weak self] in
                self?.dismiss()
            }
        )
        
        let hostingView = NSHostingView(rootView: pickerView)
        // Calculate height: each row is ~32px + 2px spacing, plus 12px padding top/bottom
        let rowHeight: CGFloat = 32
        let spacing: CGFloat = 2
        let verticalPadding: CGFloat = 12
        let totalHeight = CGFloat(actions.count) * rowHeight + CGFloat(actions.count - 1) * spacing + verticalPadding
        hostingView.frame = NSRect(x: 0, y: 0, width: 280, height: totalHeight)
        
        panel.contentView = hostingView
        panel.setContentSize(hostingView.frame.size)
        
        // Position near mouse cursor
        let mouseLocation = NSEvent.mouseLocation
        panel.setFrameOrigin(NSPoint(
            x: mouseLocation.x - 140, // Center horizontally (280 / 2)
            y: mouseLocation.y - panel.frame.height - 12 // 12px offset below cursor
        ))
        
        self.panel = panel
        
        panel.makeKeyAndOrderFront(nil)
        
        // Set up all event monitors
        setupEventMonitors()
    }
    
    /// Hides the panel
    func dismiss() {
        removeEventMonitors()
        panel?.orderOut(nil)
        panel = nil
        onDismiss?()
    }
    
    // MARK: - Private Methods
    
    /// Set up event monitors for auto-dismissal
    private func setupEventMonitors() {
        // Monitor for local clicks (inside our app)
        localMouseMonitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            guard let self = self, let panel = self.panel else { return event }
            
            // Check if click is outside the panel
            let mouseLocation = NSEvent.mouseLocation
            if !panel.frame.contains(mouseLocation) {
                self.dismiss()
                return nil // Consume the event
            }
            return event
        }
        
        // Monitor for global clicks (outside our app)
        globalMouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            self?.dismiss()
        }
        
        // Monitor for Escape key (use global monitor to catch it before SwiftUI)
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            if event.keyCode == 53 { // Escape key
                self?.dismiss()
                return nil // Consume the event
            }
            // Let other keys pass through to SwiftUI (arrows, enter)
            return event
        }
        
        // Monitor for app switching (Cmd+Tab, clicking other apps)
        appSwitchObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didResignActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.dismiss()
        }
        
        // Monitor for window focus change (clicking another window in same app)
        windowResignObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didResignKeyNotification,
            object: panel,
            queue: .main
        ) { [weak self] _ in
            self?.dismiss()
        }
        
        // Monitor for screen changes (moving to another display/desktop)
        screenChangeObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.dismiss()
        }
        
        // Monitor for screen configuration changes
        spaceChangeObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.dismiss()
        }
    }
    
    /// Remove all event monitors
    private func removeEventMonitors() {
        if let monitor = localMouseMonitor {
            NSEvent.removeMonitor(monitor)
            localMouseMonitor = nil
        }
        
        if let monitor = globalMouseMonitor {
            NSEvent.removeMonitor(monitor)
            globalMouseMonitor = nil
        }
        
        if let monitor = keyMonitor {
            NSEvent.removeMonitor(monitor)
            keyMonitor = nil
        }
        
        if let observer = appSwitchObserver {
            NotificationCenter.default.removeObserver(observer)
            appSwitchObserver = nil
        }
        
        if let observer = windowResignObserver {
            NotificationCenter.default.removeObserver(observer)
            windowResignObserver = nil
        }
        
        if let observer = screenChangeObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(observer)
            screenChangeObserver = nil
        }
        
        if let observer = spaceChangeObserver {
            NotificationCenter.default.removeObserver(observer)
            spaceChangeObserver = nil
        }
    }
    
    private func selectAction(_ action: SpellAction) {
        removeEventMonitors()
        panel?.orderOut(nil)
        panel = nil
        onActionSelected?(action)
    }
}


