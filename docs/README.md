# Spellify Documentation

Welcome to the Spellify documentation! This directory contains comprehensive guides for understanding and contributing to the Spellify project.

---

## Start Here

New to Spellify? Read these in order:

1. Main README - Project overview and quick start
2. MONOREPO.md - Understanding the repository structure
3. ARCHITECTURE.md - System design and data flow
4. DEVELOPMENT.md - Setting up your dev environment

---

## Documentation Index

### General Documentation

- MONOREPO.md - Monorepo structure and workflows
- ARCHITECTURE.md - Full system architecture (client + backend)
- FEATURES.md - Feature specifications and user flows
- DEVELOPMENT.md - Development setup and workflows
- BEST_PRACTICES.md - Code conventions and patterns

### Project-Specific Documentation

- spellify-mac/README.md - macOS client documentation
- spellify-api/README.md - Firebase backend documentation
- spellify-mac/.cursorrules - Swift/SwiftUI conventions
- spellify-api/.cursorrules - TypeScript/Firebase conventions

---

## Quick Navigation

### I want to...

understand the system → Read ARCHITECTURE.md
start developing → Read DEVELOPMENT.md
work on the Mac app → Read spellify-mac/README.md + .cursorrules
work on the backend → Read spellify-api/README.md + .cursorrules
understand the monorepo → Read MONOREPO.md
see what features exist → Read FEATURES.md
follow code conventions → Read BEST_PRACTICES.md

---

## Document Descriptions

### MONOREPO.md
Understanding the Repository Structure

Learn about:
- Why we use a monorepo
- Directory structure
- Project-specific rules
- Git workflow
- Common tasks

Read this first if you're new to the project!

### ARCHITECTURE.md
System Design and Architecture

Learn about:
- Two-tier architecture (client + backend)
- macOS client layer architecture
- Backend service architecture
- Data flow
- Security design
- State management
- Performance characteristics

Essential for understanding how everything works together.

### FEATURES.md
Feature Specifications

Learn about:
- Core features (menu bar, shortcuts, actions)
- Backend integration (crypto signing, quotas, rate limits)
- Subscription management
- User flows
- Error handling
- Settings

Great for understanding what the app does.

### DEVELOPMENT.md
Development Guide

Learn about:
- Prerequisites (macOS, Xcode, Node.js, Firebase)
- Getting started (cloning, setup, running)
- Running tests
- Development workflows
- Common tasks
- Debugging
- Contributing

Your go-to guide for day-to-day development.

### BEST_PRACTICES.md
Code Conventions and Patterns

Learn about:
- SOLID principles in practice
- SwiftUI patterns
- Async/await usage
- Testability patterns
- Apple best practices
- Error handling
- Code organization

Read this to write code that fits the project style.

---

## Project Structure

spellify/
├── docs/                  YOU ARE HERE
│   ├── README.md          This file
│   ├── MONOREPO.md        Repository structure guide
│   ├── ARCHITECTURE.md    System architecture
│   ├── FEATURES.md        Feature specs
│   ├── DEVELOPMENT.md     Dev guide
│   └── BEST_PRACTICES.md  Code conventions
├── spellify-mac/          macOS Client
│   ├── README.md          Mac app docs
│   └── .cursorrules       Swift/SwiftUI rules
└── spellify-api/          Firebase Backend
    ├── README.md          Backend docs
    └── .cursorrules       TypeScript/Firebase rules

---

## Getting Started Checklist

- Read Main README
- Read MONOREPO.md
- Read ARCHITECTURE.md
- Read DEVELOPMENT.md
- Choose your project (Mac app or Backend)
- Read project-specific README
- Read project-specific .cursorrules
- Set up dev environment
- Run the project
- Make your first change!

---

## Questions?

- General questions: Check Main README
- Architecture questions: Check ARCHITECTURE.md
- Dev setup questions: Check DEVELOPMENT.md
- Code style questions: Check BEST_PRACTICES.md
- Monorepo questions: Check MONOREPO.md

Still stuck? Open an issue on GitHub!

---

## Contributing to Docs

Found an error or want to improve the documentation?

1. Edit the relevant Markdown file
2. Follow Markdown best practices
3. Use clear headings and formatting
4. Add examples where helpful
5. Submit a pull request

Good documentation is code too!

---

## License

All documentation is part of the Spellify project and is licensed under the MIT License.
