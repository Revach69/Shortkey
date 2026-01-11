# Spellify - Developer Getting Started Guide

This guide covers everything you need to know to build, run, and deploy Spellify.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Tech Stack](#tech-stack)
3. [Repository Structure](#repository-structure)
4. [Prerequisites](#prerequisites)
5. [Running the macOS App Locally](#running-the-macos-app-locally)
6. [Running the Backend Locally](#running-the-backend-locally)
7. [Building for Release](#building-for-release)
8. [App Store Submission](#app-store-submission)
9. [Backend Deployment](#backend-deployment)
10. [Environment Variables & Secrets](#environment-variables--secrets)
11. [Troubleshooting](#troubleshooting)

---

## Project Overview

Spellify is a **macOS menu bar application** that transforms selected text using AI. The project is a **monorepo** containing:

| Folder | Description |
|--------|-------------|
| `spellify-mac/` | Native macOS app (Swift + SwiftUI) |
| `spellify-api/` | Serverless backend (TypeScript + Firebase) |
| `docs/` | Shared documentation |

---

## Tech Stack

### macOS App
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Minimum OS**: macOS 13.0 (Ventura)
- **IDE**: Xcode 15.0+
- **Key Frameworks**: AppKit, CryptoKit, StoreKit 2

### Backend
- **Language**: TypeScript
- **Runtime**: Node.js 22
- **Platform**: Firebase Cloud Functions v2
- **Database**: Firestore
- **AI**: OpenAI (gpt-4o-mini)

---

## Repository Structure

```
spellify/
├── spellify-mac/                 # macOS Application
│   ├── Spellify/                 # Source code
│   │   ├── SpellifyApp.swift     # App entry point
│   │   ├── AppDelegate.swift     # Menu bar setup
│   │   ├── Managers/             # Business logic
│   │   ├── Services/             # System integration
│   │   ├── Views/                # SwiftUI views
│   │   └── Utilities/            # Helpers & constants
│   ├── Spellify.xcodeproj        # Xcode project
│   └── SpellifyTests/            # Unit tests
│
├── spellify-api/                 # Firebase Backend
│   ├── functions/
│   │   ├── src/
│   │   │   ├── index.ts          # Cloud Function exports
│   │   │   ├── handlers/         # Request handlers
│   │   │   └── services/         # Business logic
│   │   └── package.json
│   ├── firebase.json             # Firebase config
│   └── firestore.rules           # Security rules
│
└── docs/                         # Documentation
    ├── ARCHITECTURE.md
    ├── DEVELOPMENT.md
    └── ...
```

---

## Prerequisites

### For macOS App Development

| Requirement | Version |
|-------------|---------|
| macOS | 13.0+ (Ventura or later) |
| Xcode | 15.0+ |
| Apple Developer Account | Required for distribution |

### For Backend Development

| Requirement | Version |
|-------------|---------|
| Node.js | 22+ |
| npm | Latest |
| Firebase CLI | Latest |

Install Firebase CLI:
```bash
npm install -g firebase-tools
firebase login
```

---

## Running the macOS App Locally

### Step 1: Open the Project
```bash
cd spellify-mac
open Spellify.xcodeproj
```

### Step 2: Configure Signing (First Time Only)
1. In Xcode, select the **Spellify** target
2. Go to **Signing & Capabilities**
3. Select your **Team** (Apple Developer account)
4. Xcode will automatically manage signing

### Step 3: Build & Run
- Press `Cmd + R` or click the **Play** button
- The app will appear in your **menu bar** (wand icon)
- Grant **Accessibility permissions** when prompted (required for hotkeys)

### Step 4: Grant Accessibility Access
1. System Settings → Privacy & Security → Accessibility
2. Enable Spellify
3. Restart the app if needed

### Testing Locally
The app connects to the production Firebase backend by default. For local backend testing, see the next section.

---

## Running the Backend Locally

### Step 1: Install Dependencies
```bash
cd spellify-api/functions
npm install
```

### Step 2: Set Up Firebase Emulators
```bash
# From spellify-api/ directory
firebase emulators:start --only functions,firestore
```

This starts:
- **Functions**: http://localhost:5001
- **Firestore**: http://localhost:8080
- **Emulator UI**: http://localhost:4000

### Step 3: Configure the App to Use Local Backend
In `spellify-mac/Spellify/Utilities/Constants/NetworkConstants.swift`, temporarily change the base URL:
```swift
// Change from production:
static let baseURL = "https://us-central1-spellify-app.cloudfunctions.net"

// To local:
static let baseURL = "http://localhost:5001/spellify-app/us-central1"
```

> **Important**: Don't commit this change!

### Step 4: Set OpenAI API Key for Local Testing
```bash
export OPENAI_API_KEY="your-api-key-here"
```

Or create a `.env` file in `spellify-api/functions/`.

---

## Building for Release

### Building the macOS App

#### Option 1: Archive in Xcode (Recommended)
1. In Xcode: **Product → Archive**
2. Wait for the build to complete
3. The **Organizer** window opens with your archive

#### Option 2: Command Line
```bash
cd spellify-mac

# Build
xcodebuild build \
  -scheme Spellify \
  -configuration Release \
  -destination 'platform=macOS'

# Archive
xcodebuild archive \
  -scheme Spellify \
  -configuration Release \
  -archivePath ./build/Spellify.xcarchive
```

### Notarization (Required for Distribution)

Apple requires notarization for apps distributed outside the App Store.

#### Step 1: Export the App
1. In Xcode Organizer, select your archive
2. Click **Distribute App**
3. Choose **Developer ID** (for direct distribution) or **App Store Connect**
4. Follow the prompts

#### Step 2: Notarize via Command Line (Alternative)
```bash
# Submit for notarization
xcrun notarytool submit Spellify.zip \
  --apple-id "your@email.com" \
  --team-id "YOUR_TEAM_ID" \
  --password "app-specific-password" \
  --wait

# Staple the notarization ticket
xcrun stapler staple Spellify.app
```

---

## App Store Submission

### Prerequisites Checklist

- [ ] Apple Developer Program membership ($99/year)
- [ ] App record created in App Store Connect
- [ ] Bundle ID registered: `app.spellify.mac`
- [ ] App icon in all required sizes
- [ ] Screenshots prepared (required sizes for macOS)
- [ ] Privacy policy URL
- [ ] App description and metadata

### Step-by-Step Submission

#### 1. Prepare in App Store Connect
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Create a new app (if not already created)
3. Fill in app metadata, descriptions, keywords
4. Upload screenshots

#### 2. Configure Version & Build Number
In `Info.plist` or Xcode target settings:
- **CFBundleShortVersionString**: Version (e.g., "1.0.0")
- **CFBundleVersion**: Build number (increment for each upload)

#### 3. Archive and Upload
1. **Product → Archive** in Xcode
2. In Organizer, click **Distribute App**
3. Select **App Store Connect**
4. Choose **Upload**
5. Follow the prompts

#### 4. Submit for Review
1. In App Store Connect, select your build
2. Answer export compliance questions
3. Submit for review

### App Review Considerations

Spellify requires:
- **Accessibility permissions** - Explain in App Review notes why this is needed
- **Network access** - The app connects to Firebase backend
- **In-App Purchases** - StoreKit 2 subscription configured

#### App Review Notes Template
```
This app is a menu bar utility that transforms selected text using AI.

Accessibility permissions are required to:
1. Register global keyboard shortcuts
2. Read selected text from any application
3. Paste transformed text back

The app does not collect or transmit any personal data beyond
the text being transformed for AI processing.
```

### Entitlements for App Store

Current entitlements in `Spellify.entitlements`:
```xml
<key>com.apple.security.app-sandbox</key>
<false/>
<key>com.apple.security.network.client</key>
<true/>
```

> **Note**: App Sandbox is disabled because accessibility features require it. You'll need to explain this in your App Review submission.

---

## Backend Deployment

### Deploy to Firebase

```bash
cd spellify-api

# Deploy everything (functions + Firestore rules)
firebase deploy

# Deploy only functions
firebase deploy --only functions

# Deploy only Firestore rules
firebase deploy --only firestore:rules
```

### First-Time Setup

1. **Create Firebase Project**
   ```bash
   firebase projects:create spellify-app
   ```

2. **Enable Firestore**
   - Go to Firebase Console → Firestore → Create Database
   - Select region (nam7 for North America)

3. **Set OpenAI API Key**
   ```bash
   firebase functions:secrets:set OPENAI_API_KEY
   # Paste your OpenAI API key when prompted
   ```

4. **Deploy**
   ```bash
   firebase deploy
   ```

### Verify Deployment
```bash
# Check function logs
firebase functions:log

# Test the endpoint
curl -X POST https://us-central1-spellify-app.cloudfunctions.net/registerDevice \
  -H "Content-Type: application/json" \
  -d '{"data": {"deviceId": "test", "publicKey": "test"}}'
```

---

## Environment Variables & Secrets

### Backend Secrets (Firebase)

| Secret | Description |
|--------|-------------|
| `OPENAI_API_KEY` | OpenAI API key for text transformation |

Set secrets:
```bash
firebase functions:secrets:set OPENAI_API_KEY
```

View secrets:
```bash
firebase functions:secrets:access OPENAI_API_KEY
```

### macOS App Configuration

Key configuration files:
- `NetworkConstants.swift` - Backend URL
- `BusinessRulesConstants.swift` - Quotas, limits
- `AppConstants.swift` - App-wide settings

---

## Troubleshooting

### macOS App Issues

#### "Spellify needs Accessibility permissions"
1. System Settings → Privacy & Security → Accessibility
2. Click the lock to make changes
3. Add/enable Spellify
4. Restart the app

#### Hotkey not working
- Check if another app is using the same shortcut
- Default: `Cmd + Shift + S`
- Can be changed in app settings

#### App doesn't appear in menu bar
- The app is designed to run only in the menu bar (no dock icon)
- Look for the wand icon in the menu bar

### Backend Issues

#### "Permission denied" errors
- Check Firestore rules are deployed
- Verify device is registered
- Check signature validation

#### OpenAI errors
- Verify API key is set: `firebase functions:secrets:access OPENAI_API_KEY`
- Check OpenAI account has credits
- Review function logs: `firebase functions:log`

#### Emulator issues
```bash
# Kill any stuck emulators
lsof -ti:5001 | xargs kill -9
lsof -ti:8080 | xargs kill -9

# Restart
firebase emulators:start
```

### Build Issues

#### "Signing requires a development team"
- Open Xcode → Spellify target → Signing & Capabilities
- Select your team

#### "Cannot find CryptoKit"
- Ensure deployment target is macOS 13.0+
- Clean build folder: `Cmd + Shift + K`

---

## Quick Reference Commands

```bash
# === macOS App ===
cd spellify-mac
open Spellify.xcodeproj          # Open in Xcode
xcodebuild build -scheme Spellify # Build from CLI
xcodebuild test -scheme Spellify  # Run tests

# === Backend ===
cd spellify-api
npm install                       # Install dependencies
firebase emulators:start          # Local development
firebase deploy                   # Deploy to production
firebase functions:log            # View logs

# === Useful ===
firebase login                    # Authenticate
firebase projects:list            # List projects
```

---

## Additional Resources

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - System design
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) - Development workflow
- [docs/BEST_PRACTICES.md](docs/BEST_PRACTICES.md) - Code conventions
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Firebase Documentation](https://firebase.google.com/docs)
