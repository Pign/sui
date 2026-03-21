package sui.ui;

import sui.View;
import sui.state.StateAction;

/**
    A control that initiates an action.
    Maps to SwiftUI's `Button`.

    When a closure is provided without a StateAction, the closure is registered
    in the action registry and invoked via the C++ bridge at runtime.
**/
class Button extends View {
    public var label:String;
    public var labelView:Null<View>;
    public var action:() -> Void;
    public var stateAction:Null<StateAction>;
    public var actionId:Int;

    /** Global action registry — populated when body() builds the view tree at runtime. **/
    public static var _actionRegistry:Map<Int, () -> Void> = new Map();
    public static var _nextActionId:Int = 0;

    public function new(label:String, ?action:() -> Void, ?stateAction:StateAction) {
        super();
        this.viewType = "Button";
        this.label = label;
        this.action = action;
        this.stateAction = stateAction;

        // Register closure for bridge invocation
        if (action != null) {
            actionId = _nextActionId++;
            _actionRegistry.set(actionId, action);
        } else {
            actionId = -1;
        }
    }

    /** Create a button with a custom view label. **/
    public static function withView(labelView:View, ?action:() -> Void, ?stateAction:StateAction):Button {
        var btn = new Button("", action, stateAction);
        btn.labelView = labelView;
        return btn;
    }

    /** Called from C++ bridge to invoke a registered action by ID. **/
    public static function _invokeAction(id:Int):Void {
        if (_actionRegistry.exists(id)) {
            _actionRegistry.get(id)();
        }
    }
}
