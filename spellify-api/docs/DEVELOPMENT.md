# Development Guide - Backend API

> **Note**: This guide covers backend development.  
> For Mac app development, see [Mac Development](../../spellify-mac/docs/DEVELOPMENT.md)  
> For general monorepo guide, see [General Development](../../docs/DEVELOPMENT.md)

---

## Prerequisites

- Node.js 18+
- Firebase CLI: `npm install -g firebase-tools`
- Firebase project
- OpenAI API key

---

## Getting Started

### 1. Install Firebase CLI

```bash
npm install -g firebase-tools
```

### 2. Login to Firebase

```bash
firebase login
```

### 3. Link to Your Project

```bash
cd spellify-api/
firebase use --add
# Select your project from the list
```

### 4. Install Dependencies

```bash
cd functions/
npm install
```

### 5. Set OpenAI API Key

```bash
firebase functions:config:set openai.key="sk-YOUR-OPENAI-KEY"
```

Get your key from: https://platform.openai.com/api-keys

### 6. Start Emulators

```bash
cd ..
firebase emulators:start
```

This starts:
- **Functions Emulator**: http://localhost:5001
- **Firestore Emulator**: http://localhost:8080

---

## Project Structure

```
functions/src/
├── index.ts              # Cloud Function endpoints
│   ├── registerDevice    # Device registration
│   └── transform         # Text transformation
│
├── types.ts              # TypeScript interfaces
├── config.ts             # Configuration constants
├── constants.ts          # Collection names
├── validation.ts         # Input validation
├── crypto.ts             # Signature verification
│
└── services/             # Business logic modules
    ├── deviceCollection.ts      # Device CRUD
    ├── rateLimitCollection.ts   # Rate limiting
    ├── quotaService.ts          # Quota management
    ├── openAiApi.ts             # OpenAI integration
    └── analyticsCollection.ts   # Usage logging
```

---

## Development Workflows

### Adding a New Endpoint

1. **Define types** in `types.ts`:
   ```typescript
   interface NewRequest {
     param1: string;
     param2: number;
   }
   
   interface NewResponse {
     result: string;
   }
   ```

2. **Add validation** in `validation.ts`:
   ```typescript
   export function validateNewRequest(data: any): asserts data is NewRequest {
     if (!data.param1 || typeof data.param1 !== 'string') {
       throw new functions.https.HttpsError('invalid-argument', 'Invalid param1');
     }
   }
   ```

3. **Create handler** in `index.ts`:
   ```typescript
   export const newEndpoint = functions.https.onCall(async (data, context) => {
     validateNewRequest(data);
     const result = await processNew(data);
     return { data: result };
   });
   ```

4. **Test with emulators**:
   ```bash
   curl -X POST http://localhost:5001/PROJECT/us-central1/newEndpoint \
     -H "Content-Type: application/json" \
     -d '{"data": {"param1": "test", "param2": 123}}'
   ```

### Adding a New Service

1. Create file in `services/`:
   ```typescript
   // services/newService.ts
   export async function processData(input: string): Promise<string> {
     // Implementation
   }
   ```

2. Keep file focused (< 100 lines)

3. Export clear interface

4. Handle errors properly

5. Use in `index.ts`

### Modifying Firestore Structure

1. Update types in `types.ts`
2. Update collection operations
3. **Test with emulators first!**
4. Deploy to staging (if available)
5. Deploy to production

---

## Testing

### Local Testing with Emulators

```bash
# Start emulators
firebase emulators:start

# In another terminal, test endpoints:
curl -X POST http://localhost:5001/PROJECT/us-central1/registerDevice \
  -H "Content-Type: application/json" \
  -d '{"data": {"deviceId": "test-123", "publicKey": "BASE64_KEY"}}'

curl -X POST http://localhost:5001/PROJECT/us-central1/transform \
  -H "Content-Type: application/json" \
  -d '{"data": {"deviceId": "test-123", "text": "hello", "instruction": "translate", "signature": "SIG"}}'
```

### Emulator UI

Visit http://localhost:4000 for:
- Functions logs
- Firestore data browser
- Request history

### Testing with Postman

1. Create collection with base URL: `http://localhost:5001/PROJECT/us-central1`
2. Add requests for each endpoint
3. Save test data for reuse

---

## Deployment

### To Production

