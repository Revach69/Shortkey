# Shortkey — Implementation Agents

> Deploy Agent 0 first (rename verification). Then deploy Agents 1–6 in parallel.

---

## Agent 0: Rename Verification & Fixup

### Goal
Verify the global rename from "spellify" to "shortkey" is complete and consistent. Fix any broken references.

### Prompt
```
You are verifying a global rename from "Spellify"/"spellify" to "Shortkey"/"shortkey" across a monorepo.

1. Search the ENTIRE codebase for any remaining instances of "spellify" or "Spellify" (case insensitive). Exclude .git/ and node_modules/.
2. If you find any, replace them with the corresponding "shortkey"/"Shortkey" form.
3. Verify the following are consistent:
   - Bundle ID uses "shortkey" (check Info.plist, entitlements, Constants files)
   - Package names in package.json files use "shortkey"
   - Firebase config references use "shortkey"
   - Xcode scheme files reference "Shortkey"
   - All import statements and module names use "Shortkey"
4. Check that renamed directories exist:
   - shortkey-mac/, shortkey-api/, shortkey-web/
   - shortkey-mac/Shortkey/ (source directory)
   - shortkey-mac/ShortkeyUITests/
   - shortkey-mac/Shortkey.xcodeproj/
5. Run `cd shortkey-api/functions && npm run build` to verify TypeScript compiles.
6. Run `cd shortkey-web && npm run build` to verify Next.js builds.
7. Fix any build errors caused by the rename.
```

---

## Agent 1: Backend — Monthly Quota & 3-Tier Pricing

### Goal
Replace daily quotas with monthly caps. Implement 3 tiers: Free (50/month), Pro (2,000/month), BYOK (unlimited).

### Prompt
```
You are overhauling the quota and pricing system in a Firebase Cloud Functions backend.

CONTEXT: This is a macOS utility app backend at shortkey-api/functions/src/. It currently has 2 tiers (free: 10/day, pro: 1000/day). You are changing to 3 tiers with monthly caps.

READ THESE FILES FIRST (read ALL of them before making any changes):
- shortkey-api/functions/src/config.ts
- shortkey-api/functions/src/constants.ts
- shortkey-api/functions/src/services/quotaService.ts
- shortkey-api/functions/src/services/collections/deviceCollection.ts
- shortkey-api/functions/src/handlers/transformText/index.ts
- shortkey-api/functions/src/handlers/transformText/validation.ts
- shortkey-api/functions/src/types/ (all files)

CHANGES TO MAKE:

1. In config.ts — Replace tier configuration:
   - free:  { monthly: 50,   burst: 10, maxTextLength: 500  }
   - pro:   { monthly: 2000, burst: 10, maxTextLength: 2000 }
   - byok:  { monthly: 99999, burst: 20, maxTextLength: 5000 }

2. In types — Update the Device type:
   - Rename `dailyCount` → `monthlyCount`
   - Change `lastReset` type to string (will hold "YYYY-MM" format)
   - Add "byok" to the tier union type: `tier: "free" | "pro" | "byok"`

3. In quotaService.ts — Change reset logic from daily to monthly:
   - Get current month string: new Date().toISOString().slice(0, 7) → "2026-02"
   - If device.lastReset !== currentMonth, reset monthlyCount to 0
   - Increment monthlyCount
   - Calculate resetsAt as first day of next month (ISO 8601)
   - For byok tier: still track usage but set a very high limit (99999)
   - Update the quota response: { used: monthlyCount, limit: monthlyLimit, resetsAt }

4. In deviceCollection.ts — Update field names:
   - dailyCount → monthlyCount
   - Update any references to daily reset dates

5. In transformText handler — Update validation:
   - Use new tier maxTextLength values
   - Update error messages: "Monthly limit reached" instead of "Daily limit reached"
   - Include upgrade messaging: "Upgrade to Pro for 2,000 actions/month ($9/mo)"

6. In registerDevice handler — Set defaults for new devices:
   - monthlyCount: 0
   - lastReset: current month string
   - tier: "free"

7. Verify: Run `cd shortkey-api/functions && npm run build` — fix any TypeScript errors.

IMPORTANT: Do NOT change the signature verification, rate limiting, or OpenAI integration. Only modify quota/tier logic.
```

---

