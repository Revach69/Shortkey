# Development Guide - macOS App

> **Note**: This guide covers macOS app development.  
> For backend development, see [Backend Development](../../spellify-api/docs/DEVELOPMENT.md)  
> For general monorepo guide, see [General Development](../../docs/DEVELOPMENT.md)

---

## Prerequisites

- macOS 13.0+ (Ventura or later)
- Xcode 15.0+
- Swift 5.9+

---

## Getting Started

### 1. Open the Project

```bash
cd spellify-mac/
open Spellify.xcodeproj
```

### 2. Configure Signing (if needed)

1. Select project in Xcode
2. Go to "Signing & Capabilities"
3. Update Team and Bundle Identifier

### 3. Build and Run

- Press ⌘R or click Run
- Grant Accessibility permissions when prompted

### 4. Start Developing!

The app will connect to production backend by default.

---

## Project Structure

```
Spellify/
├── SpellifyApp.swift           # App entry point
├── AppDelegate.swift           # Menu bar setup, lifecycle
│
├── Models/                     # Data models
│   ├── SpellAction.swift       # Action with name + prompt
│   ├── AIModel.swift           # AI model info
│   ├── ConnectionStatus.swift  # Provider status
│   └── QuotaInfo.swift         # User quota
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
├── Services/                   # System integration
│   ├── SpellifyBackend/        # Backend API
│   ├── CryptoService.swift     # P256 signing
│   ├── KeychainService.swift   # Secure storage
│   ├── AccessibilityService.swift
│   ├── HotKeyManager.swift
│   └── SpellifyController.swift
│
├── Managers/                   # Business logic
│   ├── ActionsManager.swift    # CRUD operations
│   ├── AIProviderManager/      # Direct OpenAI
│   ├── SubscriptionManager/    # StoreKit 2
│   └── NotificationManager.swift
│
└── Utilities/                  # Helpers
    ├── Constants/
    ├── Strings.swift           # Localization
    ├── ProFeatures.swift
    ├── Logger.swift
    └── Debouncer.swift
```

---

## Development Workflows

### Adding a New Feature

1. **Read the docs**:
   - [BEST_PRACTICES.md](BEST_PRACTICES.md) - Code conventions
   - [FEATURES.md](FEATURES.md) - Feature specs
   - `.cursorrules` - Project rules

2. **Plan the change**:
   - Which layer? (View/Manager/Service)
   - New files or modify existing?
   - What tests are needed?

3. **Implement**:
   - Follow SOLID principles
   - Keep files < 150 lines
   - Use `Strings.swift` for text
   - Add SwiftUI previews

4. **Test**:
   - Run unit tests (⌘U)
   - Manual testing
   - Check all edge cases

5. **Document**:
   - Update relevant docs
   - Add comments explaining WHY

### Adding a New View

1. Check similar views in codebase
2. Follow existing patterns
3. Extract reusable components
4. Add to appropriate folder:
   - `Views/MenuBar/` - Popover views
   - `Views/Settings/` - Settings views
   - `Views/Sheets/` - Modal sheets
   - `Views/Components/` - Reusable components

### Adding a New Manager/Service

1. Decide: Manager (stateful) or Service (stateless)?
2. Create file in appropriate folder
3. Follow SOLID principles
4. Add protocol if needed for testing
5. Inject dependencies via init

---

## Running Tests

### From Xcode

- Press ⌘U to run all tests
- Use Test Navigator (⌘6) for specific tests

### From Command Line

```bash
xcodebuild test -scheme Spellify -destination 'platform=macOS'
```

### What to Test

✅ **DO test:**
- Business logic in Managers
- API response parsing
- Keychain operations
- Data transformations

❌ **DON'T test:**
- SwiftUI views (visual inspection)
- System services (manual testing)

---

## Debugging

### Accessibility Permissions

If hotkey doesn't work:
1. System Settings → Privacy & Security → Accessibility
2. Ensure Spellify is enabled
3. Restart app

