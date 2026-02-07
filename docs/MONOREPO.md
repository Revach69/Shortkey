# Shortkey Monorepo Guide

This guide explains the monorepo structure and how to work with multiple projects in one repository.

---

## What is a Monorepo?

A **monorepo** (monolithic repository) is a single repository that contains multiple related projects. Shortkey uses this structure to keep the macOS client and Firebase backend together while maintaining clear separation.

---

## Repository Structure

```
shortkey/                           # Repository root
│
├── .cursorrules                    # General monorepo rules
├── .gitignore                      # Root gitignore
├── README.md                       # Monorepo overview (start here!)
├── LICENSE                         # MIT License
│
├── docs/                           # Shared documentation
│   ├── README.md                   # Documentation index
│   ├── ARCHITECTURE.md             # Full system architecture
│   ├── FEATURES.md                 # Feature specifications
│   ├── DEVELOPMENT.md              # Development guide
│   ├── BEST_PRACTICES.md           # Code conventions
│   └── MONOREPO.md                 # This file
│
├── shortkey-mac/                   # macOS Client Project
│   ├── .cursorrules                # Swift/SwiftUI specific rules
│   ├── README.md                   # Mac app documentation
│   ├── Shortkey/                   # Source code
│   │   ├── ShortkeyApp.swift
│   │   ├── AppDelegate.swift
│   │   ├── Models/
│   │   ├── Views/
│   │   ├── Managers/
│   │   ├── Services/
│   │   ├── Utilities/
│   │   └── Resources/
│   ├── Shortkey.xcodeproj/         # Xcode project
│   └── ShortkeyUITests/
│
└── shortkey-api/                   # Firebase Backend Project
    ├── .cursorrules                # TypeScript/Firebase specific rules
    ├── .gitignore                  # API-specific ignores
    ├── README.md                   # Backend documentation
    ├── firebase.json               # Firebase config
    ├── firestore.rules             # Security rules
    ├── functions/                  # Cloud Functions
    │   ├── package.json
    │   ├── tsconfig.json
    │   └── src/
    │       ├── index.ts
    │       ├── types.ts
    │       ├── config.ts
    │       ├── validation.ts
    │       ├── crypto.ts
    │       └── services/
    ├── IMPLEMENTATION_COMPLETE.md  # Implementation notes
    └── NEXT_STEPS.md               # Manual setup steps
```

---

## Why Monorepo?

### Advantages

✅ **Unified Codebase**: Client and backend in one place
✅ **Shared Documentation**: Architecture docs cover both projects
✅ **Atomic Changes**: Update both client and backend in one commit
✅ **Single Source of Truth**: One repo to clone, one place for issues
✅ **Easier Refactoring**: See full impact of changes across projects
✅ **Consistent Tooling**: Shared CI/CD, linting, formatting

### Trade-offs

⚠️ **Larger Repository**: More files to clone
⚠️ **Different Tech Stacks**: Swift + TypeScript in one repo
⚠️ **Separate Builds**: Each project builds independently

---

## Working with the Monorepo

### Project-Specific Rules

Each project has its own `.cursorrules` file with specific conventions:

- **Root** (`/.cursorrules`): General monorepo rules
- **Mac App** (`/shortkey-mac/.cursorrules`): Swift/SwiftUI conventions
- **Backend** (`/shortkey-api/.cursorrules`): TypeScript/Firebase conventions

**Always read the project-specific rules before making changes!**

### Navigation

#### Working on Mac App

```bash
cd shortkey-mac/
open Shortkey.xcodeproj
# Follow shortkey-mac/.cursorrules
```

#### Working on Backend

```bash
cd shortkey-api/
firebase emulators:start
# Follow shortkey-api/.cursorrules
```

#### Reading Documentation

```bash
cd docs/
# Architecture, features, best practices apply to both projects
```

---

## Development Workflows

### Scenario 1: Mac App Only

**When**: Adding UI features, fixing client bugs, improving UX

**Steps**:
1. `cd shortkey-mac/`
2. Open Xcode
3. Make changes following `shortkey-mac/.cursorrules`
4. Test with production backend (default)
5. Commit changes

**No backend setup needed!**

### Scenario 2: Backend Only

**When**: Adding AI providers, changing quota logic, improving security

**Steps**:
1. `cd shortkey-api/`
2. Start emulators: `firebase emulators:start`
3. Make changes following `shortkey-api/.cursorrules`
4. Test with curl/Postman
5. Deploy: `firebase deploy`
6. Commit changes

**No Xcode needed!**

### Scenario 3: Full Stack (Both)

