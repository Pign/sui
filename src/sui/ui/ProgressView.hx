package sui.ui;

import sui.View;

/**
    A loading indicator. Maps to SwiftUI's `ProgressView`.

    Spinner (indeterminate):
    ```haxe
    new ProgressView()
    new ProgressView("Loading...")
    ```

    Bar (determinate):
    ```haxe
    new ProgressView("Downloading", "progress", 100.0)
    ```
**/
@:swiftView("ProgressView")
class ProgressView extends View {
    public var label:String;
    public var valueBinding:String;
    public var total:Float;

    public function new(?@:swiftLabel("_") label:String, ?@:swiftLabel("value") @:swiftBinding valueBinding:String, ?@:swiftLabel("total") total:Float) {
        super();
        this.viewType = "ProgressView";
        this.label = label;
        this.valueBinding = valueBinding;
        this.total = total != null ? total : 1.0;
    }
}