## Agent 2: Backend — Security Hardening

### Goal
Add replay protection (timestamp in signed payloads) and rate-limit the registerDevice endpoint.

### Prompt
```
You are hardening the security of a Firebase Cloud Functions backend.

CONTEXT: The backend uses P256 ECDSA signatures to authenticate requests. Currently signatures have no timestamp, meaning they're valid forever. You are adding replay protection and registration rate limiting.

READ THESE FILES FIRST:
- shortkey-api/functions/src/utils/crypto.ts
- shortkey-api/functions/src/utils/withRequestContext/withRequestContext.ts
- shortkey-api/functions/src/handlers/registerDevice/index.ts
- shortkey-api/functions/src/handlers/registerDevice/validation.ts
- shortkey-api/functions/src/services/collections/rateLimitCollection.ts
- shortkey-api/functions/src/constants.ts
- shortkey-api/functions/src/config.ts

CHANGES TO MAKE:

1. In constants.ts — Add security constants:
   - SIGNATURE_MAX_AGE_MS = 5 * 60 * 1000  (5 minutes)
   - REGISTER_RATE_LIMIT_PER_HOUR = 5
   - REGISTER_RATE_LIMIT_COLLECTION = "registrationRateLimits"

2. In crypto.ts — Add timestamp validation:
   - Add function: isTimestampValid(timestamp: number): boolean
     - Returns true if Math.abs(Date.now() - timestamp) < SIGNATURE_MAX_AGE_MS
     - Handles missing/invalid timestamps by returning false
   - The existing verifySignature function should NOT change (timestamp is just another field in the signed data object)

3. In withRequestContext.ts — Enforce timestamp:
   - Extract `timestamp` from request data (alongside deviceId and signature)
   - After signature verification succeeds, call isTimestampValid(timestamp)
   - If invalid, throw HttpsError("unauthenticated", "Request expired. Ensure your device clock is accurate.")
   - The timestamp must be INCLUDED in the signed payload (so it's covered by the signature)

4. In registerDevice — Add IP-based rate limiting:
   - Get client IP: request.rawRequest?.ip || request.rawRequest?.headers["x-forwarded-for"]
   - Create/check document in "registrationRateLimits" collection
   - Document ID: hash of IP + current hour string (e.g., "192.168.1.1_2026-02-07T14")
   - Atomic transaction: if count >= 5, throw HttpsError("resource-exhausted", "Too many registration attempts. Try again later.")
   - Set TTL (expiresAt) to 2 hours from now

5. In registerDevice/validation.ts — No changes needed.

6. Verify: Run `cd shortkey-api/functions && npm run build` — fix any TypeScript errors.

IMPORTANT:
- The macOS client will also need updating to include timestamp in signed payloads. Add a comment noting this dependency: "// NOTE: Client must include 'timestamp: Date.now()' in signed request data"
- Do NOT modify the OpenAI integration or quota system.
```

---

## Agent 3: macOS App — Anthropic Claude Provider (BYOK)

### Goal
Add Anthropic Claude as a second AI provider. Users can choose between OpenAI and Anthropic, entering their own API key for either.

