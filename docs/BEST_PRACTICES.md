# Best Practices Used in Spellify

## SOLID Principles

### Single Responsibility Principle (SRP)

Each component has one job:

- `StatusIndicator` - Only renders a colored dot
- `KeychainService` - Only handles Keychain operations
- `NotificationManager` - Only manages system notifications
- `ActionsManager` - Only manages CRUD for actions

### Open/Closed Principle (OCP)

The `AIModelProvider` protocol allows adding new providers without modifying existing code:

```swift
protocol AIModelProvider {
    func transform(text: String, prompt: String, model: String) async throws -> String
    // ...
}

// OpenAI implementation
class OpenAIProvider: AIModelProvider { ... }

// Future: Add Gemini without changing existing code
class GeminiProvider: AIModelProvider { ... }
```

### Liskov Substitution Principle (LSP)

Any `AIModelProvider` implementation can be used interchangeably:

```swift
let manager = AIProviderManager(provider: OpenAIProvider())
// or
let manager = AIProviderManager(provider: GeminiProvider())
```

### Interface Segregation Principle (ISP)

Small, focused protocols:

```swift
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

protocol KeychainServiceProtocol {
    func save(key: String, value: String) throws
    func retrieve(key: String) throws -> String?
    func delete(key: String) throws
}
```

### Dependency Inversion Principle (DIP)

High-level modules depend on abstractions:

```swift
class AIProviderManager {
    private var provider: AIModelProvider  // Protocol, not concrete type
    
    init(provider: AIModelProvider) {
        self.provider = provider
    }
}
```

## SwiftUI Patterns

### Small, Composable Views

Each view file is focused and under 100 lines:

```
MenuBarPopoverView
├── PopoverHeaderView
├── ActionsListView
│   └── ActionRowView (reusable)
├── ProviderStatusView
│   └── StatusIndicator (reusable)
└── PopoverFooterView
```

### Environment Objects for Dependency Injection

```swift
@main
struct SpellifyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    // AppDelegate creates and owns managers
}

// Views receive managers via environment
struct MenuBarPopoverView: View {
    @EnvironmentObject var actionsManager: ActionsManager
    @EnvironmentObject var aiProviderManager: AIProviderManager
}
```

### Semantic Naming

- Views end with `View` (e.g., `ActionsListView`)
- Sections end with `Section` (e.g., `AIProviderSection`)
- Panels end with `Panel` (e.g., `ActionPickerPanel`)

## Async/Await

Modern Swift concurrency throughout:

```swift
func transform(text: String, action: SpellAction) async throws -> String {
    return try await provider.transform(
        text: text,
        prompt: action.prompt,
        model: selectedModel.id
    )
}
```

## Testability

### Protocol-Based Dependencies

```swift
// Production
let provider = OpenAIProvider(
    session: URLSession.shared,
    keychain: KeychainService()
)

// Test
let provider = OpenAIProvider(
    session: MockURLSession(),
    keychain: MockKeychainService()
)
```

### Isolated UserDefaults in Tests

```swift
override func setUp() {
    testDefaults = UserDefaults(suiteName: "TestSuite")!
    sut = ActionsManager(defaults: testDefaults)
}

override func tearDown() {
    testDefaults.removePersistentDomain(forName: "TestSuite")
}
```

## Apple Best Practices

### Localization

All strings in `Strings.swift`:

```swift
enum Strings {
    enum Popover {
        static let title = NSLocalizedString("Spellify", comment: "App name")
    }
}
```

### Secure Storage

API keys in Keychain, not UserDefaults:

```swift
let query: [String: Any] = [
    kSecClass as String: kSecClassGenericPassword,
    kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
]
```

### System Integration

- `SMAppService` for launch at login
- `UNUserNotificationCenter` for notifications
- `NSStatusItem` for menu bar
- `CGEvent` for keyboard events

## Error Handling

### Typed Errors

```swift
enum TextTransformError: LocalizedError {
    case textTooLong
    case providerNotConfigured
    case noTextSelected
    
    var errorDescription: String? {
        switch self {
        case .textTooLong: return "Text too long"
        // ...
        }
    }
}
```

### Graceful Degradation

```swift
// If model fetch fails, keep using existing models
do {
    availableModels = try await provider.fetchAvailableModels()
} catch {
    print("Failed to fetch models: \(error)")
    // Keep using existing models
}
```

## Code Organization

### File Structure

```
Feature/
├── FeatureView.swift          # Main view
├── FeatureSubView.swift       # Sub-component
└── FeatureViewModel.swift     # If needed
```

### Comment Style

```swift
// MARK: - Properties
// MARK: - Initialization
// MARK: - Public Methods
// MARK: - Private Methods
```



