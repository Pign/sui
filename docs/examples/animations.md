# Animations

Demonstrates all three animation primitives: fluent `.animated()` chaining, `.animation()` modifier with `AnimationCurve`, and `.transition()`.

## Full Source

```haxe
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

            new GroupBox("Animated Card", [
                new Text("Hello!")
                    .font(FontStyle.Title)
                    .padding()
            ])
            .scaleEffect(scale)
            .rotationEffect(rotation)
            .offset(offset, 0)
            .animation(AnimationCurve.Spring, scale)
            .animation(AnimationCurve.Spring, rotation)
            .animation(AnimationCurve.EaseInOut, offset)
            .padding(),

            new HStack(null, 15, [
                new Button("Bounce", null,
                    StateAction.CustomSwift("scale = scale == 1.0 ? 1.3 : 1.0")
                        .animated(AnimationCurve.Spring)),
                new Button("Spin", null,
                    rotation.inc(90).animated(AnimationCurve.EaseInOut)),
                new Button("Slide", null,
                    StateAction.CustomSwift("offset = offset == 0 ? 50 : 0")
                        .animated(AnimationCurve.EaseInOut)),
                new Button("Reset", null,
                    StateAction.CustomSwift("scale = 1; rotation = 0; offset = 0")
                        .animated(AnimationCurve.Spring))
            ]),

            new Button("Toggle Detail", null,
                showDetail.tog().animated(AnimationCurve.Spring)),

            new ConditionalView(showDetail,
                new VStack([
                    new Text("Detail View").font(FontStyle.Headline),
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
```

## Walkthrough

### State-Bound Visual Effects

```haxe
.scaleEffect(scale)
.rotationEffect(rotation)
.animation(AnimationCurve.Spring, scale)
.animation(AnimationCurve.Spring, rotation)
```

Pass a `State<Float>` reference to visual effect modifiers for dynamic binding. Type-checked at compile time. The `.animation()` modifier takes an `AnimationCurve` enum value that tells SwiftUI which curve to use when that `State<Float>` reference changes.

### Animated Mutations

```haxe
rotation.inc(90).animated(AnimationCurve.EaseInOut)
```

The fluent `.animated()` method wraps any `StateAction` in `withAnimation(.curve) { }`. Without it, the state change is instant. With it, SwiftUI interpolates the visual property smoothly.

### Transitions

```haxe
new ConditionalView(showDetail,
    detailView.transition("slide"),
    placeholder.transition("opacity")
)
```

`.transition()` defines how a view enters and exits. Only works when the state toggle is animated:

```haxe
// Animates transition:
showDetail.tog().animated(AnimationCurve.Spring)

// No transition animation:
showDetail.tog()
```

### How They Work Together

1. **State changes** &mdash; `.animated(AnimationCurve.Spring)` wraps the mutation in `withAnimation`
2. **View bindings** &mdash; `.scaleEffect(scale)` reads the `State<Float>` field (type-checked)
3. **Animation curve** &mdash; `.animation(AnimationCurve.Spring, scale)` specifies HOW to animate
4. **Transitions** &mdash; `.transition("slide")` specifies enter/exit behavior

All three can be combined on the same view for complex animated interactions.

## Run It

```bash
cd examples/animations
haxelib run sui run macos
```
