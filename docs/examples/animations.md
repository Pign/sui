# Animations

Demonstrates all three animation primitives: `Animated` actions, `.animation()` modifier, and `.transition()`.

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
            .scaleEffect("scale")
            .rotationEffect("rotation")
            .offset("offset", 0)
            .animation("spring", "scale")
            .animation("spring", "rotation")
            .animation("easeInOut", "offset")
            .padding(),

            new HStack(null, 15, [
                new Button("Bounce", null,
                    StateAction.Animated(
                        StateAction.CustomSwift("scale = scale == 1.0 ? 1.3 : 1.0"),
                        "spring")),
                new Button("Spin", null,
                    StateAction.Animated(
                        StateAction.Increment("rotation", 90),
                        "easeInOut")),
                new Button("Slide", null,
                    StateAction.Animated(
                        StateAction.CustomSwift("offset = offset == 0 ? 50 : 0"),
                        "easeInOut")),
                new Button("Reset", null,
                    StateAction.Animated(
                        StateAction.CustomSwift("scale = 1; rotation = 0; offset = 0"),
                        "spring"))
            ]),

            new Button("Toggle Detail", null,
                StateAction.Animated(StateAction.Toggle("showDetail"), "spring")),

            new ConditionalView("showDetail",
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
.scaleEffect("scale")
.rotationEffect("rotation")
.animation("spring", "scale")
.animation("spring", "rotation")
```

Pass a state variable name (string) to visual effect modifiers for dynamic binding. The `.animation()` modifier tells SwiftUI which curve to use when that variable changes.

### Animated Mutations

```haxe
StateAction.Animated(StateAction.Increment("rotation", 90), "easeInOut")
```

`Animated` wraps any `StateAction` in `withAnimation(.curve) { }`. Without it, the state change is instant. With it, SwiftUI interpolates the visual property smoothly.

### Transitions

```haxe
new ConditionalView("showDetail",
    detailView.transition("slide"),
    placeholder.transition("opacity")
)
```

`.transition()` defines how a view enters and exits. Only works when the state toggle is animated:

```haxe
// Animates transition:
StateAction.Animated(StateAction.Toggle("showDetail"), "spring")

// No transition animation:
StateAction.Toggle("showDetail")
```

### How They Work Together

1. **State changes** &mdash; `Animated` wraps the mutation in `withAnimation`
2. **View bindings** &mdash; `.scaleEffect("scale")` reads the state variable
3. **Animation curve** &mdash; `.animation("spring", "scale")` specifies HOW to animate
4. **Transitions** &mdash; `.transition("slide")` specifies enter/exit behavior

All three can be combined on the same view for complex animated interactions.

## Run It

```bash
cd examples/animations
haxelib run sui run macos
```
