package sui.ui;

import sui.View;

/**
    A link that opens a URL. Maps to SwiftUI's `Link`.

    ```haxe
    new Link("Visit Website", "https://example.com")
    ```
**/
@:swiftView("Link")
class Link extends View {
    public var label:String;
    public var url:String;

    public function new(@:swiftLabel("_") label:String, @:swiftLabel("destination") url:String) {
        super();
        this.viewType = "Link";
        this.label = label;
        this.url = url;
    }
}
