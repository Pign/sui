package sui.ui;

import sui.View;

/**
    Iterates over a state array and generates a view for each element.
    Maps to SwiftUI's `ForEach`.

    Usage:
    ```haxe
    // Typed State reference (preferred):
    new ForEach(todos, "i",
        new Text("Item")
    )

    // String name (still supported for backward compat):
    new ForEach("todos", "i",
        new Text("Item")
    )
    ```

    Generates:
    ```swift
    ForEach(0..<todos.count, id: \.self) { i in
        Text("Item")
    }
    ```

    Use `Text.withState("{todos[i].title}")` in the child view
    to reference properties of each item.
**/
class ForEach extends View {
    public var arrayName:Dynamic;
    public var itemName:String;
    public var itemView:View;

    /**
        @param arrayName State<Array<T>> field reference or string name of the @State array variable
        @param itemName  Name for the iteration variable in generated Swift
        @param itemView  View to render for each item (use {arrayName[itemName].prop} for interpolation)
    **/
    public function new(arrayName:Dynamic, itemName:String, itemView:View) {
        super();
        this.viewType = "ForEach";
        this.arrayName = arrayName;
        this.itemName = itemName;
        this.itemView = itemView;
        this.children = [itemView];
    }
}
