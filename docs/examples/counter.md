# Counter

A counter app demonstrating state management with `State<T>`, `StateAction`, and `Text.withState`.

## Full Source

```haxe
import sui.App;
import sui.View;
import sui.ui.*;
import sui.state.State;
import sui.state.StateAction;

class CounterApp extends App {
    static function main() {}

    var count:State<Int>;

    public function new() {
        super();
        appName = "Counter";
        bundleIdentifier = "com.sui.counter";
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

## Walkthrough

### Declaring State

```haxe
var count:State<Int>;

// In constructor:
count = new State<Int>(0, "count");
```

`State<Int>` creates a reactive integer. The second argument `"count"` is the name used in generated Swift (`@State var count: Int = 0`).

### Displaying State

```haxe
Text.withState("Count: {count}")
```

`Text.withState` interpolates state variables. `{count}` becomes `\(count)` in Swift, so the text updates automatically when the state changes.

### Mutating State

```haxe
new Button("-", () -> count.set(count.get() - 1),
    StateAction.Decrement("count", 1))
```

Each button has two actions:

1. **Haxe closure** `() -> count.set(count.get() - 1)` &mdash; Runs on the Haxe/C++ side, bridged automatically (no `@:bridge` needed)
2. **StateAction** `StateAction.Decrement("count", 1)` &mdash; Generates Swift `count -= 1` for immediate UI update

Both are optional. Use `StateAction` for instant SwiftUI updates, closures for Haxe-side logic.

### Layout

```haxe
new HStack(null, 20, [...])
```

`null` alignment (default center), `20` points spacing between the two buttons.

## Run It

```bash
cd examples/counter
haxelib run sui run macos
```
