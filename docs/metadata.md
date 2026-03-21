# Metadata

sui uses Haxe metadata annotations to control Swift code generation.

## @:bridge

Exposes a named static function to Swift via the C++ bridge. This is only needed when you want to call a specific function by name from Swift expressions (e.g., in `StateAction.CustomSwift`, `BridgeCall`, or `BridgeCallLoading`).

Most bridge interactions are **automatic** &mdash; button closures, `State.set()`, and lifecycle handlers work without any annotation.

**With @:bridge:**
```haxe
@:bridge
public static function greet(name:String):String {
    return 'Hello, $name!';
}

// Call by name from Swift expression:
new Button("Greet", null,
    StateAction.CustomSwift('result = HaxeBridgeC.greet("World")'))
```

**Without @:bridge (closure equivalent):**
```haxe
public static function greet(name:String):String {
    return 'Hello, $name!';
}

// Call via closure — bridged automatically:
new Button("Greet", () -> result.set(greet("World")))
```

**Generated Swift (with @:bridge):** `HaxeBridgeC.greet("World")`

**Requirements (for @:bridge):**
- Must be `public static`
- Parameters and return types must be basic types (`String`, `Int`, `Float`, `Bool`)

See [Bridge](bridge.md) for full details.

## @:swiftBinding

Marks a `ViewComponent` property as a `@Binding` in the generated Swift struct.

```haxe
class StarRating extends ViewComponent {
    @:swiftBinding public var rating:Int;
    // ...
}
```

**Generated Swift:**
```swift
struct StarRating: View {
    @Binding var rating: Int
    // ...
}
```

Use on both the property declaration and the constructor parameter:

```haxe
public function new(@:swiftLabel("rating") @:swiftBinding rating:String) {
    super();
}
```

See [Binding](state/binding.md) and [Components](components.md).

## @:swiftLabel

Controls the argument label in generated Swift function/initializer calls.

```haxe
public function new(
    @:swiftLabel("title") title:String,
    @:swiftLabel("subtitle") subtitle:String
) {
    super();
    this.title = title;
    this.subtitle = subtitle;
}
```

**Generated Swift:** `InfoCard(title: "Hello", subtitle: "World")`

Without `@:swiftLabel`, parameters use positional arguments.

## @:swiftName

Overrides the generated Swift name for a function or type.

```haxe
@:swiftName("calculateTotal")
public static function calc(items:Array<Int>):Int {
    // ...
}
```

## @:swiftView

Marks a class as generating a SwiftUI View struct. Applied automatically to `ViewComponent` subclasses but can be used explicitly for advanced control.

## Summary

| Metadata | Target | Purpose |
|----------|--------|---------|
| `@:bridge` | Static function | Expose named function to Swift (most bridging is automatic) |
| `@:swiftBinding` | Component property / constructor param | Generate `@Binding var` |
| `@:swiftLabel` | Constructor parameter | Set Swift argument label |
| `@:swiftName` | Function / type | Override generated Swift name |
| `@:swiftView` | Class | Mark as SwiftUI View struct |
