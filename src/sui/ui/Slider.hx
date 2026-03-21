package sui.ui;

import sui.View;

/**
    A slider control for selecting a value from a range.
    Maps to SwiftUI's `Slider`.

    The `valueBinding` is the name of a `@State` Float/Double variable to bind to.
**/
class Slider extends View {
    public var valueBinding:String;
    public var rangeMin:Float;
    public var rangeMax:Float;

    public function new(valueBinding:String, rangeMin:Float, rangeMax:Float) {
        super();
        this.viewType = "Slider";
        this.valueBinding = valueBinding;
        this.rangeMin = rangeMin;
        this.rangeMax = rangeMax;
    }
}
