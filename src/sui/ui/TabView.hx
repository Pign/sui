package sui.ui;

import sui.View;

class TabView extends View {
    public var tabs:Array<TabItem>;

    public function new(tabs:Array<TabItem>) {
        super();
        this.viewType = "TabView";
        this.tabs = tabs;
        for (tab in tabs) this.children.push(tab.content);
    }
}

typedef TabItem = {
    label:String,
    systemImage:String,
    content:View,
}
