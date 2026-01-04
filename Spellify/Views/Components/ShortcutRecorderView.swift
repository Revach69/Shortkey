//
//  ShortcutRecorderView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI
import AppKit
import OSLog

/// Native NSView-based shortcut recorder that actually works
struct ShortcutRecorderView: NSViewRepresentable {
    
    @Binding var shortcutDisplay: String
    @Binding var isRecording: Bool
    
    func makeNSView(context: Context) -> ShortcutRecorderNSView {
        let view = ShortcutRecorderNSView()
        view.delegate = context.coordinator
        view.shortcutDisplay = shortcutDisplay
        view.isRecording = isRecording
        return view
    }
    
    func updateNSView(_ nsView: ShortcutRecorderNSView, context: Context) {
        nsView.shortcutDisplay = shortcutDisplay
        nsView.isRecording = isRecording
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ShortcutRecorderNSViewDelegate {
        let parent: ShortcutRecorderView
        
        init(_ parent: ShortcutRecorderView) {
            self.parent = parent
        }
        
        func shortcutRecorderDidUpdateShortcut(_ shortcut: String) {
            Logger.settings.debug("🎹 [ShortcutRecorder] Coordinator received shortcut: \(shortcut)")
            parent.shortcutDisplay = shortcut
            parent.isRecording = false
            
            // Update HotKeyManager with the new shortcut
            HotKeyManager.shared.updateShortcut(shortcut)
        }
        
        func shortcutRecorderDidChangeRecordingState(_ isRecording: Bool) {
            Logger.settings.debug("🎹 [ShortcutRecorder] Recording state changed: \(isRecording)")
            parent.isRecording = isRecording
        }
    }
}

protocol ShortcutRecorderNSViewDelegate: AnyObject {
    func shortcutRecorderDidUpdateShortcut(_ shortcut: String)
    func shortcutRecorderDidChangeRecordingState(_ isRecording: Bool)
}

/// Native NSView that captures keyboard events for shortcut recording
class ShortcutRecorderNSView: NSView {
    
    weak var delegate: ShortcutRecorderNSViewDelegate?
    
    var shortcutDisplay: String = "⌘⇧S" {
        didSet {
            needsDisplay = true
        }
    }
    
    var isRecording: Bool = false {
        didSet {
            needsDisplay = true
            if isRecording {
                window?.makeFirstResponder(self)
                Logger.settings.debug("🎹 [ShortcutRecorder] Started recording")
            } else {
                Logger.settings.debug("🎹 [ShortcutRecorder] Stopped recording")
            }
        }
    }
    
    private var eventMonitor: Any?
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        Logger.settings.debug("🎹 [ShortcutRecorder] View moved to window")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Draw background
        let backgroundColor: NSColor = isRecording ? 
            NSColor.controlAccentColor.withAlphaComponent(0.1) : 
            NSColor.controlBackgroundColor
        backgroundColor.setFill()
        let bgPath = NSBezierPath(roundedRect: bounds, xRadius: 6, yRadius: 6)
        bgPath.fill()
        
        // Draw border if recording
        if isRecording {
            NSColor.controlAccentColor.setStroke()
            let borderPath = NSBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), xRadius: 6, yRadius: 6)
            borderPath.lineWidth = 2
            borderPath.stroke()
        }
        
        // Draw text
        let text = isRecording ? "Press shortcut..." : shortcutDisplay
        let textColor: NSColor = isRecording ? .secondaryLabelColor : .labelColor
        let font: NSFont = isRecording ? .systemFont(ofSize: 13) : .monospacedSystemFont(ofSize: 13, weight: .regular)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let textRect = bounds.insetBy(dx: 12, dy: 6)
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        // Center text vertically
        let textSize = attributedString.size()
        let centeredRect = NSRect(
            x: textRect.origin.x,
            y: textRect.origin.y + (textRect.height - textSize.height) / 2,
            width: textRect.width,
            height: textSize.height
        )
        
        attributedString.draw(in: centeredRect)
    }
    
    override func mouseDown(with event: NSEvent) {
        Logger.settings.debug("🎹 [ShortcutRecorder] Mouse down")
        isRecording = !isRecording
        delegate?.shortcutRecorderDidChangeRecordingState(isRecording)
        needsDisplay = true
    }
    
    override func keyDown(with event: NSEvent) {
        guard isRecording else {
            super.keyDown(with: event)
            return
        }
        
        Logger.settings.debug("🎹 [ShortcutRecorder] Key down - keyCode: \(event.keyCode), modifiers: \(event.modifierFlags.rawValue)")
        
        // Get modifier flags
        let modifiers = event.modifierFlags
        
        // Build shortcut string
        var parts: [String] = []
        
        if modifiers.contains(.control) {
            parts.append("⌃")
        }
        if modifiers.contains(.option) {
            parts.append("⌥")
        }
        if modifiers.contains(.shift) {
            parts.append("⇧")
        }
        if modifiers.contains(.command) {
            parts.append("⌘")
        }
        
        // Get the key character
        if let characters = event.charactersIgnoringModifiers?.uppercased(), !characters.isEmpty {
            parts.append(characters)
        }
        
        Logger.settings.debug("🎹 [ShortcutRecorder] Parsed shortcut parts: \(parts)")
        
        // Require at least one modifier + one key
        if parts.count >= 2 {
            let shortcut = parts.joined()
            Logger.settings.debug("🎹 [ShortcutRecorder] Valid shortcut recorded: \(shortcut)")
            
            shortcutDisplay = shortcut
            isRecording = false
            
            delegate?.shortcutRecorderDidUpdateShortcut(shortcut)
            delegate?.shortcutRecorderDidChangeRecordingState(false)
            
            needsDisplay = true
        } else {
            Logger.settings.debug("🎹 [ShortcutRecorder] Invalid shortcut (need at least 1 modifier + 1 key)")
        }
    }
    
    override func flagsChanged(with event: NSEvent) {
        // Handle modifier keys being pressed/released during recording
        if isRecording {
            Logger.settings.debug("🎹 [ShortcutRecorder] Flags changed: \(event.modifierFlags.rawValue)")
        }
    }
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 120, height: 28)
    }
}
