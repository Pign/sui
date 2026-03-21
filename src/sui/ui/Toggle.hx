package sui.ui;

import sui.View;

/**
    A toggle switch control.
    Maps to SwiftUI's `Toggle`.

    The `isOnBinding` parameter is the name of a `@State` Bool variable to bind to.
**/
@:swiftView("Toggle")
class Toggle extends View {
    public var label:String;
    public var isOnBinding:String;

    public function new(@:swiftLabel("_") label:String, @:swiftLabel("isOn") @:swiftBinding isOnBinding:String) {
        super();
        this.viewType = "Toggle";
        this.label = label;
        this.isOnBinding = isOnBinding;
    }
}
