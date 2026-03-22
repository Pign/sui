package sui.ui;

import sui.View;

/**
    A visually grouped box with an optional label. Maps to SwiftUI's `GroupBox`.

    ```haxe
    new GroupBox("Settings", [
        new Toggle("Notifications", "notifs"),
        new Toggle("Sound", "sound")
    ])
    ```
**/
class GroupBox extends View {
    public var label:String;
    public var content:Array<View>;

    public function new(?label:String, content:Array<View>) {
        super();
        this.viewType = "GroupBox";
        this.label = label;
        this.content = content;
    }
}
