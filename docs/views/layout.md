# Layout Views

## VStack

Arranges children vertically.

```haxe
new VStack([
    new Text("First"),
    new Text("Second"),
    new Text("Third")
])
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `alignment` | `HorizontalAlignment` | `null` (Center) | `.Leading`, `.Center`, `.Trailing` |
| `spacing` | `Float` | `null` (system default) | Space between children |
| `content` | `Array<View>` | required | Child views |

With alignment and spacing:

```haxe
new VStack(HorizontalAlignment.Leading, 12, [
    new Text("Left-aligned"),
    new Text("With 12pt spacing")
])
```

## HStack

Arranges children horizontally.

```haxe
new HStack([
    new Text("Left"),
    new Spacer(),
    new Text("Right")
])
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `alignment` | `VerticalAlignment` | `null` (Center) | `.Top`, `.Center`, `.Bottom`, `.FirstTextBaseline`, `.LastTextBaseline` |
| `spacing` | `Float` | `null` | Space between children |
| `content` | `Array<View>` | required | Child views |

```haxe
new HStack(null, 20, [
    new Button("-", null, StateAction.Decrement("count", 1)),
    new Button("+", null, StateAction.Increment("count", 1))
])
```

## ZStack

Overlays children on top of each other.

```haxe
new ZStack([
    new Text("Background").font(FontStyle.LargeTitle).opacity(0.1),
    new Text("Foreground")
])
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `alignment` | `Alignment` | `null` (Center) | Position within the stack |
| `content` | `Array<View>` | required | Child views (last on top) |

## Spacer

Expands to fill available space.

```haxe
new VStack([
    new Text("Top"),
    new Spacer(),          // pushes "Bottom" to the bottom
    new Text("Bottom")
])
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `minLength` | `Float` | `null` | Minimum size |

## ScrollView

Wraps content in a scrollable container.

```haxe
new ScrollView([
    new VStack([
        new Text("Line 1"),
        new Text("Line 2"),
        // ... many lines
    ])
])
```

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `content` | `Array<View>` | required | Scrollable child views |

## ConditionalView

Conditionally renders views based on state. Maps to SwiftUI's `if/else` in a `@ViewBuilder`.

### Boolean condition

Show one view when a boolean state is true, another when false:

```haxe
new ConditionalView("isLoggedIn",
    buildMainView(),     // shown when true
    buildLoginView()     // shown when false
)
```

The false branch is optional:

```haxe
new ConditionalView("showBanner", new Text("Welcome!"))
```

### String equality

Match a string state against a specific value:

```haxe
new ConditionalView("currentScreen", "login",
    buildLoginView(),     // shown when currentScreen == "login"
    buildDefaultView()    // shown otherwise
)
```

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `stateName` | `String` | Name of the state variable to check |
| `trueView` | `View` | View shown when condition is true (boolean) or matched (string) |
| `falseView` | `View` | *(optional)* View shown otherwise |
| `matchValue` | `String` | *(string mode only)* Value to compare against |

### Animated transitions

Add `.transition()` to child views for enter/exit animations, and use `StateAction.Animated` to animate the toggle:

```haxe
new Button("Toggle", null,
    StateAction.Animated(StateAction.Toggle("showDetail"), "spring"))

new ConditionalView("showDetail",
    detailView.transition("slide"),
    placeholder.transition("opacity")
)
```

**Transition styles:** `"slide"`, `"opacity"`, `"scale"`, `"move"`, `"push"`
