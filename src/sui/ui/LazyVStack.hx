package sui.ui;

import sui.View;

/**
    A lazy vertical stack that only renders visible children.
    Maps to SwiftUI's `LazyVStack`. Same API as `VStack`.
**/
class LazyVStack extends View {
    public function new(?alignment:HorizontalAlignment, ?spacing:Float, ?content:Array<View>) {
        super();
        this.viewType = "LazyVStack";
    }
}
