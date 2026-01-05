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

### AI Provider Integration

Currently supports OpenAI with an extensible architecture for future providers.

- **Dynamic Model Selection**: Choose from available models
- **Connection Status**: Visual indicator of API connection
- **Secure Storage**: API key stored in macOS Keychain

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
| Text too long (>10,000 chars) | Notification: "Text too long" |
| API not configured | Alert with link to Settings |
| API error | Notification with error message |
| Network timeout (10s) | Notification: "An error occurred" |

## Settings

### OpenAI Configuration

- API Key input (secure, stored in Keychain)
- Test button to validate the key
- Model picker (fetched dynamically from API)
- Connection status indicator

### Keyboard Shortcut

- Record new shortcut button
- Current shortcut display

### Preferences

- Launch at login toggle (uses SMAppService)



