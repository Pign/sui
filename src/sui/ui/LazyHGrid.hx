package sui.ui;

import sui.View;

/**
    A lazy horizontal grid. Maps to SwiftUI's `LazyHGrid`.

    ```haxe
    new LazyHGrid(2, 10, [
        new Text("Item 1"),
        new Text("Item 2"),
    ])
    ```

    The `rows` parameter sets the number of flexible rows.
**/
class LazyHGrid extends View {
    public var rows:Int;
    public var spacing:Float;

    public function new(rows:Int, ?spacing:Float, ?content:Array<View>) {
        super();
        this.viewType = "LazyHGrid";
        this.rows = rows;
        this.spacing = spacing != null ? spacing : 0;
    }
}
