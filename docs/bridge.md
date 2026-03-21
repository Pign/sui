# Bridge

sui includes a **transparent bridge** between Swift and Haxe/C++. Most of the time, you just write normal Haxe code &mdash; closures, `State.set()`, lifecycle handlers &mdash; and the framework handles the bridging automatically. No annotations required.

## Transparent Bridge (Automatic)

The most common bridge interactions require **zero configuration**. The framework detects closures and state usage in your view tree and wires up the C++ bridge for you.

### Button Closures

Pass any Haxe function or closure to a Button. It runs via the bridge automatically:

```haxe
new Button("Say Hello", () -> {
    myState.set("Hello from Haxe! Time: " + Date.now().toString());
})
```

Under the hood, the framework registers the closure in an action registry and generates Swift code that calls `HaxeBridgeC.invokeAction(id)`. You never see this &mdash; it just works.

### State.set()

When you call `state.set()` from Haxe, the update flows back to SwiftUI automatically:

```
Haxe: state.set(newValue)
    │
    ▼
C++ bridge: update stored value, notify Swift callback
    │
    ▼
Swift: @State property update
    │
    ▼
SwiftUI: automatic re-render
```

No annotation needed. Any `State<T>` variable participates in this flow.

### Lifecycle Closures

`onAppear`, `onDisappear`, and `task` closures also bridge transparently:

```haxe
new VStack([...])
    .task(() -> {
        status.set("Loading...");
        var http = new haxe.Http("https://example.com");
        http.onData = (d) -> data.set(d);
        http.request(false);
    })
    .onDisappear(() -> trace("View disappeared"))
```

These closures run in Haxe/C++ and can call `state.set()` to push updates back to SwiftUI.

## @:bridge (Explicit Named Exports)

Use `@:bridge` when you want to expose a **named static function** to Swift, so you can call it from `StateAction.CustomSwift`, `BridgeCall`, or `BridgeCallLoading`:

**With @:bridge:**
```haxe
@:bridge
public static function greet(name:String):String {
    return 'Hello, $name! (from Haxe/C++)';
}

// Called by name from Swift:
new Button("Greet", null,
    StateAction.CustomSwift('result = HaxeBridgeC.greet("World")'))
```

**Without @:bridge (closure equivalent):**
```haxe
// No annotation — just use a closure
new Button("Greet", () -> {
    result.set('Hello, World! (from Haxe/C++)');
})
```

The `@:bridge` version is useful when you need the return value in a Swift expression, or when you want to reuse the same function from multiple call sites. The closure version is simpler when you just need to run Haxe logic and update state.

### When to Use @:bridge

Use `@:bridge` when you need to:
- Call a Haxe function from a `StateAction.CustomSwift` expression
- Use `StateAction.BridgeCall` or `BridgeCallLoading`
- Get a return value back from Haxe into a Swift expression

You do **not** need `@:bridge` for:
- Button closures (automatic)
- `State.set()` updates (automatic)
- Lifecycle closures like `onAppear`, `task`, `onDisappear` (automatic)

## Calling @:bridge Functions

### From StateAction.CustomSwift

```haxe
// With @:bridge — calls greet() by name in Swift
new Button("Greet", null,
    StateAction.CustomSwift('result = HaxeBridgeC.greet("World")'))

// Without @:bridge — same logic via closure
new Button("Greet", () -> {
    result.set('Hello, World! (from Haxe/C++)');
})
```

### With BridgeCall

```haxe
// Single argument
new Button("Greet", null,
    StateAction.BridgeCall("result", "greet", "World"))

// Multiple arguments
new Button("Login", null,
    StateAction.BridgeCall("result", "doLogin", ["https://api.example.com", "user@email.com", "pass123"]))

// Without @:bridge — same logic via closure
new Button("Greet", () -> result.set(greet("World")))
```

### Async with BridgeCallLoading

For slow operations, show a loading state while the bridge call runs:

```haxe
// Single argument
new Button("Fetch Data", null,
    StateAction.BridgeCallLoading("result", "Loading...", "fetchUrl", "https://example.com"))

// Multiple arguments
new Button("Login", null,
    StateAction.BridgeCallLoading("result", "Logging in...", "doLogin", ["https://api.example.com", "user@email.com", "pass123"]))
```

The `BridgeCallLoading` version sets the loading text immediately, then runs the bridge call in a background task and updates the state when done.

## How It Works

```
┌─────────────────────────────────────────────────┐
│  Transparent (automatic)                        │
│                                                 │
│  Button closure ──→ action registry ──→ C++     │
│  State.set()    ──→ callback        ──→ Swift   │
│  onAppear/task  ──→ action registry ──→ C++     │
├─────────────────────────────────────────────────┤
│  @:bridge (explicit)                            │
│                                                 │
│  Swift code ──→ HaxeBridgeC.fn() ──→ C++ ──→   │
│  Haxe static function ──→ return value ──→ Swift│
└─────────────────────────────────────────────────┘
```

The transparent bridge handles closures and state synchronization without any annotations. `@:bridge` adds named entry points for when Swift code needs to call specific Haxe functions by name and get return values.

## Full Example

```haxe
class BridgeApp extends App {
    var result:State<String>;

    public function new() {
        super();
        appName = "BridgeDemo";
        bundleIdentifier = "com.sui.bridgedemo";
        result = new State<String>("Press a button!", "result");
    }

    // Explicit bridge: callable by name from Swift as HaxeBridgeC.greet()
    @:bridge
    public static function greet(name:String):String {
        return 'Hello, $name! (from Haxe/C++)';
    }

    @:bridge
    public static function fibonacci(n:Int):Int {
        if (n <= 1) return n;
        return fibonacci(n - 1) + fibonacci(n - 2);
    }

    override function body():View {
        return new VStack(null, 20, [
            new Text("Haxe <-> Swift Bridge")
                .font(FontStyle.LargeTitle),
            Text.withState("{result}")
                .font(FontStyle.Title2)
                .padding(),

            // Uses @:bridge (named function, return value)
            new Button("Greet from Haxe", null,
                StateAction.CustomSwift('result = HaxeBridgeC.greet("World")')),

            // Uses transparent bridge (closure, no annotation needed)
            new Button("Hello via closure", () -> {
                result.set("Hello from a closure!");
            }),
        ]);
    }
}
```

## Multi-State Updates with State.setByName

When a bridge function needs to update multiple state variables, use `State.setByName()` from a closure:

```haxe
new Button("Login", () -> {
    State.setByName("status", "Logging in...");
    var result = doLogin(email.get(), password.get());
    State.setByName("userName", result.name);
    State.setByName("mailboxCount", Std.string(result.mailboxes));
    State.setByName("isLoggedIn", "true");
    State.setByName("status", "Welcome!");
})
```

Each `setByName` call immediately pushes the value to SwiftUI. This is the same mechanism that `State.set()` uses internally, but lets you target any state variable by name without needing a reference to the `State<T>` instance.

## Key Points

- **Most bridging is automatic** &mdash; closures and `State.set()` just work
- `@:bridge` is only needed for named function exports callable from Swift expressions
- `@:bridge` functions must be `public static`
- They can accept and return basic types (`String`, `Int`, `Float`, `Bool`)
- The generated bridge uses `HaxeBridgeC.functionName()` in Swift
- Use `BridgeCallLoading` for operations that take time
- Use `State.setByName()` to update multiple states from a single closure
