# API Design - Backend Endpoints

> **Note**: This document describes the backend API endpoints.  
> For implementation details, see [DEVELOPMENT.md](DEVELOPMENT.md)

---

## Overview

The Shortkey backend provides two main endpoints:
1. **`registerDevice`** - One-time device registration
2. **`transform`** - Text transformation with AI

Both are Firebase Cloud Functions (HTTPS Callable).

---

## Base URL

```
https://us-central1-YOUR-PROJECT-ID.cloudfunctions.net
```

---

## Authentication

All requests (except `registerDevice` initial call) must be **cryptographically signed** using P256.

### Signature Process

1. Client generates P256 keypair (once)
2. Client registers with public key
3. For each request:
   - Create canonical string: `deviceId|text|instruction`
   - Sign with private key (P256)
   - Send signature with request

4. Server verifies signature with stored public key

**Benefits:**
- Prevents device ID spoofing
- No shared secrets
- Offline signing (no timestamp validation)

---

## Endpoints

### 1. Register Device

Register a new device with its public key.

**Endpoint**: `/registerDevice`

**Method**: POST (HTTPS Callable)

**Request**:
```json
{
  "data": {
    "deviceId": "550e8400-e29b-41d4-a716-446655440000",
    "publicKey": "BASE64_ENCODED_P256_PUBLIC_KEY"
  }
}
```

**Request Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `deviceId` | string | ✅ | UUID for device identification |
| `publicKey` | string | ✅ | P256 public key (x963 format, Base64) |

**Response** (Success):
```json
{
  "data": {
    "success": true
  }
}
```

**Errors**:
| Code | Message | Reason |
|------|---------|--------|
| `invalid-argument` | Invalid deviceId | Missing or invalid deviceId |
| `invalid-argument` | Invalid publicKey | Missing or invalid public key |
| `already-exists` | Device already registered | Device ID already exists |

**Example (curl)**:
```bash
curl -X POST https://us-central1-PROJECT.cloudfunctions.net/registerDevice \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "deviceId": "550e8400-e29b-41d4-a716-446655440000",
      "publicKey": "BASE64_KEY_HERE"
    }
  }'
```

---

### 2. Transform Text

Transform text using AI.

**Endpoint**: `/transform`

**Method**: POST (HTTPS Callable)

**Request**:
```json
{
  "data": {
    "deviceId": "550e8400-e29b-41d4-a716-446655440000",
    "text": "Hello, world!",
    "instruction": "Translate to Spanish",
    "signature": "BASE64_ENCODED_SIGNATURE"
  }
}
```

**Request Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `deviceId` | string | ✅ | UUID for device identification |
| `text` | string | ✅ | Text to transform (max 500/2000 chars) |
| `instruction` | string | ✅ | Transformation instruction |
| `signature` | string | ✅ | P256 signature of canonical request |

**Canonical Request Format**:
```
deviceId|text|instruction
```

**Response** (Success):
```json
{
  "data": {
    "result": "¡Hola, mundo!",
    "quota": {
      "used": 5,
      "limit": 10,
      "resetsAt": "2024-01-10T00:00:00Z"
    }
  }
}
```

**Response Fields**:
| Field | Type | Description |
|-------|------|-------------|
| `result` | string | Transformed text |
| `quota.used` | number | Requests used today |
| `quota.limit` | number | Daily request limit |
| `quota.resetsAt` | string | UTC timestamp for quota reset |

**Errors**:
| Code | Message | Reason |
|------|---------|--------|
| `invalid-argument` | Invalid deviceId | Missing or invalid deviceId |
| `invalid-argument` | Invalid text | Missing or invalid text |
| `invalid-argument` | Text too long | Text exceeds tier limit |
| `permission-denied` | Invalid signature | Signature verification failed |
| `not-found` | Device not found | Device not registered |
| `resource-exhausted` | Daily limit reached | Quota exceeded |
| `resource-exhausted` | Rate limit exceeded | Too many requests (10/min) |
| `internal` | Transform failed | OpenAI API error |

**Example (curl)**:
```bash
curl -X POST https://us-central1-PROJECT.cloudfunctions.net/transform \
  -H "Content-Type: application/json" \
  -d '{
    "data": {
      "deviceId": "550e8400-e29b-41d4-a716-446655440000",
      "text": "Hello, world!",
      "instruction": "Translate to Spanish",
      "signature": "BASE64_SIGNATURE_HERE"
    }
  }'
```

---

## Rate Limiting

**Limit**: 10 requests per minute per device

**Implementation**: Firestore transaction (atomic)