### Prompt
```
You are adding Anthropic Claude support to a macOS SwiftUI application.

CONTEXT: The app has an extensible AI provider system built on an AIModelProvider protocol. Currently only OpenAI is implemented. You are adding Anthropic as a second provider for the BYOK (Bring Your Own Key) tier.

READ THESE FILES FIRST (read ALL before writing any code):
- shortkey-mac/Shortkey/Protocols/AIModelProvider.swift
- shortkey-mac/Shortkey/AIProviders/OpenAI/OpenAIProvider.swift
- shortkey-mac/Shortkey/Managers/AIProviderManager/AIProviderManager.swift
- shortkey-mac/Shortkey/Services/KeychainService.swift
- shortkey-mac/Shortkey/Utilities/Constants/AIProviderConstants.swift
- shortkey-mac/Shortkey/Models/AIModel.swift
- shortkey-mac/Shortkey/Models/ConnectionStatus.swift
- All files in shortkey-mac/Shortkey/Views/Settings/

CHANGES TO MAKE:

1. CREATE shortkey-mac/Shortkey/AIProviders/Anthropic/AnthropicProvider.swift
   - Implement AIModelProvider protocol
   - id = "anthropic", displayName = "Anthropic"
   - apiKeyURL = URL(string: "https://console.anthropic.com/settings/keys")!
   - Base URL: "https://api.anthropic.com/v1"
   - API key stored in Keychain with key: "anthropic-api-key"

   - configure(apiKey:): Store key in Keychain

   - testConnection(): POST to /v1/messages with minimal test:
     - Headers: x-api-key, anthropic-version: "2023-06-01", content-type: application/json
     - Body: { model: "claude-sonnet-4-5-20250929", max_tokens: 10, messages: [{ role: "user", content: "Hi" }] }
     - Return true if 200, throw on error

   - fetchAvailableModels(): Return hardcoded list (Anthropic has no list-models endpoint):
     - AIModel(id: "claude-sonnet-4-5-20250929", name: "Claude Sonnet 4.5", provider: "anthropic")
     - AIModel(id: "claude-haiku-4-5-20251001", name: "Claude Haiku 4.5", provider: "anthropic")

   - transform(text:description:model:): POST to /v1/messages
     - Headers: x-api-key: {key}, anthropic-version: "2023-06-01", content-type: application/json
     - Body: { model: model, max_tokens: 4096, system: description, messages: [{ role: "user", content: text }] }
     - Temperature: 0.3
     - Parse response: content[0].text
     - Handle errors: 401 → unauthorized, 400 → invalid request, etc.

2. In AIProviderConstants.swift — Add:
   - static let anthropicId = "anthropic"
   - static let anthropicDisplayName = "Anthropic"

3. In KeychainService.swift — Add:
   - static let anthropicAPIKey = "anthropic-api-key"

4. In AIProviderManager.swift — Add multi-provider support:
   - Add property: let providers: [AIModelProvider] (initialized with [OpenAIProvider(), AnthropicProvider()])
   - Add @Published var activeProviderId: String (persisted in UserDefaults)
   - Add computed property: var activeProvider: AIModelProvider
   - Add method: switchProvider(to providerId: String)
   - Update existing methods (testConnection, transform, etc.) to use activeProvider
   - On init, restore activeProviderId from UserDefaults (default: "openai")

5. In Settings views — Add provider selection:
   - Add a Picker or segmented control to switch between "OpenAI" and "Anthropic"
   - Show the appropriate API key field based on selected provider
   - Show "Get API Key" link pointing to the selected provider's apiKeyURL
   - When provider changes, update connection status

IMPORTANT:
- Follow the EXACT same patterns as OpenAIProvider.swift. Match the code style, error handling, and structure.
- Use URLSession for HTTP requests (same as OpenAI implementation).
- All API keys go in Keychain, never UserDefaults.
- The AnthropicProvider should be a class (same as OpenAIProvider), not a struct.
- Do NOT modify SpellAction, ActionsManager, or the action picker. Only the AI provider layer.
```

---

## Agent 4: macOS App — Prompt Chaining

### Goal
Allow users to create "chains" — ordered sequences of actions where each action's output feeds into the next action's input.

