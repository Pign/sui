package sui.ui;

import sui.View;

/**
    A picker control for selecting from a set of options.
    Maps to SwiftUI's `Picker`.

    The `selectionBinding` is the name of a `@State` variable to bind to.
    Children are the picker options (typically Text views with `.tag()` modifier).
**/
@:swiftView("Picker")
class Picker extends View {
    public var label:String;
    public var selectionBinding:String;

    public function new(@:swiftLabel("_") label:String, @:swiftLabel("selection") @:swiftBinding selectionBinding:String, content:Array<View>) {
        super();
        this.viewType = "Picker";
        this.label = label;
        this.selectionBinding = selectionBinding;
        this.children = content;
    }
}
