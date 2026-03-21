package sui.ui;

import sui.View;

/**
    A view that controls navigation to a destination view.
    Maps to SwiftUI's `NavigationLink`.

    Usage:
    ```haxe
    new NavigationLink("Show Detail",
        new Text("Detail View").font(FontStyle.Title)
    )
    ```
**/
class NavigationLink extends View {
    public var label:String;
    public var labelView:Null<View>;
    public var destination:View;

    /** Create a navigation link with a text label and destination view. **/
    public function new(label:String, destination:View) {
        super();
        this.viewType = "NavigationLink";
        this.label = label;
        this.destination = destination;
        this.children = [destination];
    }

    /** Create a navigation link with a custom view label. **/
    public static function withView(labelView:View, destination:View):NavigationLink {
        var link = new NavigationLink("", destination);
        link.labelView = labelView;
        return link;
    }
}
