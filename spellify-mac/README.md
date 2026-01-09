# Spellify - macOS App

> Native macOS menu bar app for AI-powered text transformation

[![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)](https://www.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.9+-blue.svg)](https://developer.apple.com/xcode/swiftui/)

---

## 📱 What is this?

This is the **macOS client** for Spellify — a menu bar app that lets you transform any selected text using AI, from anywhere on your Mac.

Part of the [Spellify monorepo](../README.md) — see backend at [`spellify-api/`](../spellify-api/).

---

## ✨ Features

- 🎯 **Menu Bar Integration** - Lives in your menu bar, no dock icon
- ⌨️ **Global Keyboard Shortcut** - Default: ⌘⇧S (customizable)
- 🎨 **Custom Actions** - Create your own text transformation prompts
- 🔐 **Secure** - API keys in Keychain, crypto-signed requests
- 🚀 **Fast** - Native Swift performance
- 💎 **Beautiful** - SwiftUI + Apple HIG compliant
- 🔄 **Subscriptions** - StoreKit 2 integration (free + pro tiers)

---

## 🏗️ Architecture

```
Spellify/
├── AIProviders/           # AI provider implementations
│   └── OpenAI/           # OpenAI integration
├── Managers/             # Business logic (@Published state)
│   ├── ActionsManager.swift
│   ├── AIProviderManager/
│   ├── NotificationManager.swift
│   └── SubscriptionManager/
├── Models/               # Data models
│   ├── SpellAction.swift
│   ├── AIModel.swift
│   └── ConnectionStatus.swift
├── Protocols/            # Abstractions
│   └── AIModelProvider.swift
├── Services/             # System integration
│   ├── AccessibilityService.swift
│   ├── CryptoService.swift
│   ├── FirebaseBackendManager.swift
│   ├── HotKeyManager.swift
│   ├── KeychainService.swift
│   └── SpellifyController.swift
├── Utilities/            # Helpers and constants
│   ├── Constants/
│   ├── Debouncer.swift
│   ├── Logger.swift
│   ├── ProFeatures.swift
│   └── Strings.swift
├── Views/                # SwiftUI views
│   ├── MenuBar/          # Menu bar popover
│   ├── Settings/         # Settings window
│   ├── ActionPicker/     # Floating action picker
│   ├── Sheets/           # Modal sheets
│   └── Components/       # Reusable components
└── Resources/            # Assets and localization
```

See [`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md) for detailed architecture.

---

## 🚀 Getting Started

### Prerequisites

- macOS 13.0 (Ventura) or later
- Xcode 15.0+
- Swift 5.9+

### Setup

1. **Open the project**:
   ```bash
   cd spellify-mac/
   open Spellify.xcodeproj
   ```

2. **Update Team & Bundle ID** (if needed):
   - Select project in Xcode
   - Go to "Signing & Capabilities"
   - Update Team and Bundle Identifier

3. **Build and Run**:
   - Press ⌘R or click Run
   - Grant Accessibility permissions when prompted

4. **Configure API**:
   - Click menu bar icon
   - Enter OpenAI API key in Settings
   - Or: Backend will be auto-configured if deployed

---

## 🎯 Key Components

### AppDelegate
Main coordinator — sets up menu bar, popover, hotkey listener.

### SpellifyController
Orchestrates transformation flow:
1. Receives hotkey event
2. Gets selected text (AccessibilityService)
3. Shows ActionPickerPanel
4. Transforms text (AIProviderManager or SpellifyBackendService)
5. Replaces text (AccessibilityService)

### Managers
- **ActionsManager**: CRUD for custom actions (persisted to UserDefaults)
- **AIProviderManager**: Direct OpenAI integration (legacy/fallback)
- **SubscriptionManager**: StoreKit 2 subscriptions
- **NotificationManager**: System notifications

### Services
- **AccessibilityService**: Get/replace selected text via CGEvent
- **CryptoService**: P256 keypair, request signing
- **SpellifyBackend/**: Secure backend API communication
  - **SpellifyBackendService**: Main backend service
  - **DeviceRegistration**: Device registration
  - **TextTransformer**: Text transformation
  - **BackendHTTPClient**: HTTP communication
  - **ResponseParser**: JSON parsing
  - **BackendModels**: Data models
  - **BackendError**: Error types
- **HotKeyManager**: Global keyboard shortcut (CGEvent tap)
- **KeychainService**: Secure storage for API keys

---

## 🔄 Data Flow

### Transformation Flow (Backend Mode)

```
User presses ⌘⇧S
      ↓
HotKeyManager → SpellifyController
      ↓
AccessibilityService.getSelectedText()
      ↓
ActionPickerPanel.show()
      ↓
User selects action
      ↓
SpellifyBackendService.transformText()
  - Signs request with CryptoService
  - Calls backend via BackendHTTPClient
  - Backend validates, checks quota, calls OpenAI
  - Returns transformed text
      ↓
AccessibilityService.replaceSelectedText()
      ↓
NotificationManager: "Done!"
```

---

## 📝 Code Conventions

### File Size
- ✅ Keep files **< 150 lines** (preferred)
- ✅ Max **200 lines** absolute limit
- ✅ Break large files into components

### Localization
- ❌ **NEVER hardcode strings** in production code
- ✅ **ALWAYS use** `Strings.swift` for user-facing text
- ✅ **ALWAYS use** constants for non-translatable values

### Component Structure
- One component per file
- Single Responsibility Principle
- Group related components in subfolders

### Comments
- ✅ Comments explain **WHY**, never **WHAT**
- ❌ **NO trivial comments** that repeat the code
- ✅ Clear naming is better than comments

See [`.cursorrules`](.cursorrules) for complete guidelines.

---

## 🧪 Testing

### Run Tests
```bash
# From Xcode: ⌘U
# From terminal:
xcodebuild test -scheme Spellify -destination 'platform=macOS'
```

### What to Test
- ✅ Business logic in Managers
- ✅ API response parsing
- ✅ Keychain operations
- ❌ SwiftUI views (visual inspection)
- ❌ System services (manual testing)

---

## 🐛 Debugging

### Accessibility Permissions
If hotkey doesn't work:
1. System Settings → Privacy & Security → Accessibility
2. Ensure Spellify is enabled
3. Restart app

### Menu Bar Icon Not Showing
1. Check Activity Monitor (is app running?)
2. Look for magic wand icon in menu bar
3. Try clicking in menu bar area (macOS may hide icons)

### API Issues
1. Check connection status in popover
2. Test API key in Settings
3. Check Console.app for error logs

---

## 📦 Building for Release

### Archive
1. Product → Archive
2. Distribute App → Copy App
3. Notarize with Apple (required for distribution)

### Release Checklist
- [ ] Update version in `Info.plist`
- [ ] Update `CHANGELOG.md`
- [ ] Test on clean macOS installation
- [ ] Test Accessibility permissions flow
- [ ] Test with both Free and Pro tiers
- [ ] Create GitHub release with binary

---

## 🔗 Related Documentation

- [Main README](../README.md) - Monorepo overview
- [Architecture](../docs/ARCHITECTURE.md) - System design
- [Features](../docs/FEATURES.md) - Feature specs
- [Best Practices](../docs/BEST_PRACTICES.md) - Code conventions
- [Development Guide](../docs/DEVELOPMENT.md) - Dev workflow

---

## 📄 License

MIT License - see [LICENSE](../LICENSE) file for details.

---

**Need help?** Check the [docs](../docs/) or open an issue!