**When**: Adding features that require both client and backend changes

**Steps**:
1. Start backend emulators:
   ```bash
   cd shortkey-api/
   firebase emulators:start
   ```

2. Update client to use local backend:
   ```swift
   // In FirebaseBackendManager.swift
   private let baseURL = "http://localhost:5001/PROJECT/us-central1"
   ```

3. Open Mac app in Xcode:
   ```bash
   cd ../shortkey-mac/
   open Shortkey.xcodeproj
   ```

4. Make changes to both projects

5. Test end-to-end

6. Update client to use production backend

7. Deploy backend: `firebase deploy`

8. Commit changes to both projects in one commit

---

## Git Workflow

### Branching Strategy

```bash
main                    # Production-ready code
├── feature/add-gemini  # New feature (touches both projects)
├── fix/mac-crash       # Mac app fix (shortkey-mac/ only)
└── fix/quota-bug       # Backend fix (shortkey-api/ only)
```

### Commit Messages

**Format**: `[project] description`

Examples:
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

## File Organization

### What Goes Where?

| Content | Location | Reason |
|---------|----------|--------|
| Swift code | `shortkey-mac/` | Mac app specific |
| TypeScript code | `shortkey-api/` | Backend specific |
| Architecture docs | `docs/` | Applies to both |
| Mac app README | `shortkey-mac/README.md` | App-specific setup |
| Backend README | `shortkey-api/README.md` | Backend-specific setup |
| General README | `README.md` | Monorepo overview |
| Swift rules | `shortkey-mac/.cursorrules` | Language-specific |
| TypeScript rules | `shortkey-api/.cursorrules` | Language-specific |
| General rules | `.cursorrules` | Applies to both |

---

## Common Tasks

### Cloning the Repository

```bash
git clone https://github.com/your-repo/shortkey.git
cd shortkey
```

You now have both projects!

### Running Tests

**Mac App**:
```bash
cd shortkey-mac/
xcodebuild test -scheme Shortkey -destination 'platform=macOS'
```

**Backend**:
```bash
cd shortkey-api/
firebase emulators:start
# Test with curl/Postman
```

### Deploying

**Mac App**:
1. Build in Xcode (⌘R for testing, Archive for release)
2. Notarize with Apple
3. Create GitHub release

**Backend**:
```bash
cd shortkey-api/
firebase deploy
```

### Adding Dependencies

**Mac App** (Swift Package Manager):
1. Xcode → File → Add Package Dependencies
2. Or edit `Package.swift`

**Backend** (npm):
```bash
cd shortkey-api/functions/
npm install <package>
```

---

## Best Practices

### DO ✅

- Read project-specific `.cursorrules` before making changes
- Keep commits focused (one project or both, but related)
- Update docs when changing architecture
- Test both projects if making cross-cutting changes
- Follow language-specific conventions (Swift vs TypeScript)

### DON'T ❌

- Mix unrelated changes from different projects in one commit
- Apply Swift conventions to TypeScript code (or vice versa)
- Forget to update docs when changing interfaces
- Commit without testing both projects (if both changed)
- Use global search-replace across different languages

---

## Troubleshooting

### "Which .cursorrules should I follow?"

**Check your current directory:**
- In `shortkey-mac/`? → Follow `shortkey-mac/.cursorrules`
- In `shortkey-api/`? → Follow `shortkey-api/.cursorrules`
- In root or `docs/`? → Follow `.cursorrules` (general)

### "The repo is too large to clone"

The repo should be < 50 MB. If it's larger:
- Check `.gitignore` is working
- Run `git gc` to compress
- Ensure build artifacts are ignored

### "Changes to backend don't affect Mac app"

Make sure Mac app is pointing to the correct backend URL:
- Production: `https://us-central1-PROJECT.cloudfunctions.net`
- Local: `http://localhost:5001/PROJECT/us-central1`

Update in `FirebaseBackendManager.swift`.

---

## Related Documentation

- [Main README](../README.md) - Monorepo overview
- [Architecture](ARCHITECTURE.md) - Full system design
- [Development Guide](DEVELOPMENT.md) - Setup and workflows
- [Mac App README](../shortkey-mac/README.md) - Client docs
- [Backend README](../shortkey-api/README.md) - API docs

---

## Summary

- ✅ One repo, two projects (Mac app + Backend)
- ✅ Each project has its own rules (`.cursorrules`)
- ✅ Shared docs in `docs/`
- ✅ Work on one or both projects as needed
- ✅ Use project-prefixed commit messages
- ✅ Keep code in the right place

**Questions?** Check the [docs](.) or open an issue!
