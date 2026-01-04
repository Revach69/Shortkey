//
//  ActionPickerPanel.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import AppKit
import SwiftUI

/// Controller for the floating action picker panel
final class ActionPickerPanelController {
    
    // MARK: - Singleton
    
    static let shared = ActionPickerPanelController()
    
    // MARK: - Properties
    
    private var panel: NSPanel?
    private var onActionSelected: ((SpellAction) -> Void)?
    private var onDismiss: (() -> Void)?
    
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
        
        // Create panel
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 250, height: 0),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        panel.level = .floating
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.isMovable = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
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
        hostingView.frame = NSRect(x: 0, y: 0, width: 250, height: CGFloat(actions.count * 36 + 16))
        
        panel.contentView = hostingView
        panel.setContentSize(hostingView.frame.size)
        
        // Position near mouse cursor
        let mouseLocation = NSEvent.mouseLocation
        panel.setFrameOrigin(NSPoint(
            x: mouseLocation.x - 125,
            y: mouseLocation.y - panel.frame.height - 10
        ))
        
        self.panel = panel
        
        panel.makeKeyAndOrderFront(nil)
        
        // Set up event monitor to close on outside click or escape
        NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            if event.keyCode == 53 { // Escape key
                self?.dismiss()
                return nil
            }
            return event
        }
    }
    
    /// Hides the panel
    func dismiss() {
        panel?.orderOut(nil)
        panel = nil
        onDismiss?()
    }
    
    // MARK: - Private Methods
    
    private func selectAction(_ action: SpellAction) {
        panel?.orderOut(nil)
        panel = nil
        onActionSelected?(action)
    }
}


