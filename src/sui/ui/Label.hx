package sui.ui;

import sui.View;

@:swiftView("Label")
class Label extends View {
    public var title:String;
    public var systemImage:String;

    public function new(@:swiftLabel("_") title:String, @:swiftLabel("systemImage") systemImage:String) {
        super();
        this.viewType = "Label";
        this.title = title;
        this.systemImage = systemImage;
    }
}
