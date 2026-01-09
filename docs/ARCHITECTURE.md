# Spellify Architecture

## Overview

Spellify is a client-server application with clean separation of concerns, making it easy to understand, test, and extend.

---

## System Architecture

### Two-Tier Architecture

Spellify is built as a monorepo with two independent projects:

1. spellify-mac - Native macOS client (Swift + SwiftUI)
2. spellify-api - Secure backend (TypeScript + Firebase)

This architecture provides:
- Security: Backend validates all requests, prevents abuse
- Scalability: Backend can serve multiple clients
- Cost Control: Quota and rate limiting built-in
- Flexibility: Easy to add new AI providers or platforms

---

## macOS Client Architecture

### Bundle Identifier Strategy

**Current:** `app.spellify.mac`

**Naming Convention:**
- Uses reverse domain notation with owned domain `spellify.app`
- Platform-specific suffix (`.mac`) allows for future expansion
- Future platforms: `app.spellify.ios`, `app.spellify.ipad`
- Shared data via App Groups: `group.app.spellify`

**Why not `app.spellify.Spellify`?**
- Redundant product name
- Platform suffix is clearer and more scalable

### Layer Architecture

Views Layer -> Managers Layer -> Services Layer -> System Integration

### Directory Structure

See spellify-mac/README.md for detailed directory structure.

Key directories:
- Models/ - Data models
- Protocols/ - Abstractions
- AIProviders/ - AI provider implementations
- Views/ - SwiftUI components
- Services/ - System integration
- Managers/ - Business logic
- Utilities/ - Helpers and constants

---

## Backend Architecture

### Service-Oriented Architecture

Functions:
- index.ts - Cloud Function endpoints (registerDevice, transform)
- types.ts - TypeScript interfaces
- config.ts - Configuration
- validation.ts - Input validation
- crypto.ts - Signature verification
- services/ - Business logic modules

### Firestore Collections

devices - Device registry
rateLimits - Rate limiting (TTL: 2 min)
usageLogs - Analytics

---

## Key Components

### macOS Client

AppDelegate - Main coordinator, menu bar setup
SpellifyController - Orchestrates transformation flow
FirebaseBackendManager - Backend API communication
CryptoService - P256 signing
ActionsManager - CRUD for actions
SubscriptionManager - StoreKit 2 integration
KeychainService - Secure storage
AccessibilityService - Get/replace selected text
HotKeyManager - Global keyboard shortcut

### Backend

registerDevice - Device registration endpoint
transform - Text transformation endpoint
deviceCollection - Device CRUD
rateLimitCollection - Rate limiting (atomic)
quotaService - Quota management (atomic)
openAiApi - OpenAI integration
analyticsCollection - Usage logging

---

## Data Flow

### Initial Setup Flow

1. App Launch
2. CryptoService generates keypair
3. Private key stored in Keychain
4. FirebaseBackendManager registers device
5. Backend creates device document
6. Ready for transformations

### Transformation Flow

1. User presses keyboard shortcut
2. HotKeyManager triggers SpellifyController
3. AccessibilityService gets selected text
4. ActionPickerPanel shows
5. User selects action
6. FirebaseBackendManager signs and sends request
7. Backend verifies signature, checks limits, calls OpenAI
8. AccessibilityService replaces text
9. NotificationManager shows status

---

## Security Architecture

### Crypto Signing (P256)

- Private key stored in Keychain (never leaves device)
- Public key sent to backend during registration
- Requests signed with canonical format
- Backend verifies signatures
- Prevents device ID spoofing

### Rate Limiting

- 10 requests per minute per device
- Atomic Firestore transaction
- Auto-cleanup via TTL

### Quota Management

- Free tier: 10 requests/day, 500 chars max
- Pro tier: 1000 requests/day, 2000 chars max
- Atomic Firestore transaction
- Auto-reset at midnight UTC

### Firestore Security Rules

All collections have server-only access. Direct client access is completely blocked.

---

## State Management

### macOS Client

- @Published properties in Managers
- @EnvironmentObject for dependency injection
- @AppStorage for preferences
- UserDefaults for actions
- Keychain for API keys

### Backend

- Firestore for persistent storage
- Transactions for atomic operations
- Environment variables for secrets

---

## Extensibility

### Adding New AI Providers

Backend: Create service, add config, update transform function
Client: Update UI if needed

### Adding New Platforms

Implement client in new language, use same backend, implement P256 signing

### Adding New Features

- Client-only: Update spellify-mac/
- Backend-only: Update spellify-api/
- Both: Update both projects

---

## Testing Strategy

### macOS Client

- Unit Tests: Managers, Services
- Manual Tests: UI, Accessibility
- Test Environment: Firebase emulators

### Backend

- Local Testing: Firebase emulators
- Integration Tests: Real Firestore (staging)
- Manual Tests: curl, Postman
- Monitoring: Firebase Console

---

## Deployment

### macOS Client

1. Build in Xcode (Archive)
2. Notarize with Apple
3. Distribute via GitHub releases

### Backend

1. firebase deploy
2. Update client with Firebase URL
3. Monitor Firebase Console

---

## Cost Considerations

For 1,000 users with 5 calls/day:
- Firebase: ~$1.14/month
- OpenAI: ~$1.69/month
- Total: ~$2.83/month ($0.003/user/month)

---

## Performance

- Cold Start: 2-3s
- Warm Request: 1-2s
- Signature Verification: <10ms
- Rate Limit Check: ~50ms
- Quota Check: ~50ms

---

## Related Documentation

- BEST_PRACTICES.md - Code conventions
- FEATURES.md - Feature specifications
- DEVELOPMENT.md - Development setup
- MONOREPO.md - Monorepo structure guide
- ../spellify-mac/README.md - Mac app docs
- ../spellify-api/README.md - Backend docs
