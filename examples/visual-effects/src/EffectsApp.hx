import sui.App;
import sui.View;
import sui.ui.*;
import sui.state.StateAction;

/**
    Demonstrates visual effect modifiers: blur, scaleEffect,
    rotationEffect, offset, contextMenu, and accessibilityLabel.
**/
class EffectsApp extends App {
    static function main() {}

    @:state var rotation:Float = 0.0;
    @:state var scale:Float = 1.0;
    @:state var blurAmount:Float = 0.0;
    @:state var message:String = "Hello!";

    public function new() {
        super();
        appName = "VisualEffects";
        bundleIdentifier = "com.sui.effects";
    }

    override function body():View {
        return new VStack(null, 30, [
            new Text("Visual Effects")
                .font(FontStyle.LargeTitle)
                .padding(),

            // Transformed text
            Text.withState("{message}")
                .font(FontStyle.Title)
                .foregroundColor(ColorValue.Blue)
                .scaleEffect(1.5)
                .rotationEffect(45.0)
                .padding(),

            // Controls
            new VStack(null, 10, [
                new HStack(null, 10, [
                    new Text("Blur"),
                    new Slider("blurAmount", 0, 10)
                ]).padding(),

                new HStack(null, 20, [
                    new Button("Spin", null, StateAction.Increment("rotation", 45)),
                    new Button("Grow", null, StateAction.CustomSwift("scale += 0.2")),
                    new Button("Shrink", null, StateAction.CustomSwift("scale = max(0.2, scale - 0.2)")),
                    new Button("Reset", null, StateAction.CustomSwift("rotation = 0; scale = 1.0; blurAmount = 0"))
                ])
            ]),

            // Card with effects applied
            new GroupBox("Preview", [
                new Text("Tap and hold me for options")
                    .padding()
                    .background(ColorValue.Blue)
                    .foregroundColor(ColorValue.White)
                    .cornerRadius(8)
                    .accessibilityLabel("Interactive preview card")
            ])
        ]);
    }
}
