# Development Guide

## Prerequisites

- macOS 13.0+ (Ventura or later)
- Xcode 15.0+
- Swift 5.9+

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/spellify.git
   cd spellify
   ```

2. Open in Xcode:
   ```bash
   open Spellify.xcodeproj
   ```

3. Build and run (⌘R)

4. Grant Accessibility permissions when prompted

5. Configure your OpenAI API key via the menu bar popover

## Project Structure

```
Spellify/
├── Spellify/           # Main app target
├── SpellifyTests/      # Unit tests
├── SpellifyUITests/    # UI tests (not used in v1)
└── docs/               # Documentation
```

## Running Tests

### From Xcode

- Press ⌘U to run all tests
- Use the Test Navigator (⌘6) to run specific tests

### From Command Line

```bash
xcodebuild test -scheme Spellify -destination 'platform=macOS'
```

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed architecture documentation.

## Adding a New AI Provider

1. Create a new folder in `AIProviders/`:
   ```
   AIProviders/
   └── Gemini/
       ├── GeminiProvider.swift
       └── GeminiModels.swift
   ```

2. Implement the `AIModelProvider` protocol:
   ```swift
   final class GeminiProvider: AIModelProvider {
       let id = "gemini"
       let displayName = "Google Gemini"
       // ... implement all required methods
   }
   ```

3. Update `AIProviderManager` to support provider switching (future enhancement)

## Adding a New Action

Default actions are defined in `SpellAction.swift`:

```swift
extension SpellAction {
    static let defaults: [SpellAction] = [
        SpellAction(name: "Fix Grammar", prompt: "..."),
        // Add new default actions here
    ]
}
```

## Debugging

### Accessibility Permissions

If the hotkey doesn't work:
1. Check System Settings → Privacy & Security → Accessibility
2. Ensure Spellify is listed and enabled
3. If not, run the app and it should prompt for permissions

### API Issues

1. Check the connection status in the popover
2. Test the API key using the Test button in Settings
3. Check Console.app for error logs

### Menu Bar Icon Not Showing

1. Check if app is running (Activity Monitor)
2. Look for the magic wand icon in the menu bar
3. Try clicking in the menu bar area - macOS may be hiding icons

## Code Style

### Naming Conventions

- Views: `*View` (e.g., `ActionsListView`)
- Sections: `*Section` (e.g., `AIProviderSection`)
- Panels: `*Panel` (e.g., `ActionPickerPanel`)
- Services: `*Service` (e.g., `KeychainService`)
- Managers: `*Manager` (e.g., `ActionsManager`)

### File Organization

Use `// MARK: -` comments to organize code:

```swift
// MARK: - Properties
// MARK: - Initialization
// MARK: - Public Methods
// MARK: - Private Methods
```

### SwiftUI

- Keep views small and focused (< 100 lines)
- Extract reusable components to `Views/Components/`
- Use `@EnvironmentObject` for shared state

## Testing Guidelines

### What to Test

- ✅ Business logic in Managers
- ✅ API response parsing in Providers
- ✅ Keychain operations in Services
- ❌ SwiftUI views (use visual inspection)
- ❌ System services (AccessibilityService, HotKeyManager)

### Mocking

Use protocols for dependencies to enable mocking:

```swift
// Define protocol
protocol KeychainServiceProtocol {
    func save(key: String, value: String) throws
}

// Use in production
class OpenAIProvider {
    init(keychain: KeychainServiceProtocol = KeychainService()) {}
}

// Use mock in tests
let mock = MockKeychainService()
let provider = OpenAIProvider(keychain: mock)
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## Troubleshooting

### Build Errors

1. Clean build folder (⌘⇧K)
2. Delete derived data:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. Restart Xcode

### Signing Issues

1. Update Team in project settings
2. Ensure you have valid development certificates