### Menu Bar Icon Not Showing

1. Check Activity Monitor (is app running?)
2. Look for magic wand icon
3. Try clicking in menu bar area (macOS may hide icons)

### Backend Connection Issues

1. Check Console.app for error logs
2. Verify backend URL in `NetworkConstants.swift`
3. Test with curl to verify backend responds:

```bash
curl https://us-central1-PROJECT.cloudfunctions.net/registerDevice \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"data": {"deviceId": "test", "publicKey": "test"}}'
```

### Build Errors

1. Clean build folder (⌘⇧K)
2. Delete derived data:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. Restart Xcode

---

## Working with Backend

### Using Production Backend (Default)

```swift
// NetworkConstants.swift
static let backendBaseURL = "https://us-central1-PROJECT.cloudfunctions.net"
```

App works out of the box!

### Using Local Backend (Development)

1. Start backend emulators:
   ```bash
   cd ../spellify-api/
   firebase emulators:start
   ```

2. Update `NetworkConstants.swift`:
   ```swift
   static let backendBaseURL = "http://localhost:5001/PROJECT/us-central1"
   ```

3. Build and run

4. **Remember** to revert before committing!

---

## Building for Release

### Debug Build (Development)

```bash
# From Xcode: ⌘R
# Or from command line:
xcodebuild -scheme Spellify -configuration Debug
```

### Release Build (Distribution)

1. **Archive**:
   - Product → Archive
   - Wait for build to complete

2. **Distribute**:
   - Distribute App → Copy App
   - Choose destination

3. **Notarize**:
   - Required for distribution outside App Store
   - Use `notarytool`:
   ```bash
   xcrun notarytool submit Spellify.app.zip \
     --apple-id your@email.com \
     --team-id TEAM_ID \
     --password APP_SPECIFIC_PASSWORD
   ```

4. **Staple**:
   ```bash
   xcrun stapler staple Spellify.app
   ```

### Release Checklist

- [ ] Update version in `Info.plist`
- [ ] Update `CHANGELOG.md`
- [ ] Test on clean macOS installation
- [ ] Test Accessibility permissions flow
- [ ] Test with both Free and Pro tiers
- [ ] Notarize with Apple
- [ ] Create GitHub release with binary

---

## Common Tasks

### Adding a New Action

```swift
// Models/SpellAction.swift
extension SpellAction {
    static let defaults: [SpellAction] = [
        // ... existing ...
        SpellAction(
            name: "New Action",
            description: "Prompt for AI",
            icon: "star.fill"  // SF Symbol
        ),
    ]
}
```

### Adding a New Constant

```swift
// Utilities/Constants/LayoutConstants.swift
enum LayoutConstants {
    static let newValue: CGFloat = 20
}
```

### Adding a New Localized String

```swift
// Utilities/Strings.swift
enum Strings {
    enum NewFeature {
        static let title = NSLocalizedString(
            "new.feature.title",
            comment: "New feature title"
        )
    }
}

// Resources/Localizable.strings
"new.feature.title" = "Feature Title";
```

---

## Code Style

### File Organization

```swift
//
//  FileName.swift
//  Spellify
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

// MARK: - Preview

#if DEBUG
struct MainType_Previews: PreviewProvider {
    static var previews: some View {
        MainType()
    }
}
#endif
```

### SwiftUI Previews

Always add previews for views:

```swift
#if DEBUG
struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
            .environmentObject(ActionsManager.preview)
    }
}
#endif
```

---

## Related Documentation

- [Best Practices](BEST_PRACTICES.md) - Swift/SwiftUI conventions
- [Features](FEATURES.md) - Feature specifications
- [Architecture](../../docs/ARCHITECTURE.md) - System design
- [General Development](../../docs/DEVELOPMENT.md) - Monorepo guide
- [Backend Development](../../spellify-api/docs/DEVELOPMENT.md) - Backend setup
