package sui.state;

/**
    Describes a state mutation declaratively so the Swift generator
    can emit proper SwiftUI code instead of trying to decompile closures.

    State references are type-checked — pass the `State<T>` field directly:
    ```haxe
    StateAction.Increment(rotation, 90)    // not "rotation"
    StateAction.Toggle(showDetail)          // not "showDetail"
    ```
**/
enum StateAction {
    /** Increment a state variable by a value. **/
    Increment(state:Dynamic, amount:Int);

    /** Decrement a state variable by a value. **/
    Decrement(state:Dynamic, amount:Int);

    /** Set a state variable to a specific value. **/
    SetValue(state:Dynamic, value:Dynamic);

    /** Toggle a boolean state variable. **/
    Toggle(state:Dynamic);

    /** Append to an array state variable. **/
    Append(state:Dynamic, value:Dynamic);

    /** Custom Swift expression (escape hatch). **/
    CustomSwift(code:String);

    /**
        Call a @:expose function asynchronously and assign the result to a state variable.

        ```haxe
        BridgeCall(result, "greet", "World")
        BridgeCall(result, "doLogin", ["url", "email", "pass"])
        ```
    **/
    BridgeCall(state:Dynamic, functionName:String, args:Dynamic);

    /**
        Like BridgeCall but sets a loading value immediately before the async call.

        ```haxe
        BridgeCallLoading(result, "Loading...", "fetchData", "https://url")
        ```
    **/
    BridgeCallLoading(state:Dynamic, loadingValue:String, functionName:String, args:Dynamic);

    /**
        Wrap any StateAction in a SwiftUI `withAnimation` block.

        ```haxe
        StateAction.Animated(rotation.inc(90), AnimationCurve.Spring)
        ```

        Generates:
        ```swift
        withAnimation(.spring) { rotation += 90 }
        ```
    **/
    Animated(action:StateAction, curve:AnimationCurve);
}
