# Spellify Documentation

Welcome to the Spellify documentation! This is your **central index** for all documentation across the monorepo.

---

## 📖 Start Here

New to Spellify? Read these in order:

1. **[Main README](../README.md)** - Project overview and quick start
2. **[MONOREPO.md](MONOREPO.md)** - Understanding the repository structure  
3. **[ARCHITECTURE.md](ARCHITECTURE.md)** - System design and data flow
4. **[DEVELOPMENT.md](DEVELOPMENT.md)** - Setting up your dev environment

---

## 📚 Documentation Structure

### Root `docs/` - General Documentation

| Document | Description | Audience |
|----------|-------------|----------|
| **[README.md](README.md)** | This file - documentation index | Everyone |
| **[MONOREPO.md](MONOREPO.md)** | Monorepo structure and workflows | All developers |
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | Full system architecture (client + backend) | Developers, architects |
| **[BEST_PRACTICES.md](BEST_PRACTICES.md)** | General architectural principles (SOLID, etc.) | All developers |
| **[DEVELOPMENT.md](DEVELOPMENT.md)** | General development guide | All developers |

### `spellify-mac/docs/` - macOS Client Documentation

| Document | Description | Audience |
|----------|-------------|----------|
| **[README](../spellify-mac/README.md)** | Mac app overview | Mac developers |
| **[BEST_PRACTICES.md](../spellify-mac/docs/BEST_PRACTICES.md)** | Swift/SwiftUI best practices | Mac developers |
| **[DEVELOPMENT.md](../spellify-mac/docs/DEVELOPMENT.md)** | Mac app development guide | Mac developers |
| **[FEATURES.md](../spellify-mac/docs/FEATURES.md)** | Feature specifications | Mac developers, PMs |

### `spellify-api/docs/` - Backend Documentation

| Document | Description | Audience |
|----------|-------------|----------|
| **[README](../spellify-api/README.md)** | Backend overview | Backend developers |
| **[BEST_PRACTICES.md](../spellify-api/docs/BEST_PRACTICES.md)** | TypeScript/Firebase best practices | Backend developers |
| **[DEVELOPMENT.md](../spellify-api/docs/DEVELOPMENT.md)** | Backend development guide | Backend developers |
| **[API_DESIGN.md](../spellify-api/docs/API_DESIGN.md)** | API endpoints specification | Backend developers, Mac developers |

---

## 🎯 Quick Navigation

### I want to...

**...get started with the project**  
→ Read [Main README](../README.md) → [MONOREPO.md](MONOREPO.md)

**...understand the system architecture**  
→ Read [ARCHITECTURE.md](ARCHITECTURE.md)

**...start developing the Mac app**  
→ Read [spellify-mac/docs/DEVELOPMENT.md](../spellify-mac/docs/DEVELOPMENT.md)

**...start developing the backend**  
→ Read [spellify-api/docs/DEVELOPMENT.md](../spellify-api/docs/DEVELOPMENT.md)

**...understand the monorepo structure**  
→ Read [MONOREPO.md](MONOREPO.md)

**...see what features exist**  
→ Read [spellify-mac/docs/FEATURES.md](../spellify-mac/docs/FEATURES.md)

**...follow code conventions**  
- General: [BEST_PRACTICES.md](BEST_PRACTICES.md)
- Mac: [spellify-mac/docs/BEST_PRACTICES.md](../spellify-mac/docs/BEST_PRACTICES.md)
- Backend: [spellify-api/docs/BEST_PRACTICES.md](../spellify-api/docs/BEST_PRACTICES.md)

**...understand the API**  
→ Read [spellify-api/docs/API_DESIGN.md](../spellify-api/docs/API_DESIGN.md)

---

## 📋 Documentation by Topic

### Architecture & Design

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Two-tier architecture, data flow, security
- **[MONOREPO.md](MONOREPO.md)** - Repository structure, workflows
- **[spellify-api/docs/API_DESIGN.md](../spellify-api/docs/API_DESIGN.md)** - API endpoints, request/response formats

### Best Practices & Conventions

