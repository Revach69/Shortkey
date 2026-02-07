//
//  Strings.swift
//  Shortkey
//
//  Created by Shortkey Team on 04/01/2026.
//

import Foundation

/// Centralized strings for localization (Apple best practice)
enum Strings {
    
    // MARK: - Popover
    
    enum Popover {
        static let title = NSLocalizedString(
            "Shortkey",
            comment: "App name in popover header"
        )
        static let actions = NSLocalizedString(
            "Actions",
            comment: "Actions section header"
        )
        static let addAction = NSLocalizedString(
            "Add Action...",
            comment: "Add action button"
        )
        static let chains = NSLocalizedString(
            "popover.chains",
            value: "Chains",
            comment: "Chains section header"
        )
        static let addChain = NSLocalizedString(
            "popover.add_chain",
            value: "Add Chain...",
            comment: "Add chain button"
        )
        static let configure = NSLocalizedString(
            "Settings...",
            comment: "Settings menu item"
        )
        static let about = NSLocalizedString(
            "About",
            comment: "About menu item"
        )
        static let quit = NSLocalizedString(
            "Quit",
            comment: "Quit menu item"
        )
    }
    
    // MARK: - Notifications
    
    enum Notifications {
        static let processing = NSLocalizedString(
            "Shortkeying your text...",
            comment: "Processing notification"
        )
        static let success = NSLocalizedString(
            "Done!",
            comment: "Success notification"
        )
        static let noSelection = NSLocalizedString(
            "Select some text first",
            comment: "No selection notification"
        )
        static let error = NSLocalizedString(
            "An error occurred",
            comment: "Generic error notification"
        )
        static let textTooLong = NSLocalizedString(
            "Text too long",
            comment: "Text too long notification"
        )
    }
    
    // MARK: - Settings
    
    enum Settings {
        static let title = NSLocalizedString(
            "Settings",
            comment: "Settings window title"
        )
        static let openAITitle = NSLocalizedString(
            "OpenAI",
            comment: "OpenAI section title"
        )
        static let openAIDescription = NSLocalizedString(
            "Connect to OpenAI to transform your text.",
            comment: "OpenAI section description"
        )
        static let getAPIKey = NSLocalizedString(
            "Get API Key...",
            comment: "Get API key link"
        )
        static let apiKey = NSLocalizedString(
            "API Key",
            comment: "API key label"
        )
        static let model = NSLocalizedString(
            "Model",
            comment: "Model picker label"
        )
        static let test = NSLocalizedString(
            "Test",
            comment: "Test connection button"
        )
        static let connected = NSLocalizedString(
            "Connected",
            comment: "Connected status"
        )
        static let notConfigured = NSLocalizedString(
            "Not configured",
            comment: "Not configured status"
        )
        static let shortcut = NSLocalizedString(
            "Keyboard Shortcut",
            comment: "Shortcut section title"
        )
        static let recordShortcut = NSLocalizedString(
            "Record Shortcut...",
            comment: "Record shortcut button"
        )
        static let preferences = NSLocalizedString(
            "Preferences",
            comment: "Preferences section title"
        )
        static let launchAtLogin = NSLocalizedString(
            "Launch at login",
            comment: "Launch at login toggle"
        )
        static let pressShortcut = NSLocalizedString(
            "Press your desired shortcut",
            comment: "Instruction text in shortcut recorder popover"
        )
        static let clearShortcut = NSLocalizedString(
            "Clear",
            comment: "Clear shortcut button"
        )
        static let editShortcut = NSLocalizedString(
            "Edit Shortcut...",
            comment: "Edit shortcut button label"
        )
        static let provider = NSLocalizedString(
            "Provider",
            comment: "AI provider label"
        )
        static let aiProvider = NSLocalizedString(
            "AI Provider",
            comment: "AI Provider section title"
        )
        static let aiProviderDescription = NSLocalizedString(
            "Connect to an AI provider to transform your text.",
            comment: "AI Provider section description"
        )
        static let addAPIKey = NSLocalizedString(
            "+ Add API Key...",
            comment: "Add API key button"
        )
        static let saveAndTest = NSLocalizedString(
            "Save & Test",
            comment: "Save and test API key button"
        )
        static let edit = NSLocalizedString(
            "Edit",
            comment: "Edit button"
        )
        
        enum Subscription {
            static let title = NSLocalizedString(
                "settings.subscription.title",
                value: "Subscription",
                comment: "Subscription section title"
            )
            
            static let plan = NSLocalizedString(
                "settings.subscription.plan",
                value: "Plan",
                comment: "Subscription plan label"
            )
            
            static let proUser = NSLocalizedString(
                "settings.subscription.pro_user",
                value: "Pro",
                comment: "Pro user status"
            )
            
            static let freeUser = NSLocalizedString(
                "settings.subscription.free_user",
                value: "Free",
                comment: "Free user status"
            )
            
