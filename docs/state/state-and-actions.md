# State & Actions

## @:state

`@:state` declares a reactive state variable. It generates a `@State var` in Swift.

```haxe
@:state var count:Int = 0;
@:state var name:String = "";
@:state var items:Array<TodoItem> = [];
```

No constructor initialization needed &mdash; the default value is specified inline.

### Supported Types

`@:state` validates the type at compile time. Only the following types are allowed:

| Type | Example | Valid? |
|------|---------|--------|
| `Int` | `@:state var x:Int = 0` | Yes |
| `Float` | `@:state var x:Float = 0.0` | Yes |
| `Bool` | `@:state var x:Bool = false` | Yes |
| `String` | `@:state var x:String = ""` | Yes |
| `Array<BasicType>` | `@:state var x:Array<String> = []` | Yes |
| `Array<Observable>` | `@:state var x:Array<TodoItem> = []` | Yes, if `TodoItem` extends `Observable` |
| Other classes | `@:state var x:MyClass` | Only if `MyClass` extends `Observable` |

Using an unsupported type (e.g. `@:state var x:Array<SomeClass>` where `SomeClass` doesn't extend `Observable`) produces a compile-time error:

```
[SwiftGen] State type SomeClass is not supported. Use a basic type (Int, Float, Bool, String),
an array of basic types, or a class extending Observable.
```

**Access:**

| Syntax | Description |
|--------|-------------|
| `.value` | Read the current value (Haxe side) |
| `.value = newValue` | Update the value and notify SwiftUI |

The variable name is used directly in `StateAction`, `Text.withState`, and binding references.

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

Call `@:expose` functions from Swift:

```haxe
// Synchronous
StateAction.BridgeCall("result", "greet", "World")
// → result = HaxeBridgeC.greet("World")

// Async with loading state
StateAction.BridgeCallLoading("result", "Loading...", "fetchUrl", "https://example.com")
// → result = "Loading..."; Task { result = HaxeBridgeC.fetchUrl("https://example.com") }

// Animated — wraps any action in withAnimation
StateAction.Animated(StateAction.Toggle("showDetail"), "spring")
// → withAnimation(.spring) { showDetail.toggle() }

StateAction.Animated(StateAction.Increment("count", 1), "easeInOut")
// → withAnimation(.easeInOut) { count += 1 }
```

**Animation curves:** `"default"`, `"easeIn"`, `"easeOut"`, `"easeInOut"`, `"spring"`, `"linear"`, `"bouncy"`

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
    @:state var count:Int = 0;

    public function new() {
        super();
        appName = "Counter";
        bundleIdentifier = "com.example.counter";
    }

    override function body():View {
        return new VStack([
            Text.withState("Count: {count}")
                .font(FontStyle.Title)
                .padding(),
            new HStack(null, 20, [
                new Button("-", () -> count.value = count.value - 1,
                    StateAction.Decrement("count", 1)),
                new Button("+", () -> count.value = count.value + 1,
                    StateAction.Increment("count", 1))
            ])
        ]);
    }
}
```

The `StateAction` handles the Swift-side state mutation for immediate UI updates. The closure runs the same logic on the Haxe/C++ side. Both are optional &mdash; use whichever fits your use case.
