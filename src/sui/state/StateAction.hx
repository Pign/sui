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
        Call a @:bridge function asynchronously and assign the result to a state variable.
        Runs in a Swift Task so the UI stays responsive.

        Usage: BridgeCall("resultState", "bridgeFunctionName", "arg")

        Generates:
        ```swift
        Task { @MainActor in
            resultState = HaxeBridgeC.bridgeFunctionName("arg")
        }
        ```
    **/
    BridgeCall(stateName:String, functionName:String, arg:String);

    /**
        Like BridgeCall but sets a loading value immediately before the async call.

        Usage: BridgeCallLoading("resultState", "Loading...", "fetchData", "https://url")

        Generates:
        ```swift
        resultState = "Loading..."
        Task { @MainActor in
            resultState = HaxeBridgeC.fetchData("https://url")
        }
        ```
    **/
    BridgeCallLoading(stateName:String, loadingValue:String, functionName:String, arg:String);
}
