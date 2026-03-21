package sui.ui;

import sui.View;

class NavigationSplitView extends View {
    public var sidebar:View;
    public var detail:View;

    public function new(sidebar:View, detail:View) {
        super();
        this.viewType = "NavigationSplitView";
        this.sidebar = sidebar;
        this.detail = detail;
        this.children = [sidebar, detail];
    }
}
