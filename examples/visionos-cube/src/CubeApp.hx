import sui.App;
import sui.View;
import sui.ui.*;
import sui.platform.VisionOS;

class CubeApp extends App {
    static function main() {}

    public function new() {
        super();
        appName = "VisionCube";
        bundleIdentifier = "com.haxeapple.visionoscube";
    }

    override function body():View {
        return new VStack([
            new Text("3D Cube Demo")
                .font(FontStyle.LargeTitle)
                .padding(),
            VisionOS.model3D("toy_drummer.usdz"),
            new Text("Built with Haxe on visionOS")
                .font(FontStyle.Caption)
                .foregroundColor(ColorValue.Secondary)
                .padding()
        ]);
    }
}
