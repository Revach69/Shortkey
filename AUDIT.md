# Shortkey (Shortkey) — Product Audit

> Audited: February 7, 2026
> Scope: Full codebase review — macOS app, Firebase backend, marketing site

---

## 1. Purpose & Honest Review

### What It Does

Shortkey is a macOS menu bar utility that lets users select text anywhere, press a keyboard shortcut, pick an AI action (e.g. "Fix Grammar", "Translate"), and get the text transformed and replaced in-place — all without leaving the current app.

### Honest Assessment: Can This Help People?

**Yes — with caveats.**

**Strengths:**

- **Real friction it solves.** Copy text → open ChatGPT → paste → write prompt → copy result → paste back. That's 6+ steps. Shortkey reduces it to 2 (select + shortcut). This is a genuine productivity win, especially for repetitive text tasks.
- **Universal text access.** Works in any macOS app (Mail, Slack, Notion, VS Code, etc.) via the Accessibility API. This is a significant advantage over browser-only or app-specific tools.
- **Custom actions are powerful.** Users can define their own prompts — "Make this email more professional", "Summarize in 3 bullets", "Convert to SQL". This makes it a personal AI toolkit, not a one-trick grammar checker.
- **Low cognitive overhead.** Menu bar app, no dock icon, no window management. It stays out of the way until needed.

**Concerns:**

- **Crowded space.** Raycast AI, macOS built-in Writing Tools (Apple Intelligence in macOS 15+), TextSoap, Grammarly, and dozens of ChatGPT wrappers exist. Shortkey needs a sharper differentiator.
- **Apple Intelligence is the elephant in the room.** Starting with macOS 15 Sequoia, Apple ships native text rewriting, proofreading, and summarization baked into the OS. Free. No app needed. This directly overlaps with Shortkey's core use case.
- **Limited to text replacement.** Wispr Flow (your comparison) captures voice → text, which is a fundamentally different input modality. Shortkey transforms existing text, which is useful but narrower.
- **macOS only.** No Windows, no iOS, no web. This limits your addressable market significantly.

**Verdict: 7/10 for utility.**
The product solves a real problem well. But the competitive landscape is brutal, and Apple Intelligence erodes the free tier's value proposition. To survive, Shortkey needs to lean into what Apple *can't* do: custom actions, multi-step workflows, BYOK model choice, and power-user features like chaining and batch processing.

---

## 2. Monetization Strategy

### Current State

The backend implements two tiers:

| | Free | Pro |
|---|---|---|
| Daily requests | 10 | 1,000 |
| Max text length | 500 chars | 2,000 chars |
| Custom actions | 3 | Unlimited |

The marketing site advertises 5 tiers (Free, Pro $12/mo, Power $25/mo, Team $15/user/mo, Developer/BYOK $8/mo) — but only 2 are implemented in code. There's a significant gap between what's marketed and what's built.

### Wispr Flow Comparison

Wispr Flow's model is relevant because it's also a macOS utility that overlays on any app:

| | Wispr Flow | Shortkey (current) |
|---|---|---|
| Input | Voice → text | Selected text → transformed text |
| Free tier | Limited minutes/month | 10 requests/day |
| Paid tier | $8-10/mo unlimited | $12/mo (marketed) |
| Differentiator | Voice is the UX | Custom AI actions are the UX |
| API costs | Whisper API (cheap) | GPT-4o-mini (cheap) |
| Stickiness | Habit-forming (voice) | Workflow-dependent |

### Recommended Monetization Model

**Adopt a usage-based free tier with a monthly cap, not a daily cap.**

Daily caps (10/day) feel punishing. A user who has a heavy Monday and light Tuesday hits the wall on the day they need it most. Monthly caps feel generous while costing you the same.

#### Proposed Tiers

