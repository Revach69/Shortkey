//
//  HotKeyManager.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import AppKit
import Carbon.HIToolbox

/// Manages global keyboard shortcuts
final class HotKeyManager {
    
    // MARK: - Singleton
    
    static let shared = HotKeyManager()
    
    // MARK: - Properties
    
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var callback: (() -> Void)?
    
    private let defaults = UserDefaults.standard
    private let keyCodeKey = "shortcutKeyCode"
    private let modifiersKey = "shortcutModifiers"
    
    private var keyCode: Int {
        get { defaults.object(forKey: keyCodeKey) as? Int ?? Int(kVK_ANSI_S) }
        set { defaults.set(newValue, forKey: keyCodeKey) }
    }
    
    private var modifiers: Int {
        get { defaults.object(forKey: modifiersKey) as? Int ?? Int(cmdKey | shiftKey) }
        set { defaults.set(newValue, forKey: modifiersKey) }
    }
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Starts listening for the global hotkey
    func start(callback: @escaping () -> Void) {
        self.callback = callback
        
        // Create event tap
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { proxy, type, event, refcon -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else {
                    return Unmanaged.passRetained(event)
                }
                
                let manager = Unmanaged<HotKeyManager>.fromOpaque(refcon).takeUnretainedValue()
                
                if manager.handleEvent(event) {
                    return nil // Consume the event
                }
                
                return Unmanaged.passRetained(event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            print("Failed to create event tap. Check accessibility permissions.")
            return
        }
        
        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        
        if let source = runLoopSource {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        }
        
        CGEvent.tapEnable(tap: tap, enable: true)
    }
    
    /// Stops listening for the global hotkey
    func stop() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
        }
        
        eventTap = nil
        runLoopSource = nil
        callback = nil
    }
    
    /// Updates the keyboard shortcut
    func updateShortcut(keyCode: Int, modifiers: Int) {
        self.keyCode = keyCode
        self.modifiers = modifiers
    }
    
    // MARK: - Private Methods
    
    private func handleEvent(_ event: CGEvent) -> Bool {
        let eventKeyCode = event.getIntegerValueField(.keyboardEventKeycode)
        let eventFlags = event.flags
        
        // Check if the pressed key matches our shortcut
        guard Int(eventKeyCode) == keyCode else {
            return false
        }
        
        // Check modifiers
        let hasCommand = eventFlags.contains(.maskCommand)
        let hasShift = eventFlags.contains(.maskShift)
        let hasOption = eventFlags.contains(.maskAlternate)
        let hasControl = eventFlags.contains(.maskControl)
        
        let expectedCommand = (modifiers & cmdKey) != 0
        let expectedShift = (modifiers & shiftKey) != 0
        let expectedOption = (modifiers & optionKey) != 0
        let expectedControl = (modifiers & controlKey) != 0
        
        if hasCommand == expectedCommand &&
           hasShift == expectedShift &&
           hasOption == expectedOption &&
           hasControl == expectedControl {
            
            DispatchQueue.main.async { [weak self] in
                self?.callback?()
            }
            
            return true
        }
        
        return false
    }
}

