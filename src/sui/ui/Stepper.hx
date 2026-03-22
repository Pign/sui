package sui.ui;

import sui.View;

/**
    An increment/decrement control. Maps to SwiftUI's `Stepper`.

    ```haxe
    new Stepper("Quantity", "quantity", 1, 10)
    ```
**/
@:swiftView("Stepper")
class Stepper extends View {
    public var label:String;
    public var valueBinding:String;
    public var minValue:Int;
    public var maxValue:Int;

    public function new(@:swiftLabel("_") label:String, @:swiftLabel("value") @:swiftBinding valueBinding:String,
                        @:swiftLabel("in") minValue:Int, @:swiftLabel("_") maxValue:Int) {
        super();
        this.viewType = "Stepper";
        this.label = label;
        this.valueBinding = valueBinding;
        this.minValue = minValue;
        this.maxValue = maxValue;
    }
}