            static let upgradeToPro = NSLocalizedString(
                "settings.subscription.upgrade",
                value: "Upgrade to Pro",
                comment: "Upgrade button"
            )
            
            static let manageSubscription = NSLocalizedString(
                "settings.subscription.manage",
                value: "Manage Subscription",
                comment: "Manage subscription button"
            )
            
            static let restorePurchases = NSLocalizedString(
                "settings.subscription.restore",
                value: "Restore Purchases",
                comment: "Restore purchases button"
            )
        }
    }
    
    // MARK: - Action Editor
    
    enum ActionEditor {
        static let newAction = NSLocalizedString(
            "New Action",
            comment: "New action sheet title"
        )
        static let editAction = NSLocalizedString(
            "Edit Action",
            comment: "Edit action sheet title"
        )
        static let name = NSLocalizedString(
            "Name",
            comment: "Action name label"
        )
        static let icon = NSLocalizedString(
            "Icon",
            comment: "Action icon label"
        )
        static let description = NSLocalizedString(
            "Description",
            comment: "Action description label"
        )
        static let descriptionHelper = NSLocalizedString(
            "Tell the AI what to do with the selected text",
            comment: "Description helper text"
        )
        static let namePlaceholder = NSLocalizedString(
            "e.g., Fix Grammar",
            comment: "Action name placeholder"
        )
        static let descriptionPlaceholder = NSLocalizedString(
            "e.g., Fix any grammar and spelling errors...",
            comment: "Action description placeholder"
        )
        static let save = NSLocalizedString(
            "Save",
            comment: "Save button"
        )
        static let cancel = NSLocalizedString(
            "Cancel",
            comment: "Cancel button"
        )
        static let delete = NSLocalizedString(
            "Delete",
            comment: "Delete button"
        )
        static let browseSymbols = NSLocalizedString(
            "Browse All Symbols...",
            comment: "Browse SF Symbols link"
        )
    }
    
    // MARK: - Chain Editor

    enum ChainEditor {
        static let newChain = NSLocalizedString(
            "chain_editor.new_chain",
            value: "New Chain",
            comment: "New chain sheet title"
        )
        static let editChain = NSLocalizedString(
            "chain_editor.edit_chain",
            value: "Edit Chain",
            comment: "Edit chain sheet title"
        )
        static let chainName = NSLocalizedString(
            "chain_editor.name",
            value: "Name",
            comment: "Chain name label"
        )
        static let chainNamePlaceholder = NSLocalizedString(
            "chain_editor.name_placeholder",
            value: "e.g., Translate & Polish",
            comment: "Chain name placeholder"
        )
        static let steps = NSLocalizedString(
            "chain_editor.steps",
            value: "Steps",
            comment: "Steps section label"
        )
        static let addStep = NSLocalizedString(
            "chain_editor.add_step",
            value: "Add Step",
            comment: "Add step button"
        )
        static let stepsLimit = NSLocalizedString(
            "chain_editor.steps_limit",
            value: "Maximum %d steps reached",
            comment: "Steps limit message"
        )
        static let minimumSteps = NSLocalizedString(
            "chain_editor.minimum_steps",
            value: "A chain needs at least 2 steps",
            comment: "Minimum steps validation message"
        )
    }

    // MARK: - Common
    
    enum Common {
        static let change = NSLocalizedString(
            "Change",
            comment: "Change button"
        )
        static let delete = NSLocalizedString(
            "Delete",
            comment: "Delete button"
        )
        static let cancel = NSLocalizedString(
            "Cancel",
            comment: "Cancel button"
        )
        static let save = NSLocalizedString(
            "Save",
            comment: "Save button"
        )
        static let status = NSLocalizedString(
            "Status",
            comment: "Status label"
        )
        static let testConnection = NSLocalizedString(
            "Test Connection",
            comment: "Test connection button"
        )
        static let testing = NSLocalizedString(
            "Testing...",
            comment: "Testing status"
        )
        
        // MARK: - Error Messages
        
        static let noInternet = NSLocalizedString(
            "No internet connection",
            comment: "No internet error"
        )
        static let connectionTimeout = NSLocalizedString(
            "Connection timeout",
            comment: "Timeout error"
        )
        static let cannotReachServer = NSLocalizedString(
            "Cannot reach server",
            comment: "Server unreachable error"
        )
        static let invalidAPIKey = NSLocalizedString(
            "Invalid API key",
            comment: "Invalid API key error"
        )
        static let connectionFailed = NSLocalizedString(
            "Connection failed",
            comment: "Generic connection error"
        )
        static let shortcut = NSLocalizedString(
            "Shortcut",
            comment: "Shortcut label"
        )
        static let launch = NSLocalizedString(
            "Launch",
            comment: "Launch label"
        )
        static let clear = NSLocalizedString(
            "Clear",
            comment: "Clear button"
        )
        static let edit = NSLocalizedString(
            "Edit",
            comment: "Edit button"
        )
        static let done = NSLocalizedString(
            "Done",
            comment: "Done button"
        )
        static let remove = NSLocalizedString(
            "Remove",
            comment: "Remove button"
        )
        static let disconnect = NSLocalizedString(
            "Disconnect",
            comment: "Disconnect button"
        )
    }
    