**Exceeded Response**:
```json
{
  "error": {
    "code": "resource-exhausted",
    "message": "Rate limit exceeded. Try again in a minute."
  }
}
```

**Key**: `${deviceId}_${currentMinute}`

**TTL**: 2 minutes (auto-cleanup)

---

## Quota Management

### Tiers

| Tier | Daily Limit | Max Text Length |
|------|-------------|-----------------|
| **Free** | 10 requests | 500 characters |
| **Pro** | 1000 requests | 2000 characters |

### Reset Schedule

- Resets at **midnight UTC** daily
- Auto-reset on next request after midnight

### Quota Response

Every successful `transform` returns quota info:
```json
{
  "quota": {
    "used": 5,       // Requests used today
    "limit": 10,     // Daily limit for tier
    "resetsAt": "2024-01-10T00:00:00Z"  // Next reset time
  }
}
```

**Exceeded Response**:
```json
{
  "error": {
    "code": "resource-exhausted",
    "message": "Daily limit reached. Upgrade to Pro for 1000 requests/day."
  }
}
```

---

## Data Models

### Device Document

```typescript
interface Device {
  deviceId: string;        // UUID
  publicKey: string;       // Base64 P256 public key
  tier: 'free' | 'pro';   // Subscription tier
  dailyCount: number;      // Requests used today
  lastReset: string;       // "YYYY-MM-DD"
  firstSeen: Timestamp;    // Registration time
  lastSeen: Timestamp;     // Last request time
}
```

**Collection**: `devices`

**Document ID**: `deviceId`

### Rate Limit Document

```typescript
interface RateLimit {
  count: number;           // Requests this minute
  expiresAt: Timestamp;    // TTL field (auto-delete)
}
```

**Collection**: `rateLimits`

**Document ID**: `${deviceId}_${minute}` (e.g., `abc123_2024-01-09T15:30`)

**TTL**: 2 minutes

### Usage Log Document

```typescript
interface UsageLog {
  deviceId: string;
  tier: 'free' | 'pro';
  textLength: number;
  success: boolean;
  timestamp: Timestamp;
  model: string;           // "gpt-4o-mini"
}
```

**Collection**: `usageLogs`

**Document ID**: Auto-generated

---

## Security

### Firestore Rules

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

### Signature Verification

Server validates signatures using:
1. Retrieve device's public key from Firestore
2. Create canonical string from request
3. Verify signature with public key
4. Reject if invalid

**Canonical Format**:
```
deviceId|text|instruction
```

**No timestamp** - KISS principle (rate limit + quota = sufficient protection)

---

## Error Handling

### Error Format

```json
{
  "error": {
    "code": "error-code",
    "message": "Human-readable message"
  }
}
```

### Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `invalid-argument` | 400 | Bad request (missing/invalid fields) |
| `permission-denied` | 403 | Authentication failed (invalid signature) |
| `not-found` | 404 | Resource not found (device not registered) |
| `already-exists` | 409 | Resource already exists |
| `resource-exhausted` | 429 | Quota or rate limit exceeded |
| `internal` | 500 | Server error |

---

## Best Practices

### For Clients

1. **Register once** - Store deviceId securely
2. **Sign all requests** - Except initial registration
3. **Handle quotas** - Show remaining requests to user
4. **Retry with backoff** - For transient errors
5. **Respect rate limits** - Don't hammer the API

### For Monitoring

1. **Track quota usage** - Alert when approaching limits
2. **Monitor error rates** - Investigate spikes
3. **Check latency** - Optimize slow endpoints
4. **Review logs** - Firebase Console → Functions

---

## Testing

### Local (Emulators)

```bash
# Start emulators
firebase emulators:start

# Test register
curl -X POST http://localhost:5001/PROJECT/us-central1/registerDevice \
  -H "Content-Type: application/json" \
  -d '{"data": {"deviceId": "test-123", "publicKey": "BASE64"}}'

# Test transform
curl -X POST http://localhost:5001/PROJECT/us-central1/transform \
  -H "Content-Type: application/json" \
  -d '{"data": {"deviceId": "test-123", "text": "hello", "instruction": "translate", "signature": "SIG"}}'
```

### Production

Use Postman or curl with real URLs and valid signatures.

---

## Related Documentation

- [Backend Development](DEVELOPMENT.md) - Setup and deployment
- [Backend Best Practices](BEST_PRACTICES.md) - Code conventions
- [Architecture](../../docs/ARCHITECTURE.md) - System design
- [Firebase Functions Docs](https://firebase.google.com/docs/functions)