| Tier | Price | Monthly Limit | Key Feature |
|---|---|---|---|
| **Free** | $0 | 50 actions/month | 3 custom actions, 500 char limit |
| **Pro** | $9/month ($79/year) | 2,000 actions/month | Unlimited actions, 2,000 chars, prompt templates, history |
| **BYOK** | $5/month ($49/year) | Unlimited | Bring your own API key, any model, you pay model costs |

**Why this structure:**

1. **Free at 50/month** — Enough for casual use (~2/day). Users get hooked on the workflow before hitting the wall. This is the Wispr approach: let them feel the magic, then gate on volume.

2. **Pro at $9/month** — Lower than your current $12. At $12 you're competing with Raycast Pro ($8/mo which includes AI). $9 undercuts while still being profitable. Your per-user cost is ~$0.003/month — even at 100 requests/day the OpenAI cost per user is under $0.50/month.

3. **BYOK at $5/month** — This is your secret weapon. Power users and developers who already have OpenAI/Anthropic API keys will love this. You charge $5/month for the *app* (shortcuts, actions, UI) while they pay their own model costs. Zero AI cost to you, pure margin. This tier also future-proofs against model competition — users can pick Claude, GPT-4o, Llama, whatever they want.

4. **Drop Team and Power tiers for now.** They're not built, and building team features (shared workspaces, admin controls, audit logs) is a massive engineering effort. Ship what you have. Add Team later if enterprise demand materializes.

#### Additional Revenue Ideas

- **Annual discount at 30%+** — Locks in users, reduces churn, improves cash flow.
- **Lifetime deal** — Consider a limited-time $149 lifetime deal for early adopters. Builds community, generates word-of-mouth.
- **Referral program** — "Give 20 free actions, get 20 free actions." Viral growth loop.

---

## 3. Security: Own API Key vs. User API Keys

### Current Architecture

The app supports **two modes** (though only one is fully wired):

1. **Backend mode (default):** App signs requests with device P256 key → Firebase backend verifies signature → backend calls OpenAI with *your* API key (stored as Firebase secret). User never sees or manages an API key.

2. **Direct/BYOK mode:** User enters their own OpenAI API key → stored in macOS Keychain → app calls OpenAI directly, bypassing your backend entirely.

### Analysis

| Factor | Your API Key (Backend) | User's API Key (BYOK) |
|---|---|---|
| **User experience** | Seamless. No setup friction. | Requires OpenAI account + API key creation. |
| **Cost to you** | You pay all OpenAI costs. | Zero AI cost. |
| **Margin** | Thin at scale. GPT-4o-mini is cheap now, but costs add up. | Pure margin — you only pay for Firebase infra. |
| **Control** | Full control over model, prompt, quality. | User picks model. Quality varies. |
| **Privacy** | User text passes through your server. | Text goes directly to OpenAI from user's machine. Privacy-maximizing. |
| **Abuse risk** | You absorb abuse costs (even with rate limiting). | No abuse cost to you. |
| **Vendor lock-in** | You're locked to OpenAI (or whatever you integrate). | User can switch models freely. |
| **Offline/latency** | Extra hop through Firebase adds 50-200ms. | Direct API call, lower latency. |

### Recommendation: Support Both — But Default to Backend

**Default experience: Your API key (backend mode).**
- This is critical for the free tier and Pro tier. Users should never need to touch an API key to get started. Friction kills conversion.
- Your backend gives you quota enforcement, usage analytics, and abuse protection.

**Power-user option: BYOK mode.**
- Offer this as the $5/month BYOK tier. Users who want Claude 3.5 Sonnet or GPT-4o or local models can bring their own key.
- Store keys exclusively in macOS Keychain (you already do this — good).
- Never transmit user API keys to your servers. Make this a privacy selling point.

**Additional security recommendations:**

1. **Add request replay protection.** Currently signatures have no timestamp/nonce. Add a `timestamp` field to the signed payload and reject requests older than 5 minutes. Low effort, meaningful security improvement.

