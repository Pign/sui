package sui.ui;

import sui.View;

/**
    An empty state placeholder. Maps to SwiftUI's `ContentUnavailableView`.

    ```haxe
    new ContentUnavailableView("No Results", "magnifyingglass", "Try a different search term.")
    ```
**/
class ContentUnavailableView extends View {
    public var title:String;
    public var systemImage:String;
    public var description:String;

    public function new(title:String, ?systemImage:String, ?description:String) {
        super();
        this.viewType = "ContentUnavailableView";
        this.title = title;
        this.systemImage = systemImage;
        this.description = description;
    }
}
