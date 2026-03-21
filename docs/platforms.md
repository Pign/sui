# Platforms

sui targets all major Apple platforms from a single Haxe codebase.

## Supported Platforms

| Platform | CLI argument | Minimum OS | Run target |
|----------|-------------|------------|------------|
| **macOS** | `macos` | macOS 14+ | Direct |
| **iOS** | `ios` | iOS 17+ | Simulator (default) or device |
| **iPadOS** | `ios` | iPadOS 17+ | Simulator or device |
| **visionOS** | `visionos` | visionOS 1+ | Simulator or device |

## macOS

The default platform. Apps run directly on your Mac.

```bash
haxelib run sui run macos
```

## iOS / iPadOS

By default, builds run on the iOS Simulator.

```bash
# Run on simulator
haxelib run sui run ios

# Run on connected device
haxelib run sui run ios --device

# Target a specific device
haxelib run sui run ios --device="iPhone 15 Pro"
```

### Device Deployment

Running on a real device requires:

1. An Apple Developer account (free or paid)
2. A signing identity configured in Xcode
3. The device connected via USB or on the same network

Use `--device` to target a connected device.

## visionOS

Targets Apple Vision Pro. Uses the visionOS Simulator by default.

```bash
# Run on simulator
haxelib run sui run visionos

# Run on device
haxelib run sui run visionos --device
```

## Cross-Platform Code

Your Haxe code runs on all platforms without changes. SwiftUI handles platform-appropriate rendering automatically:

- `NavigationSplitView` shows sidebar on iPad, adapts on iPhone
- `TabView` renders as a tab bar on iOS, sidebar on macOS
- `Form` uses grouped style on iOS, standard on macOS

## Opening in Xcode

For platform-specific configuration, code signing, or debugging:

```bash
haxelib run sui xcode ios
```

This generates the Xcode project and opens it. From Xcode you can configure signing, select simulators, and use the debugger.