### Prompt
```
You are adding prompt chaining to a macOS SwiftUI application.

CONTEXT: The app transforms text using AI "actions" (each action has a name, description/prompt, and icon). Currently actions run individually. You are adding the ability to chain multiple actions together so the output of action A becomes the input of action B.

READ THESE FILES FIRST (read ALL before writing any code):
- shortkey-mac/Shortkey/Models/SpellAction.swift
- shortkey-mac/Shortkey/Managers/ActionsManager.swift
- shortkey-mac/Shortkey/Services/ShortkeyController.swift (was SpellifyController)
- shortkey-mac/Shortkey/Managers/SubscriptionManager/ (all files)
- shortkey-mac/Shortkey/Utilities/Constants/BusinessRulesConstants.swift
- shortkey-mac/Shortkey/Views/MenuBar/ (all files)
- shortkey-mac/Shortkey/Views/Sheets/ (all files)
- shortkey-mac/Shortkey/Views/ActionPicker/ (all files)
- shortkey-mac/Shortkey/Utilities/ProFeatures.swift

CHANGES TO MAKE:

1. CREATE shortkey-mac/Shortkey/Models/ActionChain.swift:
   ```swift
   struct ActionChain: Identifiable, Codable, Equatable {
       let id: UUID
       var name: String
       var icon: String  // SF Symbol name
       var steps: [ChainStep]

       init(id: UUID = UUID(), name: String, icon: String = "link", steps: [ChainStep] = []) {
           self.id = id
           self.name = name
           self.icon = icon
           self.steps = steps
       }
   }

   struct ChainStep: Identifiable, Codable, Equatable {
       let id: UUID
       var actionId: UUID  // references a SpellAction

       init(id: UUID = UUID(), actionId: UUID) {
           self.id = id
           self.actionId = actionId
       }
   }
   ```

2. In ActionsManager.swift — Add chain management:
   - Add @Published var chains: [ActionChain] = []
   - Add private let chainsKey = "shortkey.chains"
   - Add loadChains(), saveChains() (same pattern as actions — UserDefaults + JSON)
   - Add addChain(_ chain: ActionChain), updateChain(_ chain: ActionChain), deleteChain(id: UUID)
   - Add moveChain(from:to:) for reordering
   - Add computed: var canAddChain: Bool (gate behind Pro — use same pattern as canAddAction)
   - Load chains in init alongside actions

3. In ProFeatures.swift — Add chain feature:
   - Add case: .promptChaining (or similar) to the pro features enum
   - Gate chain creation behind pro subscription

4. In BusinessRulesConstants.swift — Add:
   - static let maxChainSteps = 5
   - static let freeChainLimit = 0 (no chains on free tier)

5. In ShortkeyController.swift — Add chain execution:
   - Add method: executeChain(_ chain: ActionChain, initialText: String) async throws -> String
   - Implementation:
     - var currentText = initialText
     - for each step in chain.steps:
       - Look up the SpellAction by step.actionId from ActionsManager
       - Call the AI provider transform(text: currentText, description: action.description, model: selectedModel)
       - currentText = result
     - return currentText (final transformed text)
   - Integrate with the existing hotkey flow: when user selects a chain from the picker, call executeChain instead of single transform

6. CREATE shortkey-mac/Shortkey/Views/Sheets/ChainEditorSheet.swift:
   - A sheet/modal for creating and editing chains
   - Fields: name (TextField), icon (SF Symbol picker or simple text field)
   - Steps list: ordered list of actions, each showing action name + icon
   - "Add Step" button: shows picker of available actions
   - Drag to reorder steps (use .onMove modifier)
   - Swipe to delete steps
   - Max 5 steps (show disabled add button when at limit)
   - Save and Cancel buttons
   - Validate: name not empty, at least 2 steps

7. Update Action Picker view:
   - Add a "Chains" section below individual actions
   - Show chains with a chain-link icon (or their custom icon)
   - When user selects a chain, trigger executeChain flow
   - If no chains exist, don't show the section

IMPORTANT:
- Follow existing SwiftUI patterns in the codebase. Match the style exactly.
- Chains are a PRO feature. Free users can see chains but get a paywall when trying to create one.
- Chain execution should show a progress indicator (since it makes multiple API calls).
- If any step in the chain fails, show an error and return the text as-is (don't partially transform).
- Persist chains to UserDefaults (same as actions).
```

---

## Agent 5: Web — Pricing Alignment & Annual Toggle

### Goal
Update the marketing site pricing to show 3 tiers (Free, Pro $9/mo, BYOK $5/mo). Add yearly/monthly toggle. Remove Team and Power tiers. Clean up broken page links.

