package sui.ui;

import sui.View;

/**
    Renders as NavigationSplitView on iPad/Mac (regular width) and
    VStack with NavigationStack on iPhone (compact width).

    ```haxe
    new AdaptiveStack(sidebarView, detailView)
    ```

    Generated Swift uses `@Environment(\.horizontalSizeClass)` to switch layout.
**/
class AdaptiveStack extends View {
    public var sidebar:View;
    public var detail:View;

    public function new(sidebar:View, detail:View) {
        super();
        this.viewType = "AdaptiveStack";
        this.sidebar = sidebar;
        this.detail = detail;
    }
}
