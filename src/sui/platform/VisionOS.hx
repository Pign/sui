package sui.platform;

import sui.View;

/**
    visionOS-specific views and functionality.
**/
class VisionOS {
    /** Create an immersive space scene. **/
    @:swiftName("ImmersiveSpace")
    public static function immersiveSpace(@:swiftLabel("id") id:String, content:View):View {
        var view = new View();
        view.viewType = "ImmersiveSpace";
        view.properties.set("id", id);
        view.children = [content];
        return view;
    }

    /** Create a RealityView for 3D content. **/
    @:swiftName("RealityView")
    public static function realityView():View {
        var view = new View();
        view.viewType = "RealityView";
        return view;
    }

    /** Create a volumetric window. **/
    @:swiftName("Volume")
    public static function volume(@:swiftLabel("id") id:String, content:View):View {
        var view = new View();
        view.viewType = "Volume";
        view.properties.set("id", id);
        view.children = [content];
        return view;
    }

    /** Load a 3D model from a USDZ file. **/
    @:swiftName("Model3D")
    public static function model3D(@:swiftLabel("named") named:String):View {
        var view = new View();
        view.viewType = "Model3D";
        view.properties.set("named", named);
        return view;
    }
}
