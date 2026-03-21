package sui.ui;

import sui.View;

/**
    A scrollable container.
    Maps to SwiftUI's `ScrollView`.
**/
class ScrollView extends View {
    public function new(content:Array<View>) {
        super();
        this.viewType = "ScrollView";
        this.children = content;
    }
}
