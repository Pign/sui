# Hello World

The simplest sui app. Displays text with basic styling.

## Full Source

```haxe
import sui.App;
import sui.View;
import sui.ui.*;

class HelloApp extends App {
    static function main() {}

    public function new() {
        super();
        appName = "HelloHaxe";
        bundleIdentifier = "com.sui.helloworld";
    }

    override function body():View {
        return new VStack([
            new Text("Hello from Haxe!")
                .font(FontStyle.LargeTitle)
                .padding(),
            new Text("Running on macOS")
                .foregroundColor(ColorValue.Secondary),
            new Spacer(),
            new Text("Built with sui")
                .font(FontStyle.Caption)
                .foregroundColor(ColorValue.Gray)
        ]);
    }
}
```

## Walkthrough

### App Setup

```haxe
class HelloApp extends App {
    static function main() {}
```

Every sui app extends `App`. The empty `static function main() {}` is required by Haxe as the entry point &mdash; the framework handles actual initialization.

### Configuration

```haxe
public function new() {
    super();
    appName = "HelloHaxe";
    bundleIdentifier = "com.sui.helloworld";
}
```

- `appName` &mdash; Display name of the app
- `bundleIdentifier` &mdash; Unique identifier for the app bundle (reverse domain format)

### View Hierarchy

```haxe
override function body():View {
    return new VStack([...]);
}
```

Override `body()` to define the view tree. This returns a `VStack` with three `Text` views and a `Spacer`.

### Modifiers

```haxe
new Text("Hello from Haxe!")
    .font(FontStyle.LargeTitle)    // Large title font
    .padding(),                     // System default padding
```

Modifiers chain on any view. Each returns the view, so you can keep chaining.

## Run It

```bash
cd examples/hello-world
haxelib run sui run macos
```
