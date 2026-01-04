//
//  SpellifyController.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import AppKit

/// Main controller that orchestrates the text transformation flow
final class SpellifyController {
    
    // MARK: - Singleton
    
    static let shared = SpellifyController()
    
    // MARK: - Properties
    
    private let accessibilityService = AccessibilityService.shared
    private let notificationManager = NotificationManager.shared
    
    private var actionsManager: ActionsManager?
    private var aiProviderManager: AIProviderManager?
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Configuration
    
    /// Configures the controller with managers
    func configure(
        actionsManager: ActionsManager,
        aiProviderManager: AIProviderManager
    ) {
        self.actionsManager = actionsManager
        self.aiProviderManager = aiProviderManager
    }
    
    // MARK: - Public Methods
    
    /// Called when the global hotkey is pressed
    func handleHotKeyPressed() {
        guard let aiProviderManager = aiProviderManager,
              let actionsManager = actionsManager else {
            return
        }
        
        // Check accessibility permissions
        guard accessibilityService.hasAccessibilityPermissions else {
            accessibilityService.requestAccessibilityPermissions()
            return
        }
        
        // Check if AI provider is configured
        guard aiProviderManager.status.isReady else {
            showConfigurationAlert()
            return
        }
        
        // Get selected text
        Task {
            await processSelectedText(
                actions: actionsManager.actions,
                aiProviderManager: aiProviderManager
            )
        }
    }
    
    // MARK: - Private Methods
    
    private func processSelectedText(
        actions: [SpellAction],
        aiProviderManager: AIProviderManager
    ) async {
        // Get selected text
        guard let selectedText = await accessibilityService.getSelectedText() else {
            notificationManager.showNoSelection()
            return
        }
        
        // Check text length
        guard selectedText.count <= Constants.maxTextLength else {
            notificationManager.showTextTooLong()
            return
        }
        
        // Show action picker
        await MainActor.run {
            ActionPickerPanelController.shared.show(
                actions: actions,
                onSelect: { [weak self] action in
                    self?.performTransformation(
                        text: selectedText,
                        action: action,
                        aiProviderManager: aiProviderManager
                    )
                },
                onDismiss: {
                    // User cancelled
                }
            )
        }
    }
    
    private func performTransformation(
        text: String,
        action: SpellAction,
        aiProviderManager: AIProviderManager
    ) {
        Task {
            // Show processing notification
            notificationManager.showProcessing()
            
            do {
                // Transform text
                let result = try await aiProviderManager.transform(text: text, action: action)
                
                // Replace selected text with result
                await accessibilityService.replaceSelectedText(with: result)
                
                // Show success notification
                notificationManager.showSuccess()
                
            } catch {
                // Show error notification
                notificationManager.showError(error.localizedDescription)
            }
        }
    }
    
    private func showConfigurationAlert() {
        guard let actionsManager = actionsManager,
              let aiProviderManager = aiProviderManager else {
            return
        }
        
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Spellify"
            alert.informativeText = Strings.Errors.configureAPIKey
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Open Settings")
            alert.addButton(withTitle: "Cancel")
            
            if alert.runModal() == .alertFirstButtonReturn {
                SettingsWindowController.shared.showWindow(
                    actionsManager: actionsManager,
                    aiProviderManager: aiProviderManager
                )
            }
        }
    }
}


