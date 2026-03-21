# Text & Labels

## Text

Displays static text content.

```haxe
new Text("Hello from Haxe!")
    .font(FontStyle.LargeTitle)
    .foregroundColor(ColorValue.Blue)
    .bold()
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `text` | `String` | The text to display |

Common modifiers: `.font()`, `.foregroundColor()`, `.bold()`, `.italic()`, `.multilineTextAlignment()`, `.lineLimit()`, `.padding()`

## Text.withState

Displays dynamic text that reads from `@State` variables. Use `{variableName}` for interpolation.

```haxe
Text.withState("Count: {count}")
    .font(FontStyle.Title)
```

This generates Swift code like `Text("Count: \(count)")`, so the text updates automatically when the state changes.

You can reference nested properties and array elements:

```haxe
Text.withState("{todos[i].title}")    // Array element property
Text.withState("{result}")            // Simple state variable
Text.withState("{rating} / 5")       // State with surrounding text
```

## Label

Displays an SF Symbol icon alongside text.

```haxe
new Label("Settings", "gear")
new Label("Favorites", "star.fill")
new Label("Search", "magnifyingglass")
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | `String` | Label text |
| `systemImage` | `String` | SF Symbols icon name |

Browse SF Symbols at [developer.apple.com/sf-symbols](https://developer.apple.com/sf-symbols/).

## Image

Displays images from the asset catalog or SF Symbols.

```haxe
// From asset catalog
new Image("myPhoto")

// SF Symbols (system icons)
Image.systemImage("star.fill")
    .foregroundColor(ColorValue.Yellow)

// Resizable image
new Image("banner").resizable()
    .frame(null, 200)
```

**Constructors:**

| Constructor | Parameters | Description |
|-------------|-----------|-------------|
| `new Image(name)` | `name: String` | Asset catalog image |
| `Image.systemImage(name)` | `systemName: String` | SF Symbol |

**Methods:**

| Method | Returns | Description |
|--------|---------|-------------|
| `.resizable()` | `Image` | Makes the image resizable |