    // MARK: - Pro Features
    
    enum ProFeatures {
        static let unlimitedActions = NSLocalizedString(
            "pro_feature.unlimited_actions",
            value: "Unlimited Actions",
            comment: "Pro feature name"
        )
        
        static let unlimitedActionsDescription = NSLocalizedString(
            "pro_feature.unlimited_actions.description",
            value: "Create as many custom actions as you need",
            comment: "Pro feature description"
        )

        static let promptChaining = NSLocalizedString(
            "pro_feature.prompt_chaining",
            value: "Prompt Chains",
            comment: "Pro feature name"
        )

        static let promptChainingDescription = NSLocalizedString(
            "pro_feature.prompt_chaining.description",
            value: "Chain multiple actions together in sequence",
            comment: "Pro feature description"
        )
    }
    
    // MARK: - Subscription
    
    enum Subscription {
        static let unlockPro = NSLocalizedString(
            "subscription.unlock_pro",
            value: "Unlock Shortkey Pro",
            comment: "Paywall title"
        )
        
        static let unlockProDescription = NSLocalizedString(
            "subscription.unlock_pro.description",
            value: "Create unlimited actions and get access to all Pro features",
            comment: "Paywall description"
        )
        
        static let limitReached = NSLocalizedString(
            "subscription.limit_reached",
            value: "You've reached the free limit of %d actions",
            comment: "Free limit message (uses Constants.freeActionsLimit)"
        )
        
        static let upgradeToPro = NSLocalizedString(
            "subscription.upgrade",
            value: "Upgrade to Pro",
            comment: "Upgrade button"
        )
        
        static let subscribeButton = NSLocalizedString(
            "subscription.subscribe_button",
            value: "Subscribe for %@/month",
            comment: "Subscribe button with price"
        )
        
        static let processing = NSLocalizedString(
            "subscription.processing",
            value: "Processing...",
            comment: "Processing state"
        )
        
        static let restorePurchases = NSLocalizedString(
            "subscription.restore",
            value: "Restore Purchases",
            comment: "Restore button"
        )
        
        static let terms = NSLocalizedString(
            "subscription.terms",
            value: "Subscription renews automatically. Cancel anytime in System Settings.",
            comment: "Terms text"
        )
        
        static let loading = NSLocalizedString(
            "subscription.loading",
            value: "Loading...",
            comment: "Loading state"
        )
        
        static let noPurchasesFound = NSLocalizedString(
            "subscription.no_purchases",
            value: "No purchases found to restore",
            comment: "No purchases to restore message"
        )
    }
    
    // MARK: - Errors
    
    enum Errors {
        static let configureAPIKey = NSLocalizedString(
            "Please configure your API key in Settings",
            comment: "API key not configured error"
        )
        
        static let failedVerification = NSLocalizedString(
            "error.failed_verification",
            value: "Transaction verification failed",
            comment: "Verification error"
        )
        
        static let purchaseFailed = NSLocalizedString(
            "error.purchase_failed",
            value: "Purchase failed",
            comment: "Purchase error"
        )
        
        static let productNotFound = NSLocalizedString(
            "error.product_not_found",
            value: "Product not found",
            comment: "Product not found error"
        )
        
        static let networkError = NSLocalizedString(
            "error.network",
            value: "Network error occurred",
            comment: "Network error"
        )
        
        static let errorTitle = NSLocalizedString(
            "error.title",
            value: "Error",
            comment: "Error alert title"
        )
        
        static let ok = NSLocalizedString(
            "error.ok",
            value: "OK",
            comment: "OK button"
        )
        
        static let registrationFailed = NSLocalizedString(
            "error.registration_failed",
            value: "Device registration failed",
            comment: "Device registration error"
        )
        
        static let transformFailed = NSLocalizedString(
            "error.transform_failed",
            value: "Text transformation failed",
            comment: "Transform error"
        )
        
        static let rateLimitExceeded = NSLocalizedString(
            "error.rate_limit_exceeded",
            value: "Rate limit exceeded. Please wait a moment.",
            comment: "Rate limit error"
        )
        
        static let invalidSignature = NSLocalizedString(
            "error.invalid_signature",
            value: "Invalid signature. Please try again.",
            comment: "Invalid signature error"
        )
        
        static let invalidResponse = NSLocalizedString(
            "error.invalid_response",
            value: "Invalid response from server",
            comment: "Invalid response error"
        )
    }
}
