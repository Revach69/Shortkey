# Configuring Cursor for Spellify
**How to make Cursor follow your code style and best practices**

---

## 🎯 Simple Approach: Reference the Docs!

We use a **single source of truth** approach:
- All rules are in `docs/BEST_PRACTICES.md`
- `.cursorrules` just points to the docs
- No duplication = Easy to maintain

---

## How It Works

### 1. `.cursorrules` File
**Location:** `.cursorrules` (project root)

**What it does:**
- Points Cursor to read your documentation
- Lists core rules (localization, file size)
- Provides quick examples
- Shows anti-patterns to avoid

### 2. Documentation Files (Source of Truth)
- `docs/BEST_PRACTICES.md` - Complete code style guide
- `docs/ARCHITECTURE.md` - System design
- `docs/FEATURES.md` - Feature specs
- `docs/DEVELOPMENT.md` - Development workflow

---

## 🚀 How to Use Cursor

### Perfect Prompts:

```
"Follow docs/BEST_PRACTICES.md and create a new component for X"

"Read docs/BEST_PRACTICES.md and refactor this file to be smaller"

"Check docs/ARCHITECTURE.md and add a new manager for Y"

"Follow the patterns in docs/ and add localization for these strings"
```

### Even Better - Reference Existing Code:

```
"Create a component like @ActionIconPicker.swift, 
 following docs/BEST_PRACTICES.md"

"Refactor this like we did with @ActionEditorSheet.swift"

"Follow the pattern in @AIProviderManager.swift"
```

---

## 📋 Common Prompts

| Goal | Perfect Prompt |
|------|----------------|
| **New component** | "Follow docs/BEST_PRACTICES.md and create a [name] component" |
| **Refactor** | "Per docs/BEST_PRACTICES.md, break this into small components" |
| **Add feature** | "Check docs/ARCHITECTURE.md and docs/FEATURES.md, then add X" |
| **Fix style** | "Review against docs/BEST_PRACTICES.md and fix" |
| **Localize** | "Add to Strings.swift per docs/BEST_PRACTICES.md" |

---

## 🎓 Teaching Cursor

### Start Every Chat Session:
```
"For this entire conversation:
1. Always read docs/BEST_PRACTICES.md before making changes
2. Never use hardcoded strings
3. Keep components < 150 lines
4. Follow existing patterns in the codebase"
```

### Correct Mistakes:
```
You: "Add a save button"
Cursor: Text("Save")
You: "No! Read docs/BEST_PRACTICES.md - we never use hardcoded strings. 
     Use Strings.swift instead."
```

---

## 🔄 Workflow

### When Starting Work:
1. **Set context:** "I'm working on Spellify. Always follow docs/BEST_PRACTICES.md"
2. **Be specific:** Reference exact docs and patterns
3. **Show examples:** Point to similar code with @mentions

### When Creating Components:
```
"Create a new component for [feature].

Follow:
- docs/BEST_PRACTICES.md (file size, structure)
- Pattern from @ActionIconPicker.swift
- Localization from @Strings.swift

Requirements:
- < 150 lines
- SwiftUI preview
- No hardcoded strings"
```

### When Refactoring:
```
"This file is too large (300 lines).

Per docs/BEST_PRACTICES.md:
- Break into small components (< 150 lines each)
- Create a new folder if needed
- Follow pattern from Views/Sheets/ActionEditor/

Keep the main file as a coordinator only."
```

---

## 💡 Pro Tips

### ✅ DO:
- **Reference docs explicitly:** "Follow docs/BEST_PRACTICES.md"
- **Use @mentions:** "@docs/BEST_PRACTICES.md says..."
- **Show examples:** "Like @ActionEditorSheet.swift"
- **Correct immediately:** Don't let bad patterns slip
- **Update docs:** Keep docs as your source of truth

### ❌ DON'T:
- Don't assume Cursor remembers rules
- Don't accept hardcoded strings
- Don't accept large files
- Don't let patterns diverge from docs

---

## 📚 Documentation Structure

Your project has comprehensive docs:

```
docs/
├── BEST_PRACTICES.md       ⭐ Main code style guide
├── ARCHITECTURE.md         ⭐ System design
├── FEATURES.md             ⭐ Feature specs  
├── DEVELOPMENT.md          ⭐ Dev workflow
└── CURSOR_CONFIGURATION.md ← This file
```

---

## 🎯 Example Conversation

```
You: "I need to add a feature for managing custom AI providers"

Me: "I'll follow docs/BEST_PRACTICES.md and docs/ARCHITECTURE.md.
     
     Based on the docs and existing patterns like AIProviderManager.swift,
     I'll create:
     
     1. CustomProviderManager.swift (< 150 lines)
     2. Views/Settings/Components/CustomProviderRow.swift (< 100 lines)
     3. Add strings to Strings.swift
     4. Add constants to Constants.swift
     
     Each component will:
     - Follow SOLID principles
     - Use localization
     - Include SwiftUI previews
     - Have clear documentation
     
     Sound good?"
```

---

## 🔍 Troubleshooting

### If Cursor Ignores Rules:

1. **Be explicit:**
   ```
   "Stop. Read docs/BEST_PRACTICES.md first, then try again."
   ```

2. **Quote the docs:**
   ```
   "According to docs/BEST_PRACTICES.md section 2.1, 
    we should..."
   ```

3. **Show example:**
   ```
   "No, look at @ActionIconPicker.swift - that's the pattern."
   ```

### If You Need to Update Rules:

1. **Update the docs** (e.g., `docs/BEST_PRACTICES.md`)
2. **That's it!** No need to update multiple places
3. **Tell Cursor:** "Check the updated docs/BEST_PRACTICES.md"

---

## 📖 Quick Reference

| When You Need... | Do This... |
|------------------|------------|
| Code style rules | Read `docs/BEST_PRACTICES.md` |
| Architecture info | Read `docs/ARCHITECTURE.md` |
| Feature specs | Read `docs/FEATURES.md` |
| Dev workflow | Read `docs/DEVELOPMENT.md` |
| Cursor setup | Read this file |

---

## 🎬 Try It Now!

Ask me:
```
"Follow docs/BEST_PRACTICES.md and create a small component 
for displaying a loading spinner"
```

And I'll create it following all your documented patterns!

---

## ✨ Benefits of This Approach

1. **Single Source of Truth** - Docs are the authority
2. **No Duplication** - Rules written once
3. **Easy Maintenance** - Update docs, not multiple files
4. **Better Learning** - Cursor reads comprehensive docs
5. **Consistency** - Everyone follows the same docs

---

**Remember: Docs are law. Reference them explicitly in every prompt!** 📚✨
