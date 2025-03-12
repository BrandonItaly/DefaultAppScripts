# macOS Default App Setter Scripts

Simple Swift scripts to set default mail and browser applications on macOS.

## Prerequisites

### Terminal Accessibility Permissions
The scripts use AppleScript automation to handle system prompts. Terminal.app needs accessibility permissions:

1. Go to System Settings > Privacy & Security > Accessibility
2. Click the '+' button
3. Navigate to and select Terminal.app
4. Enable the permission

## Installation

1. Clone or download the scripts
2. Make them executable:
```bash
chmod +x SetDefaultMailApp.swift
chmod +x SetDefaultBrowser.swift
```

## Usage

### Setting Default Mail App
```bash
./SetDefaultMailApp.swift [mail-app]
```

Supported mail apps:
- `mail` - Apple Mail
- `outlook` - Microsoft Outlook

Example:
```bash
./SetDefaultMailApp.swift mail
```

### Setting Default Browser
```bash
./SetDefaultBrowser.swift [browser]
```

Supported browsers:
- `safari` - Safari
- `chrome` - Google Chrome
- `firefox` - Firefox
- `edge` - Microsoft Edge

Example:
```bash
./SetDefaultBrowser.swift chrome
```

## Notes

- Scripts require macOS and Swift runtime (pre-installed on macOS)
- The scripts will automatically handle system prompts if Terminal has proper permissions
- Mail.app is searched for in `/System/Applications`
- Third-party apps are searched in `/Applications` and `~/Applications`