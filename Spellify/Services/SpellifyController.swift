//
//  SpellifyController.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import AppKit

/// Main controller that orchestrates the text transformation flow
@MainActor
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
    
    func configure(
        actionsManager: ActionsManager,
        aiProviderManager: AIProviderManager
    ) {
        self.actionsManager = actionsManager
        self.aiProviderManager = aiProviderManager
    }
    
    // MARK: - Public Methods
    
    func handleHotKeyPressed() {
        guard let aiProviderManager = aiProviderManager,
              let actionsManager = actionsManager else {
            return
        }
        
        guard accessibilityService.hasAccessibilityPermissions else {
            accessibilityService.requestAccessibilityPermissions()
            return
        }
        
        guard aiProviderManager.status.isReady else {
            notificationManager.showAPIKeyNotConfigured()
            return
        }
        
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
        guard let selectedText = await accessibilityService.getSelectedText() else {
            notificationManager.showNoSelection()
            return
        }
        
        guard selectedText.count <= Constants.maxTextLength else {
            notificationManager.showTextTooLong()
            return
        }
        
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
                onDismiss: {}
            )
        }
    }
    
    private func performTransformation(
        text: String,
        action: SpellAction,
        aiProviderManager: AIProviderManager
    ) {
        Task {
            notificationManager.showProcessing(actionName: action.name)
            
            do {
                let result = try await aiProviderManager.transform(text: text, action: action)
                await accessibilityService.replaceSelectedText(with: result)
                notificationManager.showSuccess()
            } catch {
                notificationManager.showError(error.localizedDescription)
            }
        }
    }
}


