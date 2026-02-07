//
//  ShortkeyController.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import AppKit

/// Main controller that orchestrates the text transformation flow
@MainActor
final class ShortkeyController {
    
    // MARK: - Singleton
    
    static let shared = ShortkeyController()
    
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
                chains: actionsManager.chains,
                actionsManager: actionsManager,
                aiProviderManager: aiProviderManager
            )
        }
    }

    // MARK: - Private Methods

    private func processSelectedText(
        actions: [SpellAction],
        chains: [ActionChain],
        actionsManager: ActionsManager,
        aiProviderManager: AIProviderManager
    ) async {
        guard let selectedText = await accessibilityService.getSelectedText() else {
            notificationManager.showNoSelection()
            return
        }

        guard selectedText.count <= BusinessRulesConstants.maxTextLength else {
            notificationManager.showTextTooLong()
            return
        }

        await MainActor.run {
            ActionPickerPanelController.shared.show(
                actions: actions,
                chains: chains,
                actionsManager: actionsManager,
                onSelectAction: { [weak self] action in
                    self?.performTransformation(
                        text: selectedText,
                        action: action,
                        aiProviderManager: aiProviderManager
                    )
                },
                onSelectChain: { [weak self] chain in
                    self?.performChainExecution(
                        text: selectedText,
                        chain: chain,
                        actionsManager: actionsManager,
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

    private func performChainExecution(
        text: String,
        chain: ActionChain,
        actionsManager: ActionsManager,
        aiProviderManager: AIProviderManager
    ) {
        Task {
            notificationManager.showProcessing(actionName: chain.name)

            do {
                let result = try await executeChain(
                    chain,
                    initialText: text,
                    actionsManager: actionsManager,
                    aiProviderManager: aiProviderManager
                )
                await accessibilityService.replaceSelectedText(with: result)
                notificationManager.showSuccess()
            } catch {
                notificationManager.showError(error.localizedDescription)
            }
        }
    }

    private func executeChain(
        _ chain: ActionChain,
        initialText: String,
        actionsManager: ActionsManager,
        aiProviderManager: AIProviderManager
    ) async throws -> String {
        var currentText = initialText

        for step in chain.steps {
            guard let action = actionsManager.action(for: step.actionId) else {
                throw ChainExecutionError.actionNotFound
            }

            currentText = try await aiProviderManager.transform(text: currentText, action: action)
        }

        return currentText
    }
}

// MARK: - Chain Execution Error

enum ChainExecutionError: LocalizedError {
    case actionNotFound

    var errorDescription: String? {
        switch self {
        case .actionNotFound:
            return "A step in this chain references an action that no longer exists."
        }
    }
}


