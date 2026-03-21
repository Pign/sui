package sui.ui;

import sui.View;

/**
    A container for grouping controls used for data entry.
    Maps to SwiftUI's `Form`. Typically used with Section children.
**/
class Form extends View {
    public function new(content:Array<View>) {
        super();
        this.viewType = "Form";
        this.children = content;
    }
}
