# Shortkey

> Transform text anywhere on your Mac using AI — powered by a secure backend.

[![macOS](https://img.shields.io/badge/macOS-13.0+-blue.svg)](https://www.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0+-blue.svg)](https://www.typescriptlang.org/)
[![Firebase](https://img.shields.io/badge/Firebase-Cloud%20Functions-yellow.svg)](https://firebase.google.com/)

---

## 📦 What is Shortkey?

**Shortkey** is a macOS menu bar app that lets you transform any selected text using AI, from anywhere on your Mac. Just select text, press a keyboard shortcut, choose an action, and watch your text transform instantly.

### Key Features

- 🎯 **Menu Bar App** - Always accessible, never intrusive
- ⌨️ **Global Keyboard Shortcut** - Trigger from any app (default: ⌘⇧S)
- 🎨 **Customizable Actions** - Create your own text transformation prompts
- 🔐 **Secure Backend** - Crypto-signed requests, quota management, rate limiting
- 🚀 **Native macOS Experience** - Built with SwiftUI following Apple HIG

---

## 🏗️ Monorepo Structure

This repository contains two projects:

```
shortkey/
├── shortkey-mac/          # macOS app (Swift + SwiftUI)
│   ├── Shortkey/          # Main app code
│   ├── .cursorrules       # Swift/SwiftUI guidelines
│   └── README.md          # Mac app documentation
│
├── shortkey-api/          # Firebase backend (TypeScript)
│   ├── functions/         # Cloud Functions code
│   ├── .cursorrules       # TypeScript/Firebase guidelines
│   └── README.md          # API documentation
│
└── docs/                  # Shared documentation
    ├── ARCHITECTURE.md    # System design
    ├── FEATURES.md        # Feature specifications
    ├── DEVELOPMENT.md     # Development guide
    ├── BEST_PRACTICES.md  # Code conventions
    └── MONOREPO.md        # Monorepo structure guide
```

---

## 🚀 Quick Start

### For Users

1. **Download** the latest release
2. **Install** and grant Accessibility permissions
3. **Launch** Shortkey from Applications
4. **Use** the default keyboard shortcut (⌘⇧S) to transform text

### For Developers

#### Mac App Development

```bash
cd shortkey-mac/
open Shortkey.xcodeproj
# Build and run (⌘R)
```

See [`shortkey-mac/README.md`](shortkey-mac/README.md) for details.

#### Backend Development

```bash
cd shortkey-api/
npm install
firebase emulators:start
```

See [`shortkey-api/README.md`](shortkey-api/README.md) for details.

---

## 📋 Requirements

### Mac App
- macOS 13.0 (Ventura) or later
- Xcode 15.0+ (for development)

### Backend
- Node.js 18+
- Firebase CLI
- Firebase project
- OpenAI API key

---

## 🎯 How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                     User selects text                       │
│                     Presses ⌘⇧S                            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                 Action Picker Appears                       │
│          (Fix Grammar, Translate, Custom...)                │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│              Mac App (shortkey-mac/)                        │
│  - Signs request with device private key (P256)            │
│  - Sends to Firebase backend                               │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│           Firebase Backend (shortkey-api/)                  │
│  - Verifies signature (prevents spoofing)                  │
│  - Checks rate limit (10/min)                              │
│  - Checks quota (10/day free, 1000/day pro)                │
│  - Calls OpenAI API                                         │
│  - Returns transformed text                                 │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│              Selected text is replaced                      │
│              Notification: "Done!"                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔒 Security

- **Crypto Signing**: P256 signatures prevent device ID spoofing
- **Rate Limiting**: 10 requests/minute per device
- **Quota Management**: 10/day free, 1000/day pro
- **Keychain Storage**: API keys stored securely
- **Server-only Firestore**: Direct client access blocked

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Architecture](docs/ARCHITECTURE.md) | System design and data flow |
| [Features](docs/FEATURES.md) | Feature specifications |
| [Development](docs/DEVELOPMENT.md) | Development setup and workflow |
| [Best Practices](docs/BEST_PRACTICES.md) | Code conventions and patterns |
| [Monorepo Guide](docs/MONOREPO.md) | Working with the monorepo |
| [Mac App README](shortkey-mac/README.md) | Mac app specific docs |
| [API README](shortkey-api/README.md) | Backend API specific docs |

---

## 🛠️ Tech Stack

### Mac App (`shortkey-mac/`)
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM with Managers/Services
- **Storage**: UserDefaults (actions), Keychain (API keys)
- **System Integration**: Accessibility API, CGEvent, NSStatusItem

### Backend (`shortkey-api/`)
- **Language**: TypeScript
- **Platform**: Firebase Cloud Functions (Node.js 18)
- **Database**: Firestore
- **AI Provider**: OpenAI (gpt-4o-mini)
- **Security**: P256 signature verification

---

## 📊 Project Stats

| Metric | Mac App | Backend | Total |
|--------|---------|---------|-------|
| **Language** | Swift | TypeScript | — |
| **Lines of Code** | ~3,000 | ~300 | ~3,300 |
| **Files** | ~60 | ~9 | ~69 |
| **Tests** | ✓ | Manual | — |

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Follow project-specific `.cursorrules`
4. Write tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

See [DEVELOPMENT.md](docs/DEVELOPMENT.md) for detailed guidelines.

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Built with [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- Powered by [OpenAI](https://openai.com/)
- Backend on [Firebase](https://firebase.google.com/)

---

**Questions?** Check the [docs](docs/) or open an issue!
