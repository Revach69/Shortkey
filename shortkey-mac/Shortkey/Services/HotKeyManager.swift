//
//  HotKeyManager.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
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
    
    func start(callback: @escaping () -> Void) {
        self.callback = callback
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
            // Failed to create event tap - accessibility permissions required
            return
        }
        
        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        
        if let source = runLoopSource {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        }
        
        CGEvent.tapEnable(tap: tap, enable: true)
    }
    
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
    
    func updateShortcut(keyCode: Int, modifiers: Int) {
        self.keyCode = keyCode
        self.modifiers = modifiers
    }
    
    func updateShortcut(_ shortcutString: String) {
        var parsedModifiers = 0
        var keyCharacter = ""
        
        for char in shortcutString {
            switch char {
            case "⌘":
                parsedModifiers |= cmdKey
            case "⇧":
                parsedModifiers |= shiftKey
            case "⌥":
                parsedModifiers |= optionKey
            case "⌃":
                parsedModifiers |= controlKey
            default:
                keyCharacter = String(char)
            }
        }
        
        let parsedKeyCode = keyCodeForCharacter(keyCharacter)
        self.keyCode = parsedKeyCode
        self.modifiers = parsedModifiers
        
        // Update display in UserDefaults for the UI
        defaults.set(shortcutString, forKey: "shortcutDisplay")
    }
    
    // MARK: - Private Methods
    
    private func keyCodeForCharacter(_ character: String) -> Int {
        let char = character.uppercased()
        let keyMap: [String: Int] = [
            "A": kVK_ANSI_A,
            "B": kVK_ANSI_B,
            "C": kVK_ANSI_C,
            "D": kVK_ANSI_D,
            "E": kVK_ANSI_E,
            "F": kVK_ANSI_F,
            "G": kVK_ANSI_G,
            "H": kVK_ANSI_H,
            "I": kVK_ANSI_I,
            "J": kVK_ANSI_J,
            "K": kVK_ANSI_K,
            "L": kVK_ANSI_L,
            "M": kVK_ANSI_M,
            "N": kVK_ANSI_N,
            "O": kVK_ANSI_O,
            "P": kVK_ANSI_P,
            "Q": kVK_ANSI_Q,
            "R": kVK_ANSI_R,
            "S": kVK_ANSI_S,
            "T": kVK_ANSI_T,
            "U": kVK_ANSI_U,
            "V": kVK_ANSI_V,
            "W": kVK_ANSI_W,
            "X": kVK_ANSI_X,
            "Y": kVK_ANSI_Y,
            "Z": kVK_ANSI_Z,
            "0": kVK_ANSI_0,
            "1": kVK_ANSI_1,
            "2": kVK_ANSI_2,
            "3": kVK_ANSI_3,
            "4": kVK_ANSI_4,
            "5": kVK_ANSI_5,
            "6": kVK_ANSI_6,
            "7": kVK_ANSI_7,
            "8": kVK_ANSI_8,
            "9": kVK_ANSI_9
        ]
        
        return keyMap[char] ?? kVK_ANSI_S
    }
    
    private func handleEvent(_ event: CGEvent) -> Bool {
        let eventKeyCode = event.getIntegerValueField(.keyboardEventKeycode)
        let eventFlags = event.flags
        
        guard Int(eventKeyCode) == keyCode else {
            return false
        }
        
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