### Prompt
```
You are updating the pricing page and navigation of a Next.js 16 marketing website.

CONTEXT: The site currently advertises 5 pricing tiers but only 2 are implemented in the backend. You are simplifying to 3 tiers that match the actual product. The site uses React 19, Tailwind CSS 4, Framer Motion, and Lucide React icons.

READ THESE FILES FIRST:
- shortkey-web/src/components/Pricing.tsx
- shortkey-web/src/components/Header.tsx
- shortkey-web/src/components/Footer.tsx
- shortkey-web/src/app/page.tsx
- shortkey-web/src/app/pricing/page.tsx (if exists)
- shortkey-web/src/app/download/page.tsx (if exists)
- shortkey-web/src/app/about/page.tsx (if exists)
- shortkey-web/package.json

CHANGES TO MAKE:

1. In Pricing.tsx — Replace the 5-tier structure with 3 tiers:

   TIER 1 — FREE ($0):
   - Icon: Sparkles
   - Description: "Get started for free"
   - Limits: 50 actions/month, 3 custom actions, 500 character limit
   - Features (checkmark): Basic text transformations, Keyboard shortcuts & context menu, 3 built-in actions, Custom prompt editor (basic)
   - Excluded (x-mark): No prompt chaining, No history search, No multi-device sync
   - CTA: "Download Free"
   - NOT highlighted

   TIER 2 — PRO ($9/mo or $79/year) — MOST POPULAR:
   - Icon: Zap
   - Description: "For power users"
   - Limits: 2,000 actions/month, unlimited custom actions, 2,000 character limit
   - Features: Everything in Free, Unlimited custom actions, Prompt chaining, Prompt templates with variables, Action history & search, Multi-device sync, Priority support
   - Excluded: (none)
   - CTA: "Start Pro Trial"
   - HIGHLIGHTED (border-primary, slight scale-up on md+)
   - Show "Most Popular" badge

   TIER 3 — DEVELOPER / BYOK ($5/mo or $49/year):
   - Icon: Code
   - Description: "Bring Your Own Key"
   - Badge: "BYOK"
   - Limits: Unlimited actions, Choose your AI model, You pay model costs directly
   - Features: Choose provider (OpenAI, Anthropic, etc.), Select any model, Local Keychain storage (keys never leave your Mac), All Pro features included, Prompt chaining & templates, Export/import action presets
   - Excluded: No included AI credits (you use your own key)
   - CTA: "Get Started"
   - NOT highlighted

2. Add yearly/monthly pricing toggle:
   - Add a toggle/switch at the top of the pricing section
   - State: const [isYearly, setIsYearly] = useState(false)
   - Monthly prices: Free $0, Pro $9, BYOK $5
   - Yearly prices: Free $0, Pro $79/yr (save 27%), BYOK $49/yr (save 18%)
   - Show savings badge when yearly is selected: "Save 27%" etc.
   - Animate price change with Framer Motion (simple fade or number transition)

3. In Footer.tsx — Clean up links:
   - Remove "Blog" link (page doesn't exist)
   - Remove "Careers" link (page doesn't exist)
   - Keep: Features, How It Works, Pricing, Download, About, Contact, Privacy, Terms
   - If Contact page doesn't exist, link to mailto:hello@shortkey.app instead

4. In Header.tsx — Verify nav links:
   - Ensure all navigation links point to existing pages or anchor sections
   - Remove any links to non-existent pages

5. Verify build: Run `cd shortkey-web && npm run build` — fix any errors.

IMPORTANT:
- Keep the existing visual design language (Tailwind classes, Framer Motion animations, font choices).
- The pricing grid should be responsive: stack on mobile, 3 columns on desktop.
- Keep the existing hover effects, gradients, and card styling — just update the content.
- Do NOT touch other sections (Hero, HowItWorks, Features, Testimonials, etc.).
'```

---

## Agent 6: CI/CD Pipeline & Backend Tests

### Goal
Set up GitHub Actions for automated CI. Add Jest unit tests for the backend.

