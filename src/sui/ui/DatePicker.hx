package sui.ui;

import sui.View;

/**
    A date selection control. Maps to SwiftUI's `DatePicker`.

    ```haxe
    new DatePicker("Birthday", "selectedDate")
    ```
**/
@:swiftView("DatePicker")
class DatePicker extends View {
    public var label:String;
    public var selectionBinding:String;

    public function new(@:swiftLabel("_") label:String, @:swiftLabel("selection") @:swiftBinding selectionBinding:String) {
        super();
        this.viewType = "DatePicker";
        this.label = label;
        this.selectionBinding = selectionBinding;
    }
}
