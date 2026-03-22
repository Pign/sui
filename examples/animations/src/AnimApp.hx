import sui.App;
import sui.View;
import sui.ui.*;
import sui.state.StateAction;

/**
    Demonstrates the animation system:
    - StateAction.Animated wraps mutations in withAnimation
    - .animation() modifier with curves
    - .transition() for conditional view enter/exit
**/
class AnimApp extends App {
    static function main() {}

    @:state var showDetail:Bool = false;
    @:state var scale:Float = 1.0;
    @:state var rotation:Float = 0.0;
    @:state var offset:Float = 0.0;

    public function new() {
        super();
        appName = "Animations";
        bundleIdentifier = "com.sui.animations";
    }

    override function body():View {
        return new VStack(null, 30, [
            new Text("Animations")
                .font(FontStyle.LargeTitle),

            // Animated card that scales, rotates, and offsets
            new GroupBox("Animated Card", [
                new Text("Hello!")
                    .font(FontStyle.Title)
                    .padding()
            ])
            .scaleEffect("scale")
            .rotationEffect("rotation")
            .offset("offset", 0)
            .animation("spring", "scale")
            .animation("spring", "rotation")
            .animation("easeInOut", "offset")
            .padding(),

            // Animated state mutations
            new HStack(null, 15, [
                new Button("Bounce", null,
                    StateAction.Animated(StateAction.CustomSwift("scale = scale == 1.0 ? 1.3 : 1.0"), "spring")),
                new Button("Spin", null,
                    StateAction.Animated(StateAction.Increment("rotation", 90), "easeInOut")),
                new Button("Slide", null,
                    StateAction.Animated(StateAction.CustomSwift("offset = offset == 0 ? 50 : 0"), "easeInOut")),
                new Button("Reset", null,
                    StateAction.Animated(StateAction.CustomSwift("scale = 1; rotation = 0; offset = 0"), "spring"))
            ]),

            // Conditional view with transitions
            new Button("Toggle Detail", null,
                StateAction.Animated(StateAction.Toggle("showDetail"), "spring")),

            new ConditionalView("showDetail",
                new VStack([
                    new Text("Detail View")
                        .font(FontStyle.Headline),
                    new Text("This appeared with a slide transition")
                        .foregroundColor(ColorValue.Secondary)
                ])
                .padding()
                .background(ColorValue.Blue)
                .foregroundColor(ColorValue.White)
                .cornerRadius(12)
                .transition("slide"),

                new Text("Tap 'Toggle Detail' to show content")
                    .foregroundColor(ColorValue.Gray)
                    .transition("opacity")
            )
        ]).padding();
    }
}
