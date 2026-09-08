import sui.App;
import sui.View;
import sui.ui.*;
import sui.state.AnimationCurve;

/**
    Demonstrates the animation system:
    - .animation(curve, state) — every change of the bound state
      animates with the given curve, including changes coming back
      from Haxe action closures through the bridge
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
            .scaleEffect(scale_)
            .rotationEffect(rotation_)
            .offset(offset_, 0)
            .animation(AnimationCurve.Spring, scale_)
            .animation(AnimationCurve.Spring, rotation_)
            .animation(AnimationCurve.EaseInOut, offset_)
            .padding(),

            // State mutations are plain closures; the curves live on
            // the views via .animation(curve, state) above.
            new HStack(null, 15, [
                new Button("Bounce", () -> scale = scale == 1.0 ? 1.3 : 1.0),
                new Button("Spin", () -> rotation += 90),
                new Button("Slide", () -> offset = offset == 0 ? 50 : 0),
                new Button("Reset", () -> {
                    scale = 1;
                    rotation = 0;
                    offset = 0;
                })
            ]),

            // Conditional view with transitions — the .animation on
            // the enclosing VStack (bound to showDetail) drives them.
            new Button("Toggle Detail", () -> showDetail = !showDetail),

            new ConditionalView(showDetail_,
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
        ]).padding()
            .animation(AnimationCurve.Spring, showDetail_);
    }
}
