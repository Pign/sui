# State & Actions

## State\<T\>

`State<T>` declares a reactive state variable. It generates a `@State var` in Swift.

```haxe
var count:State<Int>;
var name:State<String>;
var items:State<Array<TodoItem>>;

public function new() {
    super();
    count = new State<Int>(0, "count");
    name = new State<String>("", "name");
    items = new State<Array<TodoItem>>([], "items");
}
```

### Supported Types

`State<T>` validates the type parameter at compile time. Only the following types are allowed:

| Type | Example | Valid? |
|------|---------|--------|
| `Int` | `State<Int>` | Yes |
| `Float` | `State<Float>` | Yes |
| `Bool` | `State<Bool>` | Yes |
| `String` | `State<String>` | Yes |
| `Array<BasicType>` | `State<Array<String>>` | Yes |
| `Array<Observable>` | `State<Array<TodoItem>>` | Yes, if `TodoItem` extends `Observable` |
| Other classes | `State<MyClass>` | Only if `MyClass` extends `Observable` |

Using an unsupported type (e.g. `State<Array<SomeClass>>` where `SomeClass` doesn't extend `Observable`) produces a compile-time error:

```
[SwiftGen] State<SomeClass> is not supported. Use a basic type (Int, Float, Bool, String),
an array of basic types, or a class extending Observable.
```

**Constructor:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `initialValue` | `T` | Starting value |
| `name` | `String` | Variable name in generated Swift |

**Methods:**

| Method | Description |
|--------|-------------|
| `.get()` | Read the current value (Haxe side) |
| `.set(newValue)` | Update the value and notify SwiftUI |

The `name` parameter is critical &mdash; it must match what you use in `StateAction`, `Text.withState`, and binding references.

## StateAction

`StateAction` provides declarative state mutations that generate inline Swift code.

### Arithmetic

```haxe
StateAction.Increment("count", 1)    // count += 1
StateAction.Decrement("count", 1)    // count -= 1
```

### Assignment

```haxe
StateAction.SetValue("name", "Haxe")  // name = "Haxe"
StateAction.Toggle("isOn")            // isOn.toggle()
```

### Array Operations

```haxe
StateAction.Append("items", newItem)   // items.append(newItem)
```

### Custom Swift

For complex mutations, write Swift directly:

```haxe
StateAction.CustomSwift('if !text.isEmpty { items.append(Item(title: text)); text = "" }')
```

### Bridge Calls

Call `@:bridge` functions from Swift:

```haxe
// Synchronous
StateAction.BridgeCall("result", "greet", "World")
// → result = HaxeBridgeC.greet("World")

// Async with loading state
StateAction.BridgeCallLoading("result", "Loading...", "fetchUrl", "https://example.com")
// → result = "Loading..."; Task { result = HaxeBridgeC.fetchUrl("https://example.com") }
```

## Text.withState

Displays state values in text. Use `{variableName}` for interpolation:

```haxe
Text.withState("Count: {count}")        // → Text("Count: \(count)")
Text.withState("{name}")                 // → Text("\(name)")
Text.withState("{rating} / 5")          // → Text("\(rating) / 5")
Text.withState("{todos[i].title}")      // → Text("\(todos[i].title)")
```

## Putting It Together

```haxe
class CounterApp extends App {
    var count:State<Int>;

    public function new() {
        super();
        appName = "Counter";
        bundleIdentifier = "com.example.counter";
        count = new State<Int>(0, "count");
    }

    override function body():View {
        return new VStack([
            Text.withState("Count: {count}")
                .font(FontStyle.Title)
                .padding(),
            new HStack(null, 20, [
                new Button("-", () -> count.set(count.get() - 1),
                    StateAction.Decrement("count", 1)),
                new Button("+", () -> count.set(count.get() + 1),
                    StateAction.Increment("count", 1))
            ])
        ]);
    }
}
```

The `StateAction` handles the Swift-side state mutation for immediate UI updates. The closure runs the same logic on the Haxe/C++ side. Both are optional &mdash; use whichever fits your use case.
