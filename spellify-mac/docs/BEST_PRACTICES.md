# Best Practices - macOS App (Swift + SwiftUI)

> **Note**: This document covers Swift and SwiftUI specific best practices.  
> For general architectural principles, see [General Best Practices](../../docs/BEST_PRACTICES.md)

---

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

**Example:**
```swift
// Bad: 300+ lines in one file ❌
struct SettingsView: View {
    // Everything here
}

// Good: Composable components ✅
struct SettingsView: View {
    var body: some View {
        VStack {
            AIProviderSection()
            ShortcutSection()
            PreferencesSection()
            SubscriptionSection()
        }
    }
}
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
- Services end with `Service` (e.g., `KeychainService`)
- Managers end with `Manager` (e.g., `ActionsManager`)

---

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

### @MainActor for UI Updates

```swift
@MainActor
final class ActionsManager: ObservableObject {
    @Published private(set) var actions: [SpellAction] = []
    
    func add(_ action: SpellAction) {
        // Automatically runs on main thread
        actions.append(action)
    }
}
```

---

## Apple Best Practices

### Localization

❌ **NEVER use hardcoded strings** in production code  
✅ **ALWAYS use** `Strings.swift` for user-facing text

```swift
// Bad ❌
Text("Save")
Button("Delete")

// Good ✅
Text(Strings.ActionEditor.save)
Button(Strings.Common.delete)
```

**Strings.swift structure:**
```swift
enum Strings {
    enum Common {
        static let save = NSLocalizedString("common.save", comment: "Save button")
        static let delete = NSLocalizedString("common.delete", comment: "Delete button")
    }
    
    enum ActionEditor {
        static let title = NSLocalizedString("action.editor.title", comment: "Action editor title")
    }
}
```

### Constants

❌ **NEVER use magic numbers**  
✅ **ALWAYS use** `Constants.swift` for non-translatable values

```swift
// Bad ❌
.padding(17)
.frame(width: 320)

// Good ✅
.padding(LayoutConstants.standardPadding)
.frame(width: LayoutConstants.popoverWidth)
```

**Constants structure:**
```swift
// LayoutConstants.swift
enum LayoutConstants {
    static let standardPadding: CGFloat = 16
    static let popoverWidth: CGFloat = 320
}

// NetworkConstants.swift
enum NetworkConstants {
    static let backendBaseURL = "https://api.spellify.app"
    static let requestTimeout: TimeInterval = 10.0
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
- `StoreKit 2` for subscriptions

---

## File Size Limits

✅ Keep files **< 150 lines** (preferred)  
✅ Max **200 lines** absolute limit  
✅ If larger, **break into small components** under a new folder

**Example:**
```
// Bad: 300+ line file ❌
Views/Sheets/ActionEditorSheet.swift (300 lines)

// Good: Split into focused components ✅
Views/Sheets/ActionEditor/
├── ActionEditorHeader.swift      (35 lines)
├── ActionIconPicker.swift        (67 lines)
├── ActionNameField.swift         (39 lines)
├── ActionPromptEditor.swift      (59 lines)
└── ActionEditorFooter.swift      (79 lines)

Views/Sheets/
└── ActionEditorSheet.swift       (118 lines - composes components)
```

---

## Comments & Documentation

✅ Comments explain **WHY**, never **WHAT**  
❌ **NO trivial comments** that repeat the code  
✅ Clear naming is better than comments

```swift
// Bad ❌
/// Can user add more actions?
var canAddAction: Bool { ... }

/// Updates an existing action
func update(_ action: SpellAction) { ... }

// Good ✅
// Debounce saves to avoid excessive writes to UserDefaults
DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)

// All Pro features require subscription (business policy decision)
return isProUser
```

---

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

### What to Test

- ✅ Business logic in Managers
- ✅ API response parsing in Providers
- ✅ Keychain operations in Services
- ❌ SwiftUI views (use visual inspection)
- ❌ System services (AccessibilityService, HotKeyManager)

---

## Code Organization

### MARK Comments

Use MARK comments to organize code:

```swift
// MARK: - Properties
@Published private(set) var actions: [SpellAction] = []

// MARK: - Initialization
init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
}

// MARK: - Public Methods
func add(_ action: SpellAction) { ... }

// MARK: - Private Methods
private func save() { ... }
```

### File Structure

```swift
//
//  FileName.swift
//  Spellify
//
//  Description of file purpose
//

import Foundation
import SwiftUI

// MARK: - Main Type

struct/class MainType {
    // MARK: - Properties
    // MARK: - Initialization
    // MARK: - Public Methods
    // MARK: - Private Methods
}

// MARK: - Extensions

extension MainType {
    // Extension methods
}

// MARK: - Preview

#if DEBUG
struct MainType_Previews: PreviewProvider {
    static var previews: some View {
        MainType()
    }
}
#endif
```

---

## Perfect Examples in Codebase

### Views
- `Views/Sheets/ActionEditor/ActionIconPicker.swift` - Small, focused component (67 lines)
- `Views/Sheets/ActionEditor/ActionNameField.swift` - Simple input field (39 lines)
- `Views/Settings/Components/ConnectionStatusRow.swift` - Display component

### Managers
- `Managers/ActionsManager.swift` - CRUD with persistence, ObservableObject
- `Managers/SubscriptionManager/` - Folder structure for complex managers

### Services
- `Services/KeychainService.swift` - Simple stateless service
- `Services/SpellifyBackend/` - Folder structure for complex services

### Models
- `Models/QuotaInfo.swift` - Domain model with rich logic
- `Models/SpellAction.swift` - Codable model with defaults

---

## Anti-Patterns (Never Do)

```swift
// ❌ Hardcoded strings
Text("Save")
Button("Delete")

// ❌ Magic numbers
.padding(17)
.frame(width: 320)

// ❌ Trivial comments
/// Updates an existing action
func update(_ action: SpellAction) { ... }

// ❌ Large files (> 200 lines)
struct HugeView: View {
    // 300+ lines
}

// ❌ DTOs in Models/ folder
// Models/BackendResponse.swift - Should be in service folder!
```

---

## Related Documentation

- [General Best Practices](../../docs/BEST_PRACTICES.md) - SOLID, Clean Architecture
- [Development Guide](DEVELOPMENT.md) - Setup, building, testing
- [Features](FEATURES.md) - Feature specifications
- [Architecture](../../docs/ARCHITECTURE.md) - System design
