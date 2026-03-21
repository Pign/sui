package sui.platform;

import sui.View;

/**
    iOS-specific views and functionality.
**/
class IOS {
    /** Create a tab view with iOS-style tabs. **/
    public static function tabView(tabs:Array<Tab>):View {
        var view = new View();
        view.viewType = "TabView";
        for (tab in tabs) {
            view.children.push(tab.content);
        }
        view.properties.set("tabs", tabs);
        return view;
    }
}

typedef Tab = {
    label:String,
    systemImage:String,
    content:View,
}
