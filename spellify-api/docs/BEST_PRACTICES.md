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

Use `functions.logger` not `console.log`:

```typescript
import { logger } from 'firebase-functions';

// Good ✅
logger.info('Device registered', { deviceId });
logger.error('Transform failed', { error, deviceId });

// Bad ❌
console.log('Device registered');
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
├── index.ts              # Cloud Function handlers (orchestration)
├── types.ts              # TypeScript interfaces
├── config.ts             # Configuration constants
├── validation.ts         # Input validation
├── crypto.ts             # Signature verification
└── services/             # Business logic modules
    ├── deviceCollection.ts
    ├── quotaService.ts
    ├── rateLimitCollection.ts
    ├── openAiApi.ts
    └── analyticsCollection.ts
```

**Benefits:**
- Each file has single responsibility
- Easy to find relevant code
- Easy to test independently
- Easy to maintain

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
export const TIER_CONFIG = {
  free: {
    dailyLimit: 10,
    maxTextLength: 500,
  },
  pro: {
    dailyLimit: 1000,
    maxTextLength: 2000,
  },
} as const;

export const Collections = {
  DEVICES: 'devices',
  RATE_LIMITS: 'rateLimits',
  USAGE_LOGS: 'usageLogs',
} as const;
```

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

### Services
- `services/deviceCollection.ts` - Clean CRUD operations
- `services/quotaService.ts` - Atomic transactions
- `services/openAiApi.ts` - External API integration

### Structure
```
functions/src/
├── index.ts              # Orchestration only (~50 lines)
├── types.ts              # Type definitions (~25 lines)
├── config.ts             # Constants (~30 lines)
├── validation.ts         # Input validation (~50 lines)
├── crypto.ts             # Signature verification (~35 lines)
└── services/             # Business logic (30-50 lines each)
    ├── deviceCollection.ts
    ├── quotaService.ts
    ├── rateLimitCollection.ts
    ├── openAiApi.ts
    └── analyticsCollection.ts
```

---

## Related Documentation

- [General Best Practices](../../docs/BEST_PRACTICES.md) - SOLID, Clean Architecture
- [Development Guide](DEVELOPMENT.md) - Setup, deployment, testing
- [API Design](API_DESIGN.md) - Endpoints, request/response formats
- [Architecture](../../docs/ARCHITECTURE.md) - System design
- [Firebase Functions Docs](https://firebase.google.com/docs/functions)
- [Firestore Docs](https://firebase.google.com/docs/firestore)
