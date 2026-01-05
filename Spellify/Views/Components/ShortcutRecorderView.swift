//
//  ShortcutRecorderView.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import SwiftUI
import AppKit

/// Button-style shortcut recorder that matches macOS System Settings design
/// Displays current shortcut as a button; clicking opens a popover for recording
struct ShortcutRecorderView: View {
    
    @Binding var shortcutDisplay: String
    @Binding var isRecording: Bool
    
    @State private var showingPopover = false
    @State private var tempShortcut = ""
    
    var body: some View {
        Button(action: {
            tempShortcut = ""
            showingPopover = true
        }) {
            Text(shortcutDisplay)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.primary)
                .frame(minWidth: 100)
                .frame(height: 28)
                .padding(.horizontal, 12)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(NSColor.separatorColor), lineWidth: 0.5)
                )
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showingPopover, arrowEdge: .bottom) {
            ShortcutRecorderPopoverView(
                currentShortcut: shortcutDisplay,
                tempShortcut: $tempShortcut,
                isRecording: $isRecording,
                onSave: { newShortcut in
                    shortcutDisplay = newShortcut
                    HotKeyManager.shared.updateShortcut(newShortcut)
                    showingPopover = false
                    isRecording = false
                },
                onCancel: {
                    showingPopover = false
                    isRecording = false
                    tempShortcut = ""
                },
                onClear: {
                    tempShortcut = ""
                }
            )
        }
    }
}

/// Popover content for recording keyboard shortcuts
private struct ShortcutRecorderPopoverView: View {
    
    let currentShortcut: String
    @Binding var tempShortcut: String
    @Binding var isRecording: Bool
    
    let onSave: (String) -> Void
    let onCancel: () -> Void
    let onClear: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(Strings.Settings.pressShortcut)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
            
            ShortcutRecorderInputView(
                shortcutDisplay: $tempShortcut,
                isRecording: $isRecording
            )
            .frame(height: 40)
            
            HStack(spacing: 12) {
                Button(Strings.Common.clear) {
                    onClear()
                }
                .disabled(tempShortcut.isEmpty)
                
                Spacer()
                
                Button(Strings.Common.cancel) {
                    onCancel()
                }
                .keyboardShortcut(.escape, modifiers: [])
                
                Button(Strings.Common.done) {
                    if !tempShortcut.isEmpty {
                        onSave(tempShortcut)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(tempShortcut.isEmpty)
                .keyboardShortcut(.return, modifiers: [])
            }
        }
        .padding(20)
        .frame(width: 340)
        .onAppear {
            isRecording = true
        }
    }
}

/// NSViewRepresentable wrapper for the native shortcut recorder input
private struct ShortcutRecorderInputView: NSViewRepresentable {
    
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
        let parent: ShortcutRecorderInputView
        
        init(_ parent: ShortcutRecorderInputView) {
            self.parent = parent
        }
        
        func shortcutRecorderDidUpdateShortcut(_ shortcut: String) {
            parent.shortcutDisplay = shortcut
        }
        
        func shortcutRecorderDidChangeRecordingState(_ isRecording: Bool) {
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
    
    var shortcutDisplay: String = "" {
        didSet {
            needsDisplay = true
        }
    }
    
    var isRecording: Bool = false {
        didSet {
            needsDisplay = true
            if isRecording {
                window?.makeFirstResponder(self)
            }
        }
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        // Auto-focus when appearing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.window?.makeFirstResponder(self)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Draw background
        NSColor.textBackgroundColor.setFill()
        let bgPath = NSBezierPath(roundedRect: bounds, xRadius: 5, yRadius: 5)
        bgPath.fill()
        
        // Draw border (focus ring when recording)
        let borderColor: NSColor = isRecording ? .controlAccentColor : .separatorColor
        let borderWidth: CGFloat = isRecording ? 3 : 1
        
        borderColor.setStroke()
        let borderPath = NSBezierPath(roundedRect: bounds.insetBy(dx: borderWidth/2, dy: borderWidth/2), xRadius: 5, yRadius: 5)
        borderPath.lineWidth = borderWidth
        borderPath.stroke()
        
        // Draw text
        let text = shortcutDisplay.isEmpty ? "⌘⇧?" : shortcutDisplay
        let textColor: NSColor = shortcutDisplay.isEmpty ? .secondaryLabelColor : .labelColor
        let font: NSFont = .monospacedSystemFont(ofSize: 16, weight: .regular)
        
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
    
    override func keyDown(with event: NSEvent) {
        guard isRecording else {
            super.keyDown(with: event)
            return
        }
        
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
        
        // Require at least one modifier + one key
        if parts.count >= 2 {
            let shortcut = parts.joined()
            
            shortcutDisplay = shortcut
            delegate?.shortcutRecorderDidUpdateShortcut(shortcut)
            
            needsDisplay = true
        }
    }
    
    override func flagsChanged(with event: NSEvent) {
        // Handle modifier keys being pressed/released during recording
    }
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 200, height: 40)
    }
}

#Preview {
    VStack(spacing: 20) {
        ShortcutRecorderView(
            shortcutDisplay: .constant("⌘⇧S"),
            isRecording: .constant(false)
        )
        
        ShortcutRecorderView(
            shortcutDisplay: .constant("⌃⌥⌘T"),
            isRecording: .constant(false)
        )
    }
    .padding()
    .frame(width: 400)
}
