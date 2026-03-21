package sui.ui;

import sui.View;

/**
    A view that displays an image.
    Maps to SwiftUI's `Image`.
**/
class Image extends View {
    public var name:String;
    public var systemName:Null<String>;

    /** Create an image from an asset catalog name. **/
    public function new(name:String) {
        super();
        this.viewType = "Image";
        this.name = name;
    }

    /** Create an image from an SF Symbol name. **/
    @:swiftName("Image")
    public static function systemImage(@:swiftLabel("systemName") systemName:String):Image {
        var img = new Image("");
        img.systemName = systemName;
        return img;
    }

    public function resizable():Image {
        modifierChain.push(sui.modifiers.ViewModifier.FixedSize(false, false));
        properties.set("resizable", true);
        return this;
    }
}
