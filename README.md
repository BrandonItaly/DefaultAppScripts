# macOS Default App Setter Scripts

Simple scripts to set default mail and browser applications on macOS.

## Option 1: Pre-compiled Executables (Recommended)

Pre-compiled executables work on any macOS device without requiring developer tools.

### Installation

1. Download the pre-compiled binaries from the releases section
2. Make them executable if needed:
```bash
chmod +x bin/SetDefaultApp
```

### Usage

#### Combined App (Recommended)
```bash
./bin/SetDefaultApp [option] [app]
```

Options:
- `browser` - Set default web browser
- `mail` - Set default mail application

Examples:
```bash
./bin/SetDefaultApp browser chrome
./bin/SetDefaultApp mail outlook
```

#### Individual Executables (Legacy)
If you prefer the separate executables, they are still available:

Setting Default Mail App:
```bash
./bin/SetDefaultMailApp [mail-app]
```

Setting Default Browser:
```bash
./bin/SetDefaultBrowser [browser]
```

### Supported Applications

Supported browsers:
- `safari` - Safari
- `chrome` - Google Chrome
- `firefox` - Firefox
- `edge` - Microsoft Edge

Supported mail apps:
- `mail` - Apple Mail
- `outlook` - Microsoft Outlook

## Option 2: Swift Source Files (For Developers)

### Prerequisites

- Xcode Command Line Tools installed

### Installation

1. Clone or download the Swift scripts
2. Make them executable:
```bash
chmod +x SetDefaultApp.swift
```

### Usage

```bash
./SetDefaultApp.swift browser chrome
./SetDefaultApp.swift mail outlook
```

### Compiling to Standalone Executables

If you have the developer tools and want to distribute binaries to users without them:

1. Make the compile script executable:
```bash
chmod +x compile.sh
```

2. Run the compile script:
```bash
./compile.sh
```

3. Distribute the executables from the `bin` directory

## Terminal Accessibility Permissions

These scripts use system automation to handle prompts. Terminal.app needs accessibility permissions:

1. Go to System Settings > Privacy & Security > Accessibility
2. Click the '+' button
3. Navigate to and select Terminal.app
4. Enable the permission

## Notes

- Pre-compiled executables work without developer tools
- The scripts will automatically handle system prompts if Terminal has proper permissions
- Mail.app is searched for in `/System/Applications`
- Third-party apps are searched in `/Applications` and `~/Applications`