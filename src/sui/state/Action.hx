package sui.state;

/**
    Wrapper around StateAction that enables fluent `.animated()` chaining.

    ```haxe
    rotation.inc(90).animated(AnimationCurve.Spring)
    showDetail.tog().animated(AnimationCurve.EaseInOut)
    scale.setTo(1.5).animated(AnimationCurve.Bouncy)
    ```
**/
abstract Action(StateAction) from StateAction to StateAction {
    /** Wrap this action in a SwiftUI `withAnimation` block. **/
    public inline function animated(curve:AnimationCurve):Action {
        return cast StateAction.Animated(cast this, curve);
    }
}
