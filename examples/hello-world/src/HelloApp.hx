import sui.App;
import sui.View;
import sui.ui.*;

class HelloApp extends App {
    static function main() {}

    public function new() {
        super();
        appName = "HelloHaxe";
        bundleIdentifier = "com.sui.helloworld";
    }

    override function body():View {
        return new VStack([
            new Text("Hello from Haxe!")
                .font(FontStyle.LargeTitle)
                .padding(),
            new Text("Running on macOS")
                .foregroundColor(ColorValue.Secondary),
            new Spacer(),
            new Text("Built with sui")
                .font(FontStyle.Caption)
                .foregroundColor(ColorValue.Gray)
        ]);
    }
}
