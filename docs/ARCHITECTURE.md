# Spellify Architecture

## Overview

Spellify follows a clean architecture with clear separation of concerns, making it easy to understand, test, and extend.

```
┌─────────────────────────────────────────────────────────────┐
│                        Views Layer                          │
│  (SwiftUI views - MenuBar, Settings, ActionPicker)         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Managers Layer                         │
│  (ActionsManager, AIProviderManager, NotificationManager)  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Services Layer                         │
│  (KeychainService, AccessibilityService, HotKeyManager)    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    AI Providers Layer                       │
│  (OpenAIProvider - implements AIModelProvider protocol)    │
└─────────────────────────────────────────────────────────────┘
```

## Directory Structure

```
Spellify/
├── SpellifyApp.swift           # App entry point
├── AppDelegate.swift           # Menu bar setup, lifecycle
│
├── Models/                     # Data models
│   ├── SpellAction.swift       # Action with name + prompt
│   ├── AIModel.swift           # AI model info
│   └── ConnectionStatus.swift  # Provider status enum
│
├── Protocols/                  # Abstractions
│   └── AIModelProvider.swift   # Provider interface
│
├── AIProviders/                # Provider implementations
│   └── OpenAI/
│       ├── OpenAIProvider.swift
│       └── OpenAIModels.swift
│
├── Views/                      # UI components
│   ├── MenuBar/                # Popover views
│   ├── Settings/               # Settings window
│   ├── ActionPicker/           # Floating picker
│   ├── Sheets/                 # Modal sheets
│   └── Components/             # Reusable components
│
├── Services/                   # System services
│   ├── KeychainService.swift   # Secure storage
│   ├── AccessibilityService.swift
│   ├── HotKeyManager.swift
│   └── SpellifyController.swift
│
├── Managers/                   # Business logic
│   ├── ActionsManager.swift    # CRUD operations
│   ├── AIProviderManager.swift # Provider state
│   └── NotificationManager.swift
│
└── Utilities/                  # Helpers
    ├── Constants.swift
    └── Strings.swift           # Localization
```

## Key Components

### AppDelegate

The main coordinator that sets up:
- Menu bar status item with icon
- Popover with SwiftUI content
- Global hotkey listener
- SpellifyController configuration

### SpellifyController

Orchestrates the main transformation flow:
1. Receives hotkey event
2. Gets selected text via AccessibilityService
3. Shows ActionPickerPanel
4. Transforms text via AIProviderManager
5. Replaces text via AccessibilityService

### AIModelProvider Protocol

Defines the interface for AI providers, enabling easy addition of new providers:

```swift
protocol AIModelProvider {
    var id: String { get }
    var displayName: String { get }
    var isConfigured: Bool { get }
    var connectionStatus: ConnectionStatus { get }
    
    func configure(apiKey: String) async
    func testConnection() async throws -> Bool
    func fetchAvailableModels() async throws -> [AIModel]
    func transform(text: String, prompt: String, model: String) async throws -> String
}
```

### Managers

- **ActionsManager**: CRUD for actions, persisted to UserDefaults
- **AIProviderManager**: Manages active provider, model selection, transformation
- **NotificationManager**: System notifications for status updates

### Services

- **KeychainService**: Secure storage using macOS Keychain
- **AccessibilityService**: Get/replace selected text via simulated keystrokes
- **HotKeyManager**: Global keyboard shortcut using CGEvent tap

## Data Flow

### Configuration Flow

```
User enters API key → AIProviderManager.configure()
                           ↓
                    KeychainService.save()
                           ↓
                    AIProviderManager.testConnection()
                           ↓
                    OpenAIProvider.fetchAvailableModels()
                           ↓
                    Update UI status
```

### Transformation Flow

```
Hotkey pressed → SpellifyController.handleHotKeyPressed()
                           ↓
                 AccessibilityService.getSelectedText()
                           ↓
                 ActionPickerPanel.show()
                           ↓
                 User selects action
                           ↓
                 AIProviderManager.transform()
                           ↓
                 OpenAIProvider.transform() → OpenAI API
                           ↓
                 AccessibilityService.replaceSelectedText()
```

## State Management

- **@Published properties** in Managers for reactive updates
- **@EnvironmentObject** for passing managers to views
- **@AppStorage** for simple preferences
- **UserDefaults** for actions persistence
- **Keychain** for secure API key storage



