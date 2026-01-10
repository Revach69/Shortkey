# Best Practices - Backend API (TypeScript + Firebase)

> **Note**: This document covers TypeScript and Firebase specific best practices.  
> For general architectural principles, see [General Best Practices](../../docs/BEST_PRACTICES.md)

---

## TypeScript Best Practices

### Strict Mode

Always use strict mode in `tsconfig.json`:

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

### Explicit Types

❌ **NEVER use `any`** unless absolutely necessary  
✅ **ALWAYS use explicit types**

```typescript
// Bad ❌
function transform(data: any) { ... }

// Good ✅
function transform(data: TransformRequest): TransformResult { ... }
```

### Interfaces for Data Structures

```typescript
// Use interfaces for data structures
interface Device {
  deviceId: string;
  publicKey: string;
  tier: 'free' | 'pro';
  dailyCount: number;
  lastReset: string;
}

// Use enums for constants
enum Tier {
  FREE = 'free',
  PRO = 'pro',
}
```

---

## Firebase Best Practices

### Cloud Functions

#### Callable Functions

Use `https.onCall` for client-callable functions:

```typescript
export const transform = functions.https.onCall(async (data, context) => {
  // Validate input
  validateTransformRequest(data);
  
  // Process
  const result = await processTransform(data);
  
  // Return in {data: ...} format
  return { data: result };
});
```

#### Configuration

```typescript
// Set timeout for long operations
export const transform = functions
  .runWith({ timeoutSeconds: 60 })
  .https.onCall(async (data, context) => { ... });
```

#### Logging

Use **Cloud Logging** via `functions.logger` (not `console.log` or Firestore):

```typescript
import * as functions from 'firebase-functions';

// Good ✅ - Structured logging with Cloud Logging
functions.logger.log('usage_event', {
  deviceId,
  tier,
  textLength,
  success: true,
  timestamp: new Date().toISOString(),
});

functions.logger.error('Transform failed', { error, deviceId });

// Bad ❌ - console.log (not structured)
console.log('Device registered');

// Bad ❌ - Firestore for logs (expensive, slower)
await db.collection('usageLogs').add({ deviceId, timestamp: ... });
```