2. **Rate-limit device registration.** The `registerDevice` endpoint is unauthenticated. An attacker could register millions of fake devices to pollute your Firestore. Add IP-based rate limiting via Firebase App Check or Cloud Armor.

3. **Consider Firebase App Check.** Apple's DeviceCheck attestation can verify that requests come from a real macOS app, not a script. This prevents quota abuse from fake clients.

4. **Audit the text pipeline.** User text flows through your server. Document your data retention policy clearly — do you log text content? The `usageLogs` collection stores `textLength` but not the text itself, which is good. Make sure OpenAI's data usage policy is communicated to users (opt out of training via API).

---

## Recommendations Summary

### Product

| Priority | Action | Impact |
|---|---|---|
| **P0** | Differentiate from Apple Intelligence. Lean into custom actions, prompt chaining, multi-model support. Apple can't do this. | Survival |
| **P0** | Align marketing site tiers with actual implementation. 5 tiers advertised, 2 built. This erodes trust. | Trust |
| **P1** | Build the BYOK tier. The protocol architecture (`AIModelProvider`) already supports it. Wire up Anthropic Claude and local Ollama as additional providers. | Revenue + differentiation |
| **P1** | Add prompt chaining (Action A output → Action B input). This is the power-user hook that justifies paid tiers. | Retention |
| **P2** | Ship an iOS/iPadOS companion (even if limited). Keyboard extension that does the same thing. Expands TAM significantly. | Growth |
| **P2** | Add a "community actions" marketplace. Users share prompts. This creates network effects and content moat. | Moat |

### Monetization

| Priority | Action |
|---|---|
| **P0** | Switch from daily caps to monthly caps (50 free/month, 2,000 pro/month). |
| **P0** | Lower Pro price to $9/month to compete with Raycast AI ($8/mo). |
| **P1** | Launch BYOK tier at $5/month. Pure margin, attracts power users. |
| **P1** | Add annual pricing with 30%+ discount. |
| **P2** | Consider lifetime deal for launch ($149). Generates buzz + early revenue. |

### Security

| Priority | Action |
|---|---|
| **P0** | Add timestamp to signed payloads, reject requests older than 5 minutes. |
| **P1** | Rate-limit `registerDevice` endpoint (IP-based or Firebase App Check). |
| **P1** | Implement Firebase App Check with Apple DeviceCheck attestation. |
| **P2** | Document data retention policy. Confirm no text content is logged server-side. |
| **P2** | Add Anthropic Claude as a BYOK provider option (the `AIModelProvider` protocol makes this straightforward). |

### Technical Debt

| Issue | Notes |
|---|---|
| Marketing/backend tier mismatch | Web shows 5 tiers, backend has 2. Either simplify marketing or build the tiers. |
| No CI/CD pipeline | No automated testing or deployment documented. Add GitHub Actions for backend deploys at minimum. |
| No unit tests in backend | Only manual testing via emulators. Add Jest tests for handlers, validation, quota logic. |
| Missing web pages | Blog, Careers, Contact pages are routed but empty. Either build them or remove the links. |
| Bundle ID inconsistency | Docs reference `app.shortkey.mac`, code uses `com.drorlapidot.shortkey`. Standardize before App Store submission. |

---

## Bottom Line

Shortkey is a well-architected product that solves a real problem. The Swift codebase is clean, the security model is solid (P256 signing, Keychain storage, server-only Firestore), and the extensible AI provider architecture is forward-thinking.

The biggest risks are:
1. **Apple Intelligence commoditizing the basic use case** — mitigate by building features Apple won't (custom actions, BYOK, chaining, marketplace).
2. **Overpricing in a competitive market** — $9/mo Pro + $5/mo BYOK is the sweet spot.
3. **Marketing promises outpacing the product** — 5 tiers advertised, 2 built. Ship what you sell.

The opportunity is real. The execution is solid. Now it's about positioning and speed to market.
