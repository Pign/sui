package sui.state;

/**
    Describes a state mutation declaratively so the Swift generator
    can emit proper SwiftUI code instead of trying to decompile closures.
**/
enum StateAction {
    /** Increment a named state variable by a value. **/
    Increment(stateName:String, amount:Int);

    /** Decrement a named state variable by a value. **/
    Decrement(stateName:String, amount:Int);

    /** Set a named state variable to a specific value. **/
    SetValue(stateName:String, value:Dynamic);

    /** Toggle a named boolean state variable. **/
    Toggle(stateName:String);

    /** Append to a named array state variable. **/
    Append(stateName:String, value:Dynamic);

    /** Custom Swift expression (escape hatch). **/
    CustomSwift(code:String);

    /**
        Call a @:expose function asynchronously and assign the result to a state variable.
        Runs in a Swift Task so the UI stays responsive.

        Single arg:  BridgeCall("result", "greet", "World")
        Multi arg:   BridgeCall("result", "doLogin", ["url", "email", "pass"])

        Generates:
        ```swift
        Task.detached {
            let r = HaxeBridgeC.greet("World")
            await MainActor.run { result = r }
        }
        ```
    **/
    BridgeCall(stateName:String, functionName:String, args:Dynamic);

    /**
        Like BridgeCall but sets a loading value immediately before the async call.

        Single arg:  BridgeCallLoading("result", "Loading...", "fetchData", "https://url")
        Multi arg:   BridgeCallLoading("result", "Loading...", "doLogin", ["url", "email", "pass"])

        Generates:
        ```swift
        result = "Loading..."
        Task.detached {
            let r = HaxeBridgeC.doLogin("url", "email", "pass")
            await MainActor.run { result = r }
        }
        ```
    **/
    BridgeCallLoading(stateName:String, loadingValue:String, functionName:String, args:Dynamic);

    /**
        Wrap any StateAction in a SwiftUI `withAnimation` block.

        Curves: "default", "easeIn", "easeOut", "easeInOut", "spring", "linear", "bouncy"

        ```haxe
        StateAction.Animated(StateAction.Toggle("showDetail"), "spring")
        ```

        Generates:
        ```swift
        withAnimation(.spring) { showDetail.toggle() }
        ```
    **/
    Animated(action:StateAction, curve:String);
}