**Why Cloud Logging?**
- ✅ **Free** (included in Cloud Functions free tier)
- ✅ **Fast** (async, doesn't block function execution)
- ✅ **Queryable** (structured JSON in Cloud Console)
- ✅ **Exportable** (auto-export to BigQuery for analytics)
- ✅ **Integrated** (works with Cloud Monitoring/Alerting)

**Viewing Logs in Cloud Console:**
```
Cloud Logging → Logs Explorer
Filter: jsonPayload.message="usage_event"
Filter errors: jsonPayload.success=false
```

### Firestore

#### Transactions for Atomic Operations

✅ **ALWAYS use transactions** for atomic operations:

```typescript
// Good ✅ - Atomic quota check and increment
await db.runTransaction(async (transaction) => {
  const deviceRef = db.collection('devices').doc(deviceId);
  const device = await transaction.get(deviceRef);
  
  if (device.data()!.dailyCount >= limit) {
    throw new functions.https.HttpsError('resource-exhausted', 'Quota exceeded');
  }
  
  transaction.update(deviceRef, {
    dailyCount: FieldValue.increment(1),
  });
});
```

#### Batch Writes

Use batch writes for multiple updates:

```typescript
const batch = db.batch();

batch.update(deviceRef, { lastSeen: FieldValue.serverTimestamp() });
batch.set(logRef, { deviceId, timestamp: FieldValue.serverTimestamp() });

await batch.commit();
```

#### TTL for Temporary Data

Use TTL (Time-To-Live) for auto-cleanup:

```typescript
// rateLimits collection
await db.collection('rateLimits').doc(key).set({
  count: 1,
  expiresAt: Timestamp.fromMillis(Date.now() + 2 * 60 * 1000), // 2 minutes
});

// Configure in Firebase Console:
// Firestore → Settings → TTL → Add Policy
// Collection: rateLimits, Field: expiresAt
```

### Security

#### Firestore Rules - Server Only

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // All collections: server-only access
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

Direct client access is **completely blocked**.

#### Input Validation

✅ **ALWAYS validate all inputs**:

```typescript
function validateTransformRequest(data: any): asserts data is TransformRequest {
  if (!data.deviceId || typeof data.deviceId !== 'string') {
    throw new functions.https.HttpsError('invalid-argument', 'Invalid deviceId');
  }
  
  if (!data.text || typeof data.text !== 'string') {
    throw new functions.https.HttpsError('invalid-argument', 'Invalid text');
  }
  
  if (data.text.length > MAX_TEXT_LENGTH) {
    throw new functions.https.HttpsError('invalid-argument', 'Text too long');
  }
}
```

#### Secrets in Environment Config

```bash
# Set secrets via Firebase CLI
firebase functions:config:set openai.key="sk-YOUR-KEY"

# Access in code
const openaiKey = functions.config().openai.key;
```

❌ **NEVER commit secrets** to git!

---

## File Size & Organization

✅ Keep files **< 100 lines** (preferred)  
✅ Max **150 lines** absolute limit  
✅ If larger, **split into smaller modules**

### Service Structure

```
functions/src/
├── index.ts              # Cloud Functions registration (orchestration only!)
├── config.ts             # Configuration constants
├── constants.ts          # Collection names, constants
│
├── types/                # TypeScript type definitions
│   ├── models.ts         # Domain models (Device, Quota, etc.)
│   └── server.ts         # Server types (RequestContext, etc.)
│
├── handlers/             # Feature folders (colocation pattern)
│   ├── registerDevice/
│   │   ├── index.ts      # Handler logic
│   │   └── validation.ts # Handler-specific validation
│   └── transform/
│       ├── index.ts      # Handler logic
│       └── validation.ts # Handler-specific validation
│
├── utils/                # Shared utility functions
│   ├── crypto.ts         # Signature verification (used by multiple handlers)
│   └── getRequestContext.ts  # Common request processing
│
└── services/             # Business logic modules (organized by type)
    ├── collections/      # Firestore collection services
    │   ├── deviceCollection.ts      # Device CRUD
    │   └── rateLimitCollection.ts   # Rate limit CRUD
    ├── externals/        # External API integrations
    │   └── openAiApi.ts             # OpenAI API client
    ├── logService.ts                # Cloud Logging wrapper
    └── quotaService.ts              # Quota management (business logic)
```

**Benefits:**
- ✅ **Single Responsibility** - Each file has one clear purpose
- ✅ **Organized by Type** - `collections/` vs `externals/` vs business logic
- ✅ **Easy to Navigate** - Clear where to find Firestore code vs external APIs
- ✅ **Easy to Extend** - Add new external API? → `externals/stripeApi.ts`
- ✅ **Easy to Test** - Each module is independently testable
- ✅ **Easy to Maintain** - Small, focused files (30-70 lines)

### Services Organization Strategy

#### When to use `services/collections/`?
✅ Firestore CRUD operations (Create, Read, Update, Delete)  
✅ Direct database access  
✅ Collection-specific logic

```typescript
// services/collections/deviceCollection.ts
export async function getDevice(deviceId: string) {
  const doc = await db.collection(Collections.DEVICES).doc(deviceId).get();
  return doc.exists ? doc.data() : null;
}
```

#### When to use `services/externals/`?
✅ External API calls (OpenAI, Stripe, Twilio, etc.)  
✅ Third-party service integrations  
✅ HTTP requests to non-Google services

```typescript
// services/externals/openAiApi.ts
export async function transformText(text: string, instruction: string) {
  const response = await openai.chat.completions.create({ ... });
  return response.choices[0].message.content || '';
}
```

#### When to use `services/` root?
✅ Business logic (orchestrates multiple operations)  
✅ Cross-cutting concerns (logging, monitoring)  
✅ Doesn't fit in `collections/` or `externals/`

```typescript
// services/quotaService.ts
// Orchestrates: Firestore transaction + business rules
export async function checkAndIncrementQuota(deviceId: string, tier: TierType) {
  // Complex logic combining Firestore access + quota rules
}

// services/logService.ts
// Wraps Cloud Logging (not Firestore, not external API)
export function logUsage(deviceId: string, tier: TierType, ...) {
  functions.logger.log('usage_event', { ... });
}
```

**Future Examples:**
- `externals/stripeApi.ts` - Stripe payment processing
- `externals/twilioApi.ts` - SMS notifications
- `collections/subscriptionCollection.ts` - Subscription CRUD
- `services/billingService.ts` - Business logic for billing (uses Stripe + Firestore)

---

## Error Handling

### Use HttpsError

```typescript
import { https } from 'firebase-functions';

// Good ✅
throw new https.HttpsError('invalid-argument', 'Device ID is required');
throw new https.HttpsError('resource-exhausted', 'Daily quota exceeded');
throw new https.HttpsError('permission-denied', 'Invalid signature');

// Bad ❌
throw new Error('Device ID is required');  // Generic error
```

### Error Codes

Use proper error codes:
- `invalid-argument` - Bad input
- `not-found` - Resource not found
- `resource-exhausted` - Quota/rate limit exceeded
- `permission-denied` - Authentication/authorization failed
- `internal` - Server error

### User-Friendly Messages

```typescript
// Good ✅
throw new https.HttpsError(
  'resource-exhausted',
  'Daily limit reached. Try again tomorrow or upgrade to Pro.'
);

// Bad ❌
throw new https.HttpsError('resource-exhausted', 'quota_exceeded');
```

---

## Constants & Configuration

### Central Configuration

```typescript
// config.ts
export const CONFIG = {
  tiers: {
    free: {
      daily: 10,
      burst: 10,
      maxTextLength: 500,
    },
    pro: {
      daily: 1000,
      burst: 30,
      maxTextLength: 2000,
    },
  },
  openai: {
    model: 'gpt-4o-mini',
    temperature: 0.7,
    maxTokens: 1000,
  },
} as const;

// constants.ts
export const Collections = {
  DEVICES: 'devices',
  RATE_LIMITS: 'rateLimits',
} as const;
```

**Note:** Usage logging is done via Cloud Logging (not Firestore), so no `USAGE_LOGS` collection needed.

### Use Constants

```typescript
// Good ✅
if (count > TIER_CONFIG[tier].dailyLimit) { ... }
const deviceRef = db.collection(Collections.DEVICES).doc(id);

// Bad ❌
if (count > 10) { ... }
const deviceRef = db.collection('devices').doc(id);
```

---

## Comments & Documentation

✅ Comments explain **WHY**, not **WHAT**  
❌ **NO trivial comments**  
✅ Use JSDoc for exported functions

```typescript
// Bad ❌
// Get device from Firestore
const device = await getDevice(deviceId);

// Good ✅
// Use transaction to prevent race conditions on quota
return db.runTransaction(async (transaction) => { ... });

/**
 * Transforms text using OpenAI API
 * 
 * @param text - Text to transform
 * @param instruction - Transformation instruction
 * @param model - OpenAI model to use
 * @returns Transformed text
 * @throws {HttpsError} If quota exceeded or API fails
 */
export async function transformText(
  text: string,
  instruction: string,
  model: string
): Promise<string> { ... }
```

---

## Testing

### Local Testing (Emulators)

```bash
# Start emulators
firebase emulators:start

# Test endpoints
curl -X POST http://localhost:5001/PROJECT/us-central1/transform \
  -H "Content-Type: application/json" \
  -d '{"data": {...}}'
```

### Unit Tests

```typescript
import { expect } from 'chai';
import { validateTransformRequest } from '../validation';

describe('validateTransformRequest', () => {
  it('should accept valid request', () => {
    const data = { deviceId: 'abc', text: 'hello', signature: 'xyz' };
    expect(() => validateTransformRequest(data)).to.not.throw();
  });
  
  it('should reject missing deviceId', () => {
    const data = { text: 'hello', signature: 'xyz' };
    expect(() => validateTransformRequest(data)).to.throw('Invalid deviceId');
  });
});
```

---

## Performance

### Cold Start Optimization

- Keep dependencies minimal
- Lazy-load heavy modules
- Use global variables for reuse

```typescript
// Good ✅ - Initialize once, reuse across invocations
let openaiClient: OpenAI | null = null;

function getOpenAIClient() {
  if (!openaiClient) {
    openaiClient = new OpenAI({ apiKey: functions.config().openai.key });
  }
  return openaiClient;
}
```

### Database Queries

```typescript
// Good ✅ - Specific query
const devices = await db
  .collection('devices')
  .where('tier', '==', 'pro')
  .limit(10)
  .get();

// Bad ❌ - Get all documents
const devices = await db.collection('devices').get();
```

---

## Anti-Patterns (Never Do)

```typescript
// ❌ Using any
function transform(data: any) { ... }

// ❌ No error handling
const result = await db.collection('devices').doc(id).get();
return result.data();

// ❌ Magic numbers
if (count > 10) { ... }

// ❌ Large files (300+ lines)

// ❌ console.log instead of logger
console.log('Device registered');

// ❌ No input validation
export const transform = functions.https.onCall(async (data) => {
  // Directly use data without validation
  const result = await processTransform(data.text);
});
```

---

## Perfect Examples in Codebase

### Handlers (Colocation Pattern)
- `handlers/registerDevice/index.ts` - Clean handler with colocated validation
- `handlers/transform/index.ts` - Orchestrates complex flow (context → validation → quota → transform → log)
- `handlers/*/validation.ts` - Handler-specific validation (not shared)

### Services by Type

#### Collections (Firestore CRUD)
- `services/collections/deviceCollection.ts` - Device CRUD operations
- `services/collections/rateLimitCollection.ts` - Rate limit CRUD with TTL

#### Externals (API Integrations)
- `services/externals/openAiApi.ts` - OpenAI API client (clean, focused)

#### Business Logic
- `services/quotaService.ts` - Atomic transactions for quota management
- `services/logService.ts` - Cloud Logging wrapper (structured events)

### Utils (Shared, Reusable)
- `utils/crypto.ts` - P256 signature verification
- `utils/getRequestContext.ts` - Common request processing (device lookup, signature, rate limit)

### Structure Overview
```
functions/src/
├── index.ts              # Orchestration only (~17 lines)
├── config.ts             # Constants (~22 lines)
├── constants.ts          # Collection names (~5 lines)
│
├── types/                # Type definitions
│   ├── models.ts         # Domain models (~25 lines)
│   └── server.ts         # Server types (~10 lines)
│
├── handlers/             # Feature folders (~25-40 lines each)
│   ├── registerDevice/index.ts
│   ├── registerDevice/validation.ts
│   ├── transform/index.ts
│   └── transform/validation.ts
│
├── utils/                # Shared utilities (~40-47 lines each)
│   ├── crypto.ts
│   └── getRequestContext.ts
│
└── services/             # Business logic
    ├── collections/      # Firestore (~40-46 lines each)
    │   ├── deviceCollection.ts
    │   └── rateLimitCollection.ts
    ├── externals/        # External APIs (~25 lines)
    │   └── openAiApi.ts
    ├── logService.ts     # Cloud Logging (~29 lines)
    └── quotaService.ts   # Business logic (~66 lines)
```

**All files < 70 lines! 🎉**

---

## Related Documentation

- [General Best Practices](../../docs/BEST_PRACTICES.md) - SOLID, Clean Architecture
- [Development Guide](DEVELOPMENT.md) - Setup, deployment, testing
- [API Design](API_DESIGN.md) - Endpoints, request/response formats
- [Architecture](../../docs/ARCHITECTURE.md) - System design
- [Firebase Functions Docs](https://firebase.google.com/docs/functions)
- [Firestore Docs](https://firebase.google.com/docs/firestore)
