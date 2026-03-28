# Animations

sui provides three animation primitives that map to SwiftUI's animation system.

## Animated State Mutations

Chain `.animated()` on any fluent `StateAction` to animate the change. Use the `AnimationCurve` enum to specify the curve:

```haxe
// Instant (no animation)
new Button("Toggle", null, expanded.tog())

// Animated with spring curve
new Button("Toggle", null,
    expanded.tog().animated(AnimationCurve.Spring))
```

This generates:
```swift
// Instant
Button("Toggle") { expanded.toggle() }

// Animated
Button("Toggle") { withAnimation(.spring) { expanded.toggle() } }
```

Any fluent `StateAction` can be animated:

```haxe
// Scale with bounce
scale.setTo(1.5).animated(AnimationCurve.Bouncy)

// Increment with ease
count.inc(1).animated(AnimationCurve.EaseInOut)

// Multiple mutations
StateAction.CustomSwift("scale = 1; rotation = 0").animated(AnimationCurve.Spring)
```

### Animation Curves

Use the `AnimationCurve` enum for type-safe curve selection:

| Curve | Description |
|-------|-------------|
| `AnimationCurve.Default` | System default |
| `AnimationCurve.EaseIn` | Starts slow, speeds up |
| `AnimationCurve.EaseOut` | Starts fast, slows down |
| `AnimationCurve.EaseInOut` | Slow at both ends |
| `AnimationCurve.Spring` | Spring physics with overshoot |
| `AnimationCurve.Linear` | Constant speed |
| `AnimationCurve.Bouncy` | Playful bounce |

## Animation Modifier

The `.animation()` modifier tells SwiftUI to animate a view when a `State<Float>` reference changes. Use the `AnimationCurve` enum for the curve:

```haxe
@:state var scale:Float = 1.0;

new Text("Hello")
    .scaleEffect(scale)
    .animation(AnimationCurve.Spring, scale)
```

When `scale` changes, the scale effect animates with a spring curve. Without the second parameter, all state changes trigger animation:

```haxe
new Text("Hello")
    .opacity(alpha)
    .animation(AnimationCurve.EaseInOut)
```

### Combining with State-Bound Modifiers

Visual effect modifiers accept `State<Float>` references for dynamic values. These are type-checked at compile time. Pair them with `.animation()` and the `AnimationCurve` enum for smooth transitions:

```haxe
@:state var cardScale:Float = 1.0;
@:state var cardRotation:Float = 0.0;
@:state var cardBlur:Float = 0.0;

new GroupBox("Card", [
    new Text("Animated!")
        .font(FontStyle.Title)
])
.scaleEffect(cardScale)
.rotationEffect(cardRotation)
.blur(cardBlur)
.animation(AnimationCurve.Spring, cardScale)
.animation(AnimationCurve.EaseInOut, cardRotation)
.animation(AnimationCurve.EaseOut, cardBlur)
```

Then mutate the state with `.animated()` to trigger:

```haxe
new Button("Bounce", null,
    StateAction.CustomSwift("cardScale = cardScale == 1.0 ? 1.3 : 1.0")
        .animated(AnimationCurve.Spring))
```

## Transitions

The `.transition()` modifier defines how a view enters and exits when used inside a `ConditionalView`:

```haxe
new Button("Show Detail", null,
    showDetail.tog().animated(AnimationCurve.Spring))

new ConditionalView(showDetail,
    // Slides in from the edge
    new Text("Detail content")
        .padding()
        .background(ColorValue.Blue)
        .cornerRadius(12)
        .transition("slide"),

    // Fades out
    new Text("Tap to show detail")
        .transition("opacity")
)
```

### Transition Styles

| Style | Description |
|-------|-------------|
| `"opacity"` | Fade in/out |
| `"slide"` | Slide from leading edge |
| `"scale"` | Scale from small to full size |
| `"move"` | Move from an edge |
| `"push"` | Push old view out, new view in |

### How Animations Flow

```mermaid
flowchart TD
    A["Button tap"] --> B[".animated(AnimationCurve.Spring)"]
    B --> C["withAnimation(.spring)"]
    C --> D["State mutation"]
    D --> E["SwiftUI detects change"]
    E --> F[".animation() modifier"]
    F --> G["Smooth interpolation"]
    E --> H[".transition() modifier"]
    H --> I["Enter/exit animation"]
```

### Important

Transitions only animate when the state change is itself animated. Chain `.animated()` on the toggle:

```haxe
// This animates the transition:
visible.tog().animated(AnimationCurve.Spring)

// This does NOT — the view appears/disappears instantly:
visible.tog()
```

## Full Example

```haxe
class AnimApp extends App {
    static function main() {}

    @:state var showDetail:Bool = false;
    @:state var scale:Float = 1.0;
    @:state var rotation:Float = 0.0;

    public function new() {
        super();
        appName = "Animations";
        bundleIdentifier = "com.sui.animations";
    }

    override function body():View {
        return new VStack(null, 30, [
            // Card with animated transforms
            new Text("Hello!")
                .font(FontStyle.Title)
                .scaleEffect(scale)
                .rotationEffect(rotation)
                .animation(AnimationCurve.Spring, scale)
                .animation(AnimationCurve.Spring, rotation),

            // Animated buttons
            new HStack(null, 15, [
                new Button("Bounce", null,
                    StateAction.CustomSwift("scale = scale == 1.0 ? 1.3 : 1.0")
                        .animated(AnimationCurve.Spring)),
                new Button("Spin", null,
                    rotation.inc(90).animated(AnimationCurve.EaseInOut))
            ]),

            // Toggle with animated transition
            new Button("Toggle Detail", null,
                showDetail.tog().animated(AnimationCurve.Spring)),

            new ConditionalView(showDetail,
                new Text("Detail!")
                    .padding()
                    .background(ColorValue.Blue)
                    .foregroundColor(ColorValue.White)
                    .cornerRadius(12)
                    .transition("slide")
            )
        ]).padding();
    }
}
```

## Run It

```bash
cd examples/animations
haxelib run sui run macos
```
