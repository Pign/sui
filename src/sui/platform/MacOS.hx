package sui.platform;

import sui.View;

/**
    macOS-specific views and functionality.
**/
class MacOS {
    /** Create a menu bar section for macOS apps. **/
    public static function menuBar(title:String, items:Array<MenuItem>):View {
        var view = new View();
        view.viewType = "MenuBar";
        view.properties.set("title", title);
        view.properties.set("items", items);
        return view;
    }
}

typedef MenuItem = {
    label:String,
    ?shortcut:String,
    ?action:() -> Void,
    ?submenu:Array<MenuItem>,
}
