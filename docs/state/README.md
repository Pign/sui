# State Management

sui provides a reactive state system that maps to SwiftUI's state management.

## Overview

| Concept | Haxe | SwiftUI | Purpose |
|---------|------|---------|---------|
| `State<T>` | `new State<Int>(0, "count")` | `@State var count = 0` | View-local mutable state |
| `StateAction` | `StateAction.Increment("count", 1)` | `count += 1` | Declarative state mutations |
| `Binding` | `Binding.fromState(state)` | `@Binding var value` | Two-way reference to parent state |
| `Observable` | `extends Observable` | `@Observable class` | Shared data models |
| `Text.withState` | `Text.withState("{count}")` | `Text("\(count)")` | Display state values |

## How It Works

1. You declare `State<T>` variables in your App class
2. The framework generates matching `@State var` properties in Swift
3. Mutations happen through `StateAction` (in Swift) or `State.set()` (in Haxe via bridge)
4. SwiftUI automatically re-renders when state changes

## Quick Example

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
                .font(FontStyle.Title),
            new Button("+1", null, StateAction.Increment("count", 1))
        ]);
    }
}
```

## Pages

- **[State & Actions](state/state-and-actions.md)** &mdash; `State<T>`, `StateAction`, `Text.withState`
- **[Binding](state/binding.md)** &mdash; `Binding`, `@:swiftBinding`, component binding
- **[Observable](state/observable.md)** &mdash; `Observable` classes and shared data models
