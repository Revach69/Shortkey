# Spellify Features

## Core Features

### Menu Bar Integration

Spellify runs as a menu bar app with no dock icon, staying out of your way until you need it.

- **Status Icon**: Magic wand icon (`wand.and.stars`) in the menu bar
- **Popover**: Click the icon to access actions, settings, and status
- **No Dock Icon**: Uses `LSUIElement` to hide from the dock

### Global Keyboard Shortcut

Trigger Spellify from any application using a customizable keyboard shortcut.

- **Default Shortcut**: ⌘⇧S (Command + Shift + S)
- **Customizable**: Record a new shortcut in Settings
- **Global**: Works in any app that supports text selection

### Action Picker

When triggered, a floating panel appears near your cursor with available actions.

- **Keyboard Navigation**: Use arrow keys to navigate, Enter to select
- **Mouse Support**: Click to select an action
- **Escape to Cancel**: Press Esc to dismiss without action

### Customizable Actions

Create, edit, and delete your own text transformation actions.

- **Name**: Display name shown in the picker
- **Prompt**: The instruction sent to the AI along with your text
- **Icon**: Choose from SF Symbols
- **Pro Badge**: Mark actions as Pro-only

### Secure Backend Integration

All transformations are processed through a secure Firebase backend.

- **Crypto Signing**: P256 signatures prevent device ID spoofing
- **Rate Limiting**: 10 requests per minute (prevents abuse)
- **Quota Management**: 10/day free tier, 1000/day pro tier
- **Secure Storage**: Private keys in Keychain, never leave device
- **No API Key Required**: Users don't need their own OpenAI key

### Subscription Management

StoreKit 2 integration for Pro features.

- **Free Tier**: 10 transformations/day, 500 characters max
- **Pro Tier**: 1000 transformations/day, 2000 characters max
- **Auto-Renewable**: Monthly or annual subscriptions
- **Receipt Validation**: Secure server-side validation

## User Flow

```
1. Select text in any app
         ↓
2. Press keyboard shortcut (⌘⇧S)
         ↓
3. Action picker appears near cursor
         ↓
4. Select an action (keyboard or mouse)
         ↓
5. Notification: "Spellifying your text..."
         ↓
6. AI processes the text
         ↓
7. Selected text is replaced with result
         ↓
8. Notification: "Done!"
```

## Error Handling

| Scenario | Behavior |
|----------|----------|
| No text selected | Notification: "Select some text first" |
| Text too long (>500 free, >2000 pro) | Notification: "Text too long" |
| Daily quota exceeded | Notification: "Daily limit reached" |
| Rate limit exceeded | Notification: "Too many requests, try again later" |
| Backend error | Notification with error message |
| Network timeout | Notification: "Connection error" |
| Invalid signature | Backend rejects request (security) |

## Settings

### Subscription Section

- Current tier display (Free/Pro)
- Usage stats (today's usage, daily limit)
- Subscribe button (opens paywall)
- Restore purchases button

### Keyboard Shortcut

- Record new shortcut button
- Current shortcut display

### Preferences

- Launch at login toggle (uses SMAppService)

### Advanced (Optional)

- Direct OpenAI mode (legacy, requires own API key)
- API Key input (secure, stored in Keychain)
- Model picker
- Connection status indicator



