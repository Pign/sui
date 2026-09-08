# Todo App

A more complex app with Observable data models, ForEach iteration, text input, and array mutations.

## Full Source

```haxe
import sui.App;
import sui.View;
import sui.ui.*;
import sui.state.State;
import sui.state.Observable;

class TodoItem extends Observable {
    public var title:String;
    public var completed:Bool;

    public function new(title:String = "", completed:Bool = false) {
        super();
        this.title = title;
        this.completed = completed;
    }
}

class TodoApp extends App {
    static function main() {}

    var todos:State<Array<TodoItem>>;
    var newItemText:State<String>;

    public function new() {
        super();
        appName = "TodoList";
        bundleIdentifier = "com.sui.todoapp";
        todos = new State<Array<TodoItem>>([], "todos");
        newItemText = new State<String>("", "newItemText");
    }

    override function body():View {
        return new NavigationStack(
            new VStack([
                new HStack(null, 8, [
                    new TextField("New item...", "newItemText")
                        .textFieldStyle(TextFieldStyleValue.RoundedBorder),
                    new Button("Add", () -> {
                        // newItemText is fresh here: the TextField's
                        // Swift binding writes back to the Haxe mirror.
                        if (newItemText != "") {
                            todos = todos.concat([new TodoItem(newItemText, false)]);
                            newItemText = "";
                        }
                    })
                ]).padding(),
                new List([
                    ForEach.byIndex(todos, i ->
                        new HStack([
                            Text.bind(todos[i].title)
                                .font(FontStyle.Body),
                            new Spacer(),
                            new Button("Done", () -> {
                                todos[i].completed = !todos[i].completed;
                                todos = todos; // re-assign to notify SwiftUI
                            })
                        ])
                    )
                ])
            ]).navigationTitle("Todo List")
        );
    }
}
```

## Walkthrough

### Observable Data Model

```haxe
class TodoItem extends Observable {
    public var title:String;
    public var completed:Bool;
    // ...
}
```

`TodoItem` extends `Observable`, so it generates a Swift struct that SwiftUI can observe. Properties become struct fields.

### State Arrays

```haxe
todos = new State<Array<TodoItem>>([], "todos");
```

`State` can hold arrays of Observable objects. SwiftUI renders the list and updates when the array is re-assigned.

### Text Input + Add Button

```haxe
new TextField("New item...", "newItemText")
    .textFieldStyle(TextFieldStyleValue.RoundedBorder),
new Button("Add", () -> {
    if (newItemText != "") {
        todos = todos.concat([new TodoItem(newItemText, false)]);
        newItemText = "";
    }
})
```

The TextField binds to `newItemText`. The button's closure reads `newItemText`
&mdash; which is always current, because the TextField's SwiftUI binding writes back into
the Haxe mirror via `didSet` (see [The Bridge](../bridge.md#write-back-swift--haxe)).
It appends a new `TodoItem` and clears the field, all in plain Haxe.

### ForEach Iteration

```haxe
ForEach.byIndex(todos, i ->
    new HStack([
        Text.bind(todos[i].title),
        // ...
    ])
)
```

`ForEach.byIndex` iterates the `todos` array by index. The lambda receives `i:Int`, so `todos[i].title` typechecks in Haxe and the macro rewrites it to `appState.todos[i].title` in the emitted Swift.

### Row Action Closures

```haxe
new Button("Done", () -> {
    todos[i].completed = !todos[i].completed;
    todos = todos; // re-assign to notify SwiftUI
})
```

Inside a `ForEach` row, the action closure may reference the iteration parameter `i`.
The macro lifts it into an indexed builder, and Swift dispatches it with the live loop
index (`HaxeBridgeC.invokeIndexedAction`). A row closure can only reference iteration
parameters, `@:state` fields, App members and statics &mdash; not locals of the enclosing
method. See [Lists & Iteration](../views/lists-and-iteration.md).

## Run It

```bash
cd examples/todo-app
haxelib run sui run macos
```
