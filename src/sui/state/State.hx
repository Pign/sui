package sui.state;

/**
    Represents a piece of reactive state in a view.
    When the C++ bridge is linked, setting `value` automatically notifies Swift
    to update the corresponding SwiftUI state.

    Usage with @:state (recommended):
    ```haxe
    @:state var count:Int = 0;

    // In closures:
    count.value = 5;        // write (notifies Swift)
    trace(count.value);     // read
    ```

    Usage with explicit State<T>:
    ```haxe
    var count:State<Int>;
    count = new State<Int>(0, "count");
    count.set(5);           // write
    count.get();            // read
    ```
**/
#if cpp
@:cppFileCode('
// State notification function pointer — set by the bridge at init time.
// When no bridge is linked, this stays null and set() is a no-op for Swift.
static void (*_hxsui_state_callback)(const char* key, const char* value) = nullptr;

extern "C" void haxe_bridge_register_state_fn(void (*cb)(const char*, const char*)) {
    _hxsui_state_callback = cb;
}

void _hxsui_notify_swift(const char* key, const char* value) {
    if (_hxsui_state_callback) _hxsui_state_callback(key, value);
}
')
#end
class State<T> {
    /** Read or write the state value. Writing triggers Swift notification. **/
    public var value(get, set):T;

    public var name:String;

    private var _value:T;
    private var onChange:Null<T->Void>;

    /** Registry of State instances by name, for C bridge query functions. **/
    private static var _registry:Map<String, Dynamic> = new Map();

    public function new(initialValue:T, ?name:String) {
        this._value = initialValue;
        this.name = name != null ? name : "";
        if (name != null && name != "")
            _registry.set(name, this);
    }

    /** Get array length for a named state variable. Returns -1 if not an array. **/
    public static function _getArrayLength(name:String):Int {
        var state:Dynamic = _registry.get(name);
        if (state == null)
            return -1;
        var val:Dynamic = state._value;
        if (Std.isOfType(val, Array)) {
            var arr:Array<Dynamic> = val;
            return arr.length;
        }
        return -1;
    }

    /** Get string value of array element at index for a named state variable. **/
    public static function _getArrayElement(name:String, index:Int):String {
        var state:Dynamic = _registry.get(name);
        if (state == null)
            return "";
        var val:Dynamic = state._value;
        if (Std.isOfType(val, Array)) {
            var arr:Array<Dynamic> = val;
            if (index >= 0 && index < arr.length)
                return Std.string(arr[index]);
        }
        return "";
    }

    function get_value():T {
        return _value;
    }

    function set_value(newValue:T):T {
        _value = newValue;
        if (onChange != null) {
            onChange(newValue);
        }
        #if cpp
        var k = name;
        var v = Std.string(newValue);
        untyped __cpp__('_hxsui_notify_swift({0}.utf8_str(), {1}.utf8_str())', k, v);
        #end
        return newValue;
    }

    /** Read the current value. Alias for `value`. **/
    public function get():T {
        return _value;
    }

    /** Set a new value and notify Swift. Alias for `value = x`. **/
    public function set(newValue:T):Void {
        value = newValue;
    }

    public function onValueChanged(callback:T->Void):Void {
        onChange = callback;
    }

    /**
        Update a SwiftUI state variable by name from Haxe.
        Useful in bridge function closures to update multiple states at once:

        ```haxe
        new Button("Login", () -> {
            var result = doLogin(email.get(), password.get());
            State.setByName("userName", result.name);
            State.setByName("isLoggedIn", "true");
        })
        ```
    **/
    public static function setByName(key:String, value:String):Void {
        #if cpp
        untyped __cpp__('_hxsui_notify_swift({0}.utf8_str(), {1}.utf8_str())', key, value);
        #end
    }
}