```bash
# Make sure you're on the right project
firebase use production  # or your project name

# Deploy everything
firebase deploy

# Deploy functions only
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:transform
```

### Deployment Checklist

- [ ] Tested with emulators
- [ ] All lint errors fixed: `npm run lint`
- [ ] Types compile: `npm run build`
- [ ] OpenAI API key configured
- [ ] Firestore TTL configured for `rateLimits`
- [ ] Firestore rules deployed

---

## Configuration

### Environment Config

```bash
# Set config
firebase functions:config:set key="value"

# Get config
firebase functions:config:get

# Unset config
firebase functions:config:unset key
```

### Firestore TTL Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to Firestore Database → Settings
4. Click "Add TTL Policy"
5. Collection: `rateLimits`, Field: `expiresAt`

This auto-deletes expired rate limit documents.

---

## Monitoring

### Firebase Console

1. **Functions** → View logs, errors, performance
2. **Firestore** → Browse data, run queries  
3. **Usage** → Monitor costs

### Viewing Logs

```bash
# Stream logs
firebase functions:log

# View specific function
firebase functions:log --only transform

# Follow logs (like tail -f)
firebase functions:log --follow
```

### Log Levels

```typescript
import { logger } from 'firebase-functions';

logger.info('Info message', { data });
logger.warn('Warning message', { data });
logger.error('Error message', { error, data });
logger.debug('Debug message', { data });
```

---

## Debugging

### Functions Not Working

1. Check Firebase Console → Functions → Logs
2. Verify OpenAI API key: `firebase functions:config:get`
3. Check Firestore rules are deployed
4. Verify request format matches expected types

### Emulators Not Starting

1. Check if ports are in use (5001, 8080, 4000)
2. Kill processes using ports:
   ```bash
   lsof -ti:5001 | xargs kill
   ```
3. Clear emulator data:
   ```bash
   rm -rf .firebase/
   ```

### Signature Verification Failing

1. Check device is registered in Firestore
2. Verify public key format (Base64)
3. Check canonical request format matches client
4. Log the canonical string on both sides

### Quota/Rate Limit Issues

1. Check Firestore data directly
2. Verify transaction logic
3. Check UTC date handling for quota reset

---

## Common Tasks

### Adding a New Tier

1. Update `config.ts`:
   ```typescript
   export const TIER_CONFIG = {
     free: { dailyLimit: 10, maxTextLength: 500 },
     pro: { dailyLimit: 1000, maxTextLength: 2000 },
     enterprise: { dailyLimit: 10000, maxTextLength: 5000 },  // New
   } as const;
   ```

2. Update types in `types.ts`:
   ```typescript
   export type Tier = 'free' | 'pro' | 'enterprise';
   ```

3. Test thoroughly

### Changing Quota Limits

1. Update `config.ts`
2. Deploy: `firebase deploy --only functions`
3. **Note**: Doesn't affect existing users until their daily reset

### Adding a New Collection

1. Add to `constants.ts`:
   ```typescript
   export const Collections = {
     DEVICES: 'devices',
     RATE_LIMITS: 'rateLimits',
     USAGE_LOGS: 'usageLogs',
     NEW_COLLECTION: 'newCollection',  // New
   } as const;
   ```

2. Update Firestore rules if needed

3. Create service for CRUD operations

---

## Cost Optimization

### Current Costs

For 1,000 users × 5 calls/day:
- **Firebase**: ~$1.14/month
- **OpenAI**: ~$1.69/month
- **Total**: ~$2.83/month

### Optimization Tips

1. **Use TTL** for temporary data (rateLimits)
2. **Batch writes** when possible
3. **Cache** frequently accessed data
4. **Monitor** usage in Firebase Console
5. **Set billing alerts** in Firebase Console

---

## Related Documentation

- [Best Practices](BEST_PRACTICES.md) - TypeScript/Firebase conventions
- [API Design](API_DESIGN.md) - Endpoint specifications
- [Architecture](../../docs/ARCHITECTURE.md) - System design
- [General Development](../../docs/DEVELOPMENT.md) - Monorepo guide
- [Mac Development](../../spellify-mac/docs/DEVELOPMENT.md) - Client setup
- [Firebase Functions Docs](https://firebase.google.com/docs/functions)
- [Firestore Docs](https://firebase.google.com/docs/firestore)