- **[BEST_PRACTICES.md](BEST_PRACTICES.md)** - SOLID principles, architectural patterns
- **[spellify-mac/docs/BEST_PRACTICES.md](../spellify-mac/docs/BEST_PRACTICES.md)** - Swift/SwiftUI patterns
- **[spellify-api/docs/BEST_PRACTICES.md](../spellify-api/docs/BEST_PRACTICES.md)** - TypeScript/Firebase patterns

### Development Guides

- **[DEVELOPMENT.md](DEVELOPMENT.md)** - General monorepo development
- **[spellify-mac/docs/DEVELOPMENT.md](../spellify-mac/docs/DEVELOPMENT.md)** - Mac app setup, building, testing
- **[spellify-api/docs/DEVELOPMENT.md](../spellify-api/docs/DEVELOPMENT.md)** - Backend setup, deployment, testing

### Features & Specifications

- **[spellify-mac/docs/FEATURES.md](../spellify-mac/docs/FEATURES.md)** - Feature specifications, user flows

---

## 🗂️ Documentation Principles

### Organization

- **Root `docs/`**: General principles that apply to both projects
- **Project `docs/`**: Project-specific implementation details
- **Clear separation**: No mixing of concerns

### Writing Style

- ✅ Clear and concise
- ✅ Examples for every concept
- ✅ Links to related documentation
- ✅ Updated with code changes

### Maintenance

- Update docs **before** or **with** code changes
- Keep docs in sync with implementation
- Remove outdated information
- Add examples from real codebase

---

## 🚀 Getting Started Checklist

New developer? Follow this checklist:

### General Understanding
- [ ] Read [Main README](../README.md)
- [ ] Read [MONOREPO.md](MONOREPO.md)
- [ ] Read [ARCHITECTURE.md](ARCHITECTURE.md)
- [ ] Read [DEVELOPMENT.md](DEVELOPMENT.md)

### Choose Your Path

**Mac Developer:**
- [ ] Read [spellify-mac/README.md](../spellify-mac/README.md)
- [ ] Read [spellify-mac/docs/BEST_PRACTICES.md](../spellify-mac/docs/BEST_PRACTICES.md)
- [ ] Read [spellify-mac/docs/DEVELOPMENT.md](../spellify-mac/docs/DEVELOPMENT.md)
- [ ] Read [spellify-mac/.cursorrules](../spellify-mac/.cursorrules)
- [ ] Set up Xcode
- [ ] Run the project
- [ ] Make your first change!

**Backend Developer:**
- [ ] Read [spellify-api/README.md](../spellify-api/README.md)
- [ ] Read [spellify-api/docs/BEST_PRACTICES.md](../spellify-api/docs/BEST_PRACTICES.md)
- [ ] Read [spellify-api/docs/DEVELOPMENT.md](../spellify-api/docs/DEVELOPMENT.md)
- [ ] Read [spellify-api/docs/API_DESIGN.md](../spellify-api/docs/API_DESIGN.md)
- [ ] Read [spellify-api/.cursorrules](../spellify-api/.cursorrules)
- [ ] Set up Firebase CLI
- [ ] Run emulators
- [ ] Make your first change!

---

## ❓ Questions?

- **General questions**: Check [Main README](../README.md)
- **Architecture questions**: Check [ARCHITECTURE.md](ARCHITECTURE.md)
- **Dev setup questions**: Check [DEVELOPMENT.md](DEVELOPMENT.md) or project-specific guides
- **Code style questions**: Check [BEST_PRACTICES.md](BEST_PRACTICES.md) or project-specific guides
- **Monorepo questions**: Check [MONOREPO.md](MONOREPO.md)
- **API questions**: Check [spellify-api/docs/API_DESIGN.md](../spellify-api/docs/API_DESIGN.md)

Still stuck? Open an issue on GitHub!

---

## 📝 Contributing to Documentation

Found an error or want to improve documentation?

1. Edit the relevant Markdown file
2. Follow [Markdown best practices](https://www.markdownguide.org/basic-syntax/)
3. Use clear headings and formatting
4. Add examples where helpful
5. Update links if you move files
6. Submit a pull request

**Good documentation is code too!**

---

## 📄 License

All documentation is part of the Spellify project and is licensed under the MIT License.

---

**Happy coding!** 🚀
