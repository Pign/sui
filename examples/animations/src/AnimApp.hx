import sui.App;
import sui.View;
import sui.ui.*;
import sui.state.StateAction;
import sui.state.AnimationCurve;

/**
    Demonstrates the animation system:
    - Fluent action builders: rotation.inc(90).animated(AnimationCurve.Spring)
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
            .scaleEffect(scale)
            .rotationEffect(rotation)
            .offset(offset, 0)
            .animation("spring", scale)
            .animation("spring", rotation)
            .animation("easeInOut", offset)
            .padding(),

            // Animated state mutations using fluent API
            new HStack(null, 15, [
                new Button("Bounce", null,
                    StateAction.Animated(StateAction.CustomSwift("scale = scale == 1.0 ? 1.3 : 1.0"), AnimationCurve.Spring)),
                new Button("Spin", null,
                    rotation.inc(90).animated(AnimationCurve.EaseInOut)),
                new Button("Slide", null,
                    StateAction.Animated(StateAction.CustomSwift("offset = offset == 0 ? 50 : 0"), AnimationCurve.EaseInOut)),
                new Button("Reset", null,
                    StateAction.Animated(StateAction.CustomSwift("scale = 1; rotation = 0; offset = 0"), AnimationCurve.Spring))
            ]),

            // Conditional view with transitions
            new Button("Toggle Detail", null,
                showDetail.tog().animated(AnimationCurve.Spring)),

            new ConditionalView(showDetail,
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
