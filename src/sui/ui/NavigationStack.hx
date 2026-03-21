package sui.ui;

import sui.View;

/**
    A view that displays a root view and enables you to present additional views over the root view.
    Maps to SwiftUI's `NavigationStack`.
**/
class NavigationStack extends View {
    public function new(content:View) {
        super();
        this.viewType = "NavigationStack";
        this.children = [content];
    }
}
