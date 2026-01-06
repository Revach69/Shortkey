//
//  Strings.swift
//  Spellify
//
//  Created by Spellify Team on 04/01/2026.
//

import Foundation

/// Centralized strings for localization (Apple best practice)
enum Strings {
    
    // MARK: - Popover
    
    enum Popover {
        static let title = NSLocalizedString(
            "Spellify",
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
        static let configure = NSLocalizedString(
            "Settings...",
            comment: "Settings menu item"
        )
        static let quit = NSLocalizedString(
            "Quit Spellify",
            comment: "Quit menu item"
        )
    }
    
    // MARK: - Notifications
    
    enum Notifications {
        static let processing = NSLocalizedString(
            "Spellifying your text...",
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
        static let prompt = NSLocalizedString(
            "Prompt",
            comment: "Action prompt label"
        )
        static let promptHelper = NSLocalizedString(
            "Tell the AI what to do with the selected text",
            comment: "Prompt helper text"
        )
        static let namePlaceholder = NSLocalizedString(
            "e.g., Fix Grammar",
            comment: "Action name placeholder"
        )
        static let promptPlaceholder = NSLocalizedString(
            "e.g., Fix any grammar and spelling errors...",
            comment: "Action prompt placeholder"
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
    
    // MARK: - Errors
    
    enum Errors {
        static let configureAPIKey = NSLocalizedString(
            "Please configure your API key in Settings",
            comment: "API key not configured error"
        )
    }
}
