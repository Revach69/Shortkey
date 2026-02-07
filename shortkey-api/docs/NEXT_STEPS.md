# Next Steps - Firebase Backend Deployment

All code has been implemented! Here's what you need to do to deploy and test:

## ✅ Completed

- [x] Firebase project structure created
- [x] TypeScript backend implemented (9 files, ~300 lines)
- [x] Swift crypto signing service (CryptoService.swift)
- [x] Swift Firebase backend manager (FirebaseBackendManager.swift)
- [x] Error strings added to Strings.swift
- [x] Documentation (README.md)

## 🚀 Manual Steps Required

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add Project"
3. Name it (e.g., "Shortkey")
4. Disable Google Analytics (not needed)
5. Note your Project ID

### 2. Initialize Firebase CLI

```bash
cd /Users/drorl/Projects/Shortkey/firebase

# Login to Firebase
firebase login

# Link to your project
firebase use --add
# Select your project from the list
```

### 3. Install Dependencies

```bash
cd functions
npm install
```

### 4. Set OpenAI API Key

```bash
firebase functions:config:set openai.key="sk-YOUR-OPENAI-KEY"
```

Get your key from: https://platform.openai.com/api-keys

### 5. Deploy to Firebase

```bash
cd ..
firebase deploy
```

This will output your function URLs:
```
✔  Deploy complete!

Functions:
  registerDevice: https://us-central1-YOUR-PROJECT.cloudfunctions.net/registerDevice
  transform: https://us-central1-YOUR-PROJECT.cloudfunctions.net/transform
```

### 6. Configure Firestore TTL

1. Go to Firebase Console → Firestore Database
2. Click Settings (gear icon)
3. Scroll to "Time-to-live (TTL)"
4. Click "Add TTL Policy"
5. Collection: `rateLimits`
6. Field: `expiresAt`
7. Save

### 7. Update Swift Client

Edit `Shortkey/Services/FirebaseBackendManager.swift`:

```swift
// Line 16: Update this URL with your project ID
private let baseURL = "https://us-central1-YOUR-PROJECT-ID.cloudfunctions.net"
```

Replace `YOUR-PROJECT-ID` with your actual Firebase project ID from step 1.

### 8. Add Swift Files to Xcode

You need to add the new Swift files to your Xcode project:

1. Open `Shortkey.xcodeproj` in Xcode
2. Right-click on `Services` folder → "Add Files to Shortkey"
3. Select:
   - `Shortkey/Services/CryptoService.swift`
   - `Shortkey/Services/FirebaseBackendManager.swift`
4. Make sure "Copy items if needed" is checked
5. Click "Add"

### 9. Update ShortkeyApp.swift

Add device registration on app launch:

```swift
// In ShortkeyApp.swift, after Firebase initialization:
Task {
    try? await FirebaseBackendManager.shared.registerDeviceIfNeeded()
}
```

### 10. Test Locally (Optional but Recommended)

Before deploying, test with emulators:

```bash
cd /Users/drorl/Projects/Shortkey/firebase
firebase emulators:start
```

This starts local emulators. Update `FirebaseBackendManager.swift` temporarily:

```swift
// For testing:
private let baseURL = "http://localhost:5001/YOUR-PROJECT-ID/us-central1"
```

## 📋 Testing Checklist

After deployment:

- [ ] Device registration works (check Firebase Console → Firestore → devices)
- [ ] Text transformation works
- [ ] Quota limits enforced (try 11th request)
- [ ] Rate limit works (try 11 requests in 1 minute)
- [ ] Signature verification works (app should work normally)

## 🔍 Monitoring

### Firebase Console
- **Functions**: View logs, errors, performance
- **Firestore**: Browse data, run queries
- **Usage**: Monitor costs

### Check Device Registration
1. Firebase Console → Firestore Database
2. Open `devices` collection
3. You should see documents with:
   - `deviceId` (UUID)
   - `publicKey` (Base64)
   - `tier` (free)
   - `dailyCount` (0)

### Check Usage Logs
1. Firebase Console → Firestore Database
2. Open `usageLogs` collection
3. Each transform creates a log entry

## ⚠️ Important Notes

1. **Cost Tracking**: Enable billing alerts in Firebase Console
2. **Security**: Public keys are stored, private keys stay in Keychain
3. **Testing**: Test with a few requests first before full deployment
4. **Backup**: Firebase auto-backs up Firestore data

## 🐛 Troubleshooting

### "Permission denied" on deploy
```bash
firebase login --reauth
```

### "Project not found"
```bash
firebase use --add
# Select your project
```

### Functions not deployed
Check `firebase.json` and `functions/package.json` are correct.

### Swift files not compiling
Make sure to add them to Xcode project target.

## 📞 Need Help?

Check:
1. Firebase Console → Functions → Logs
2. Xcode console for Swift errors
3. README.md for detailed documentation
