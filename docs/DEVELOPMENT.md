# Development Guide

This guide covers development for both the macOS client and the Firebase backend.

---

## Prerequisites

### macOS Client
- macOS 13.0+ (Ventura or later)
- Xcode 15.0+
- Swift 5.9+

### Backend (Optional for client-only development)
- Node.js 18+
- Firebase CLI (`npm install -g firebase-tools`)
- Firebase project
- OpenAI API key

---

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/your-repo/spellify.git
cd spellify
```

### macOS Client Setup

1. Navigate to Mac app:
   ```bash
   cd spellify-mac/
   ```

2. Open in Xcode:
   ```bash
   open Spellify.xcodeproj
   ```

3. Build and run (⌘R)

4. Grant Accessibility permissions when prompted

5. App will connect to production Firebase backend by default

### Backend Setup (Optional)

1. Navigate to API:
   ```bash
   cd spellify-api/
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Link to your project:
   ```bash
   firebase use --add
   ```

4. Install dependencies:
   ```bash
   cd functions/
   npm install
   ```

5. Start emulators:
   ```bash
   cd ..
   firebase emulators:start
   ```

6. Update client to use local backend (in `FirebaseBackendManager.swift`):
   ```swift
   private let baseURL = "http://localhost:5001/PROJECT-ID/us-central1"
   ```

See [spellify-api/README.md](../spellify-api/README.md) for detailed backend setup.

## Project Structure

```
spellify/               # Monorepo root
├── spellify-mac/      # macOS app
│   ├── Spellify/      # Main app target
│   └── SpellifyUITests/
├── spellify-api/      # Firebase backend
│   └── functions/     # Cloud Functions
└── docs/              # Shared documentation
```

See [MONOREPO.md](MONOREPO.md) for detailed structure.

## Running Tests

### macOS Client Tests

**From Xcode:**
- Press ⌘U to run all tests
- Use the Test Navigator (⌘6) to run specific tests

**From Command Line:**
```bash
cd spellify-mac/
xcodebuild test -scheme Spellify -destination 'platform=macOS'
```

### Backend Tests

**Local Testing with Emulators:**
```bash
cd spellify-api/
firebase emulators:start
```

**Manual API Testing:**
```bash
# Register device
curl -X POST http://localhost:5001/PROJECT/us-central1/registerDevice \
  -H "Content-Type: application/json" \
  -d '{"data": {"deviceId": "test-123", "publicKey": "BASE64_KEY"}}'

# Transform text
curl -X POST http://localhost:5001/PROJECT/us-central1/transform \
  -H "Content-Type: application/json" \
  -d '{"data": {"deviceId": "test-123", "text": "hello", "signature": "..."}}'
```

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed architecture documentation.

---

## Development Workflows

### Working on macOS Client Only

1. Use production Firebase backend (default)
2. Focus on UI, UX, and client features
3. Test with real backend quota limits
4. No backend setup needed

### Working on Backend Only

1. Start Firebase emulators
2. Use curl/Postman for testing
3. Check Firestore data in emulator UI
4. Monitor Cloud Functions logs

### Working on Both (Full Stack)

1. Start Firebase emulators
2. Update client to use local backend
3. Run Xcode and Firebase emulators simultaneously
4. Test end-to-end flows

---

## Common Development Tasks

### Adding a New Action (Client)

1. Update default actions in `SpellAction.swift`
2. Add icon from SF Symbols
3. Mark as Pro if needed
4. Test in Action Picker

### Adding a New AI Provider (Backend)

1. Create service in `spellify-api/functions/src/services/`
2. Add configuration to `config.ts`
3. Update `transform` function in `index.ts`
4. Test with emulators
5. Deploy to Firebase

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

### macOS Client

**Accessibility Permissions:**
If the hotkey doesn't work:
1. System Settings → Privacy & Security → Accessibility
2. Ensure Spellify is enabled
3. Restart app after granting permissions

**Menu Bar Icon Not Showing:**
1. Check Activity Monitor (is app running?)
2. Look for magic wand icon
3. Try clicking in menu bar area

**Backend Connection Issues:**
1. Check Console.app for error logs
2. Verify Firebase URL in `FirebaseBackendManager.swift`
3. Test with curl to verify backend is responding

### Backend

**Cloud Functions Not Working:**
1. Check Firebase Console → Functions → Logs
2. Verify OpenAI API key is set: `firebase functions:config:get`
3. Check Firestore rules are deployed

**Emulators Not Starting:**
1. Check if ports are in use (5001, 8080)
2. Try `firebase emulators:start --only functions,firestore`
3. Clear emulator data: `rm -rf .firebase/`

**Signature Verification Failing:**
1. Check device is registered in Firestore
2. Verify public key format (Base64)
3. Check canonical request format matches client

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
3. Follow project-specific `.cursorrules`
4. Write tests for new functionality
5. Ensure all tests pass
6. Update relevant documentation
7. Submit a pull request

### Code Review Checklist

**macOS Client:**
- [ ] Follows Swift conventions in `.cursorrules`
- [ ] No hardcoded strings (use `Strings.swift`)
- [ ] Files under 150 lines
- [ ] SwiftUI previews added
- [ ] Comments explain WHY not WHAT

**Backend:**
- [ ] Follows TypeScript conventions in `.cursorrules`
- [ ] All inputs validated
- [ ] Proper error handling
- [ ] Uses transactions for atomic operations
- [ ] Tested with emulators

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



