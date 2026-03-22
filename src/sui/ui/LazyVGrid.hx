package sui.ui;

import sui.View;

/**
    A lazy vertical grid. Maps to SwiftUI's `LazyVGrid`.

    ```haxe
    new LazyVGrid(3, 10, [
        new Text("Item 1"),
        new Text("Item 2"),
        new Text("Item 3"),
    ])
    ```

    The `columns` parameter sets the number of flexible columns.
**/
class LazyVGrid extends View {
    public var columns:Int;
    public var spacing:Float;

    public function new(columns:Int, ?spacing:Float, ?content:Array<View>) {
        super();
        this.viewType = "LazyVGrid";
        this.columns = columns;
        this.spacing = spacing != null ? spacing : 0;
    }
}
