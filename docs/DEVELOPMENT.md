# Development Guide - Monorepo

> **Note**: This is the general development guide for the Shortkey monorepo.  
> For project-specific guides, see:
> - [Mac App Development](../shortkey-mac/docs/DEVELOPMENT.md)
> - [Backend Development](../shortkey-api/docs/DEVELOPMENT.md)

---

## Quick Start

### Clone the Repository

```bash
git clone https://github.com/your-repo/shortkey.git
cd shortkey
```

###Choose Your Path

**Working on Mac App only?**
```bash
cd shortkey-mac/
open Shortkey.xcodeproj
# See shortkey-mac/docs/DEVELOPMENT.md
```

**Working on Backend only?**
```bash
cd shortkey-api/
firebase emulators:start
# See shortkey-api/docs/DEVELOPMENT.md
```

**Working on both?**
- See [shortkey-mac/docs/DEVELOPMENT.md](../shortkey-mac/docs/DEVELOPMENT.md) for Mac setup
- See [shortkey-api/docs/DEVELOPMENT.md](../shortkey-api/docs/DEVELOPMENT.md) for backend setup

---

## Project Structure

```
shortkey/                          # Monorepo root
├── docs/                          # General documentation
│   ├── README.md                  # Documentation index
│   ├── MONOREPO.md                # Monorepo guide
│   ├── ARCHITECTURE.md            # System architecture
│   ├── BEST_PRACTICES.md          # General principles
│   └── DEVELOPMENT.md             # This file
│
├── shortkey-mac/                  # macOS Client
│   ├── Shortkey/                  # Source code
│   ├── docs/                      # Mac-specific docs
│   └── README.md                  # Mac app overview
│
└── shortkey-api/                  # Firebase Backend
    ├── functions/                 # Cloud Functions
    ├── docs/                      # Backend-specific docs
    └── README.md                  # Backend overview
```

See [MONOREPO.md](MONOREPO.md) for detailed structure explanation.

---

## Development Workflows

### Scenario 1: Mac App Only

**When**: Adding UI features, fixing client bugs

**Steps**:
1. `cd shortkey-mac/`
2. Open Xcode
3. Make changes
4. Test with production backend
5. Commit

**No backend setup needed!**

### Scenario 2: Backend Only

**When**: Adding AI providers, changing quota logic

**Steps**:
1. `cd shortkey-api/`
2. Start emulators: `firebase emulators:start`
3. Make changes
4. Test with curl/Postman
5. Deploy: `firebase deploy`
6. Commit

**No Xcode needed!**

### Scenario 3: Full Stack (Both)

**When**: Features requiring both client and backend changes

**Steps**:
1. Start backend emulators (Terminal 1):
   ```bash
   cd shortkey-api/
   firebase emulators:start
   ```

2. Update client to use local backend:
   ```swift
   // NetworkConstants.swift
   static let backendBaseURL = "http://localhost:5001/PROJECT/us-central1"
   ```

3. Open Mac app in Xcode (Terminal 2):
   ```bash
   cd shortkey-mac/
   open Shortkey.xcodeproj
   ```

4. Make changes to both projects

5. Test end-to-end

6. Revert to production backend URL

7. Deploy backend: `firebase deploy`

8. Commit both changes

---

## Git Workflow

### Branching Strategy

```
main                    # Production-ready code
├── feature/add-gemini  # New feature (both projects)
├── fix/mac-crash       # Mac app fix (shortkey-mac/ only)
└── fix/quota-bug       # Backend fix (shortkey-api/ only)
```

### Commit Messages

**Format**: `[project] description`

**Examples**:
- `[mac] Add dark mode support`
- `[api] Fix quota reset bug`
- `[both] Add Gemini AI provider`
- `[docs] Update architecture guide`

### Example Workflow

```bash
# Create feature branch
git checkout -b feature/add-new-action

# Make changes to Mac app
cd shortkey-mac/
# ... edit files ...
git add Shortkey/
git commit -m "[mac] Add summarize action"

# Make changes to docs
cd ../docs/
# ... edit FEATURES.md ...
git add FEATURES.md
git commit -m "[docs] Document summarize action"

# Push and create PR
git push origin feature/add-new-action
```

---

## Contributing

### Before Starting

1. Read [MONOREPO.md](MONOREPO.md) to understand structure
2. Read project-specific `.cursorrules`
3. Check [BEST_PRACTICES.md](BEST_PRACTICES.md) for patterns
4. Look at similar existing code

### Code Review Checklist

**General:**
- [ ] Follows SOLID principles
- [ ] Small, focused files (< 150 lines for Mac, < 100 for backend)
- [ ] Comments explain WHY not WHAT
- [ ] Tests added/updated (if applicable)
- [ ] Documentation updated

**Mac App:**
- [ ] No hardcoded strings (use `Strings.swift`)
- [ ] No magic numbers (use `Constants.swift`)
- [ ] SwiftUI previews added
- [ ] Follows `.cursorrules` conventions

**Backend:**
- [ ] All inputs validated
- [ ] Proper error handling (HttpsError)
- [ ] Transactions for atomic operations
- [ ] Uses `functions.logger` not `console.log`
- [ ] Follows `.cursorrules` conventions

---

## Testing

### Mac App

```bash
cd shortkey-mac/
xcodebuild test -scheme Shortkey -destination 'platform=macOS'
```

See [shortkey-mac/docs/DEVELOPMENT.md](../shortkey-mac/docs/DEVELOPMENT.md) for details.

### Backend

```bash
cd shortkey-api/
firebase emulators:start
# Test with curl/Postman
```

See [shortkey-api/docs/DEVELOPMENT.md](../shortkey-api/docs/DEVELOPMENT.md) for details.

---

## Troubleshooting

### "Which .cursorrules should I follow?"

- In `shortkey-mac/`? → Follow `shortkey-mac/.cursorrules`
- In `shortkey-api/`? → Follow `shortkey-api/.cursorrules`
- In root or `docs/`? → Follow `.cursorrules` (general)

### "Changes to backend don't affect Mac app"

Check backend URL in `NetworkConstants.swift`:
- **Production**: `https://us-central1-PROJECT.cloudfunctions.net`
- **Local**: `http://localhost:5001/PROJECT/us-central1`

### "Can't find documentation"

All docs are indexed in [docs/README.md](README.md).

---

## Related Documentation

- [Monorepo Guide](MONOREPO.md) - Working with the monorepo
- [Architecture](ARCHITECTURE.md) - System design
- [Best Practices](BEST_PRACTICES.md) - Code conventions
- [Mac App Development](../shortkey-mac/docs/DEVELOPMENT.md) - Detailed Mac setup
- [Backend Development](../shortkey-api/docs/DEVELOPMENT.md) - Detailed backend setup
