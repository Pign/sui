package sui.ui;

import sui.View;

/**
    A color selection control. Maps to SwiftUI's `ColorPicker`.

    ```haxe
    new ColorPicker("Theme Color", "selectedColor")
    ```
**/
@:swiftView("ColorPicker")
class ColorPicker extends View {
    public var label:String;
    public var selectionBinding:String;

    public function new(@:swiftLabel("_") label:String, @:swiftLabel("selection") @:swiftBinding selectionBinding:String) {
        super();
        this.viewType = "ColorPicker";
        this.label = label;
        this.selectionBinding = selectionBinding;
    }
}
