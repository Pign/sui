import sui.App;
import sui.View;
import sui.ui.*;

/**
    Demonstrates view-returning function calls:
    - Static methods on other classes (Shared.header)
    - Instance methods on the App class (buildControls)
**/
class BuilderApp extends App {
    static function main() {}

    @:state var count:Int = 0;
    @:state var message:String = "Hello!";

    public function new() {
        super();
        appName = "ViewBuilders";
        bundleIdentifier = "com.sui.viewbuilders";
    }

    /** Instance method returning a View — inlined by the macro. **/
    function buildControls():View {
        return new HStack(null, 20, [
            new Button("-", () -> count--),
            new Button("+", () -> count++),
            new Button("Reset", () -> count = 0)
        ]);
    }

    override function body():View {
        return new VStack(null, 20, [
            // Static helper from another class
            Shared.header("View Builders"),

            // Static helper with parameters
            Shared.infoRow("Count", "see below"),

            // State display
            Text.bind('Count: $count')
                .font(FontStyle.Title),

            // Instance method inlined
            buildControls(),

            new Spacer()
        ]);
    }
}
