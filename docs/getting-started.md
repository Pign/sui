# Getting Started

## Prerequisites

| Requirement | Version | Notes |
|-------------|---------|-------|
| **Haxe** | 4.3+ | [haxe.org](https://haxe.org) |
| **hxcpp** | Latest | `haxelib install hxcpp` |
| **Xcode** | 15+ | Includes Swift compiler and SDKs |
| **xcodegen** | Latest | `brew install xcodegen` |

## Create a Project

```bash
haxelib run sui init MyApp
```

This scaffolds a ready-to-build project:

```
MyApp/
  src/
    MyApp.hx          # Your app entry point
  build.hxml           # Haxe build configuration
  project.yml          # Xcode project spec (xcodegen)
```

## Write Your App

Open `src/MyApp.hx`:

```haxe
import sui.App;
import sui.View;
import sui.ui.*;

class MyApp extends App {
    static function main() {}

    public function new() {
        super();
        appName = "MyApp";
        bundleIdentifier = "com.example.myapp";
    }

    override function body():View {
        return new VStack([
            new Text("Hello from Haxe!")
                .font(FontStyle.LargeTitle)
                .padding(),
            new Text("My first app")
                .foregroundColor(ColorValue.Secondary)
        ]);
    }
}
```

## Build and Run

```bash
# Build and run on macOS
haxelib run sui run macos

# Build and run on iOS simulator
haxelib run sui run ios

# Build and run on visionOS simulator
haxelib run sui run visionos
```

## What Happens Under the Hood

```
Haxe source (.hx)
    │
    ▼
Haxe compiler + hxcpp → C++ source
    │
    ▼
sui macro → Swift view code (SwiftUI)
    │
    ▼
xcodegen → Xcode project (.xcodeproj)
    │
    ▼
xcodebuild → Native app bundle (.app)
```

1. The Haxe compiler compiles your code to C++ via hxcpp
2. Build macros analyze your view hierarchy and generate Swift/SwiftUI code
3. xcodegen creates an Xcode project that combines the C++ and Swift sources
4. xcodebuild compiles everything into a native app bundle

## Next Steps

- **[Views](views/README.md)** &mdash; Explore the 22 built-in views
- **[State](state/README.md)** &mdash; Add state management to your app
- **[Examples](examples/README.md)** &mdash; Learn from annotated example apps