### Prompt
```
You are setting up CI/CD and unit tests for a monorepo with 3 projects: shortkey-api (Firebase), shortkey-web (Next.js), shortkey-mac (Swift/Xcode).

READ THESE FILES FIRST:
- shortkey-api/functions/package.json
- shortkey-api/functions/tsconfig.json
- shortkey-api/functions/src/index.ts
- shortkey-api/functions/src/config.ts
- shortkey-api/functions/src/handlers/registerDevice/index.ts
- shortkey-api/functions/src/handlers/registerDevice/validation.ts
- shortkey-api/functions/src/handlers/transformText/index.ts
- shortkey-api/functions/src/handlers/transformText/validation.ts
- shortkey-api/functions/src/services/quotaService.ts
- shortkey-api/functions/src/utils/crypto.ts
- shortkey-web/package.json

CHANGES TO MAKE:

1. In shortkey-api/functions/package.json — Add test dependencies and scripts:
   - Add devDependencies: "jest": "^29.7.0", "ts-jest": "^29.1.1", "@types/jest": "^29.5.12"
   - Add script: "test": "jest --passWithNoTests"
   - Add jest config in package.json:
     ```json
     "jest": {
       "preset": "ts-jest",
       "testEnvironment": "node",
       "roots": ["<rootDir>/src"],
       "testMatch": ["**/__tests__/**/*.test.ts"],
       "moduleFileExtensions": ["ts", "js", "json"]
     }
     ```

2. CREATE shortkey-api/functions/src/__tests__/validation.test.ts:
   - Test registerDevice validation:
     - Should reject missing deviceId
     - Should reject empty deviceId
     - Should reject missing publicKey
     - Should reject non-string inputs
     - Should accept valid deviceId + publicKey
   - Test transformText validation:
     - Should reject missing text
     - Should reject empty text
     - Should reject text exceeding max length (test each tier)
     - Should reject missing instruction
     - Should accept valid text + instruction
   - Import validation functions directly from their modules
   - Mock Firestore if needed (jest.mock)

3. CREATE shortkey-api/functions/src/__tests__/quotaService.test.ts:
   - Test monthly reset logic:
     - Should reset count when month changes
     - Should NOT reset count within same month
     - Should increment count after check
   - Test quota limits:
     - Should allow request when under limit
     - Should reject request when at limit
     - Should use correct limit per tier (free=50, pro=2000, byok=99999)
   - Mock Firestore transactions using jest.mock('firebase-admin/firestore')

4. CREATE shortkey-api/functions/src/__tests__/crypto.test.ts:
   - Test timestamp validation:
     - Should accept timestamp within 5 minutes
     - Should reject timestamp older than 5 minutes
     - Should reject future timestamp beyond 5 minutes
     - Should reject missing/invalid timestamp
   - Test signature verification (if possible with test keys):
     - Generate a P256 key pair in test
     - Sign test data and verify it returns true
     - Verify tampered data returns false

5. CREATE .github/workflows/backend-ci.yml:
   ```yaml
   name: Backend CI
   on:
     push:
       branches: [master]
       paths: ['shortkey-api/**']
     pull_request:
       paths: ['shortkey-api/**']
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - uses: actions/setup-node@v4
           with:
             node-version: '22'
             cache: 'npm'
             cache-dependency-path: shortkey-api/functions/package-lock.json
         - name: Install dependencies
           run: cd shortkey-api/functions && npm ci
         - name: Lint
           run: cd shortkey-api/functions && npm run lint
         - name: Test
           run: cd shortkey-api/functions && npm test
         - name: Build
           run: cd shortkey-api/functions && npm run build
   ```

6. CREATE .github/workflows/web-ci.yml:
   ```yaml
   name: Web CI
   on:
     push:
       branches: [master]
       paths: ['shortkey-web/**']
     pull_request:
       paths: ['shortkey-web/**']
   jobs:
     build:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - uses: actions/setup-node@v4
           with:
             node-version: '22'
             cache: 'npm'
             cache-dependency-path: shortkey-web/package-lock.json
         - name: Install dependencies
           run: cd shortkey-web && npm ci
         - name: Lint
           run: cd shortkey-web && npm run lint
         - name: Build
           run: cd shortkey-web && npm run build
   ```

7. Run `cd shortkey-api/functions && npm install && npm test` to verify tests pass.

IMPORTANT:
- Tests should be self-contained. Mock all external dependencies (Firestore, OpenAI).
- Do NOT create integration tests that require running emulators.
- Use jest.mock() for firebase-admin modules.
- Follow existing TypeScript patterns in the codebase.
- Do NOT modify any source code. Only add test files, CI configs, and package.json changes.
```

---

## Deployment Order

```
Phase 1:  Agent 0  (Rename Verification)     ← run first, alone
Phase 2:  Agents 1–6                         ← run all in parallel after Phase 1
```

## Post-Deployment Checklist

After all agents complete:
- [ ] `cd shortkey-api/functions && npm run build` passes
- [ ] `cd shortkey-web && npm run build` passes
- [ ] `cd shortkey-mac && xcodebuild build -scheme Shortkey -destination 'platform=macOS'` passes
- [ ] `cd shortkey-api/functions && npm test` passes
- [ ] No remaining "spellify" references: `grep -ri spellify --exclude-dir=.git --exclude-dir=node_modules .`
- [ ] Git commit all changes
