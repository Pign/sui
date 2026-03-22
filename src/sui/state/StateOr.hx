package sui.state;

/**
    A value that is either a static `Float` or a reactive `State<Float>`.
    Used by visual effect modifiers to accept both static and state-bound values.

    ```haxe
    .scaleEffect(1.5)     // static — always 1.5
    .scaleEffect(scale)   // state — animates when scale changes
    ```
**/
abstract StateOr<T>(Dynamic) {
    @:from public static inline function fromFloat(v:Float):StateOr<Float> {
        return cast v;
    }

    @:from public static inline function fromInt(v:Int):StateOr<Float> {
        return cast v;
    }

    @:from public static inline function fromState<T>(s:State<T>):StateOr<T> {
        return cast s;
    }
}
