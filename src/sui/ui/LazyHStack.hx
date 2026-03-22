package sui.ui;

import sui.View;

/**
    A lazy horizontal stack that only renders visible children.
    Maps to SwiftUI's `LazyHStack`. Same API as `HStack`.
**/
class LazyHStack extends View {
    public function new(?alignment:VerticalAlignment, ?spacing:Float, ?content:Array<View>) {
        super();
        this.viewType = "LazyHStack";
    }
}
