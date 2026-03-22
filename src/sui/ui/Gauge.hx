package sui.ui;

import sui.View;

/**
    A value indicator within a range. Maps to SwiftUI's `Gauge`.

    ```haxe
    new Gauge("Battery", "batteryLevel", 0, 100)
    ```
**/
@:swiftView("Gauge")
class Gauge extends View {
    public var label:String;
    public var valueBinding:String;
    public var minValue:Float;
    public var maxValue:Float;

    public function new(@:swiftLabel("_") label:String, @:swiftLabel("value") @:swiftBinding valueBinding:String,
                        @:swiftLabel("in") minValue:Float, @:swiftLabel("_") maxValue:Float) {
        super();
        this.viewType = "Gauge";
        this.label = label;
        this.valueBinding = valueBinding;
        this.minValue = minValue;
        this.maxValue = maxValue;
    }
}
