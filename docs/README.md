# Spellify

A macOS menu bar app that helps you transform text using AI, anywhere on your Mac.

## Overview

Spellify is a lightweight utility that lives in your menu bar. With a simple keyboard shortcut, you can transform any selected text using customizable AI-powered actions like fixing grammar, translating to another language, or making text more formal.

## Features

- **Menu Bar App**: Runs in the background, always accessible from the menu bar
- **Global Keyboard Shortcut**: Trigger Spellify from any app with a customizable shortcut (default: ⌘⇧S)
- **Customizable Actions**: Create your own text transformation prompts
- **OpenAI Integration**: Powered by OpenAI's GPT models
- **Clipboard Preservation**: Your clipboard content is preserved after each transformation
- **Native macOS Experience**: Built with SwiftUI following Apple's design guidelines

## How to Use

1. **Install the app** and grant Accessibility permissions when prompted
2. **Configure your OpenAI API key** via Configure... in the menu bar popover
3. **Select any text** in any application
4. **Press the keyboard shortcut** (default: ⌘⇧S)
5. **Choose an action** from the picker that appears
6. **Done!** The selected text is replaced with the transformed result

## Default Actions

| Action | Description |
|--------|-------------|
| Fix Grammar | Fixes grammar and spelling errors while maintaining tone |
| Translate to Spanish | Translates text to Spanish |

## Requirements

- macOS 13.0 (Ventura) or later
- OpenAI API key

## Privacy

- Your API key is stored securely in the macOS Keychain
- Text is sent to OpenAI's API for processing
- No data is stored or logged by Spellify

## Building from Source

1. Clone the repository
2. Open `Spellify.xcodeproj` in Xcode
3. Build and run (⌘R)

## License

MIT License - see LICENSE file for details


