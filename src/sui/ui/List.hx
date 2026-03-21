package sui.ui;

import sui.View;

/**
    A container that presents rows of data in a single column.
    Maps to SwiftUI's `List`.
**/
class List extends View {
    public function new(content:Array<View>) {
        super();
        this.viewType = "List";
        this.children = content;
    }
}
