# Spellify Firebase Backend

Simple, secure Firebase backend for Spellify text transformations.

## Overview

- **Crypto Signing**: P256 signature verification prevents device ID spoofing
- **Quota Management**: 10/day free (500 chars), 1000/day pro (2000 chars)
- **Rate Limiting**: 10 requests/minute (burst protection)
- **Usage Analytics**: Full logging for insights

## Structure

```
firebase/
├── functions/
│   ├── src/
│   │   ├── index.ts           # Main handlers (registerDevice, transform)
│   │   ├── types.ts           # TypeScript types
│   │   ├── config.ts          # Configuration
│   │   ├── validation.ts      # Request validation
│   │   ├── crypto.ts          # Signature verification
│   │   └── services/
│   │       ├── device.ts      # Device operations
│   │       ├── rateLimit.ts   # Rate limiting
│   │       ├── quota.ts       # Quota management
│   │       ├── openai.ts      # OpenAI integration
│   │       └── analytics.ts   # Usage logging
│   ├── package.json
│   └── tsconfig.json
├── firebase.json
├── firestore.rules
└── README.md
```

## Prerequisites

1. **Node.js 18+**: Required for Cloud Functions
2. **Firebase CLI**: Install globally
   ```bash
   npm install -g firebase-tools
   ```
3. **Firebase Project**: Create at [console.firebase.google.com](https://console.firebase.google.com)
4. **OpenAI API Key**: Get from [platform.openai.com](https://platform.openai.com)

## Setup

### 1. Login to Firebase

```bash
firebase login
```

### 2. Initialize Project (if not done)

```bash
cd /Users/drorl/Projects/Spellify
firebase init
# Select: Functions, Firestore
# Language: TypeScript
# Use existing source? Yes
```

### 3. Install Dependencies

```bash
cd firebase/functions
npm install
```

### 4. Set OpenAI API Key

```bash
firebase functions:config:set openai.key="sk-YOUR-OPENAI-API-KEY-HERE"
```

### 5. Deploy to Firebase

```bash
cd firebase
firebase deploy
```

This will deploy:
- Cloud Functions (registerDevice, transform)
- Firestore Rules

### 6. Configure Firestore TTL

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to Firestore Database → Settings
4. Enable TTL for `rateLimits` collection
5. Set field: `expiresAt`

This auto-deletes expired rate limit documents.

### 7. Update Swift Client

In `Spellify/Services/FirebaseBackendManager.swift`, update the Firebase URL:

```swift
private let baseURL = "https://us-central1-YOUR-PROJECT-ID.cloudfunctions.net"
```

Replace `YOUR-PROJECT-ID` with your actual Firebase project ID.

## Local Testing

### Start Emulators

```bash
cd firebase
firebase emulators:start
```

This starts:
- Functions Emulator: http://localhost:5001
- Firestore Emulator: http://localhost:8080

### Test registerDevice

```bash
curl -X POST http://localhost:5001/YOUR-PROJECT-ID/us-central1/registerDevice \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "deviceId": "test-device-123",
      "publicKey": "BASE64_PUBLIC_KEY_HERE"
    }
  }'
```

## Firestore Collections

### `devices`
```typescript
{
  deviceId: string,        // Document ID
  publicKey: string,       // Base64 P256 public key
  tier: 'free' | 'pro',
  dailyCount: number,
  lastReset: string,       // "YYYY-MM-DD"
  firstSeen: Timestamp,
  lastSeen: Timestamp,
}
```

### `rateLimits`
```typescript
{
  // Document ID: `${deviceId}_${minute}`
  count: number,
  expiresAt: Timestamp,    // TTL: 2 minutes
}
```

### `usageLogs`
```typescript
{
  deviceId: string,
  tier: 'free' | 'pro',
  textLength: number,
  success: boolean,
  timestamp: Timestamp,
  model: string,
}
```

## Security

✅ **Signature Verification**: Prevents device ID spoofing  
✅ **Rate Limiting**: 10 req/min (atomic)  
✅ **Quota Management**: 10/day free, 1000/day pro (atomic)  
✅ **Firestore Rules**: Server-only access  

⚠️ **Known Limitation**: No replay protection (acceptable trade-off for simplicity)

## Monitoring

View logs and metrics in Firebase Console:

1. **Functions**: Real-time logs, errors, performance
2. **Firestore**: Data browser, queries
3. **Usage**: Costs, analytics

## Cost Estimate

For 1,000 users × 5 calls/day (realistic usage):

- **Firebase**: $1.14/month
  - Functions: $0.06
  - Firestore: $1.08
- **OpenAI**: $1.69/month
- **Total**: ~$2.83/month

**Cost per user: $0.003/month**

## Troubleshooting

### "Permission denied" on deploy
```bash
firebase login --reauth
```

### Functions timeout
Increase timeout in `index.ts`:
```typescript
.runWith({ timeoutSeconds: 60 })
```

### Emulator connection refused
Check firewall and restart:
```bash
firebase emulators:start --only functions,firestore
```

## Production Checklist

- [ ] OpenAI API key configured
- [ ] Firebase project created
- [ ] Functions deployed
- [ ] Firestore TTL configured for `rateLimits`
- [ ] Swift client updated with correct Firebase URL
- [ ] Tested device registration
- [ ] Tested text transformation
- [ ] Monitoring set up in Firebase Console

## Support

For issues or questions:
1. Check Firebase Console logs
2. Review Firestore data
3. Test with emulators locally
