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

    /** Registry of State instances by name, for shared-memory bridge queries. **/
    private static var _registry:Map<String, Dynamic> = new Map();

    public function new(initialValue:T, ?name:String) {
        this._value = initialValue;
        this.name = name != null ? name : "";
        if (this.name != "")
            _registry.set(this.name, this);
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
        // For arrays, send empty string — Swift reads data via shared memory
        var v = if (Std.isOfType(newValue, Array)) "" else Std.string(newValue);
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

    // ── Shared-memory query API (called from C bridge) ──────────────

    /** Get array length for a named state. Returns -1 if not found or not an array. **/
    public static function _getArrayLength(stateName:String):Int {
        if (stateName == null) return -1;
        var state:Dynamic = _registry.get(stateName);
        if (state == null) return -1;
        var val:Dynamic = state._value;
        if (val == null) return 0;
        if (Std.isOfType(val, Array)) {
            var arr:Array<Dynamic> = val;
            return arr.length;
        }
        return -1;
    }

    /** Get a string element from a named array state. **/
    public static function _getArrayStringElement(stateName:String, index:Int):String {
        var arr = _getArrayDynamic(stateName);
        if (arr == null || index < 0 || index >= arr.length) return "";
        var el:Dynamic = arr[index];
        return el != null ? Std.string(el) : "";
    }

    /** Get an int element from a named array state. **/
    public static function _getArrayIntElement(stateName:String, index:Int):Int {
        var arr = _getArrayDynamic(stateName);
        if (arr == null || index < 0 || index >= arr.length) return 0;
        var el:Dynamic = arr[index];
        return el != null ? cast(el, Int) : 0;
    }

    /** Get a float element from a named array state. **/
    public static function _getArrayFloatElement(stateName:String, index:Int):Float {
        var arr = _getArrayDynamic(stateName);
        if (arr == null || index < 0 || index >= arr.length) return 0.0;
        var el:Dynamic = arr[index];
        return el != null ? cast(el, Float) : 0.0;
    }

    /** Get a bool element from a named array state. **/
    public static function _getArrayBoolElement(stateName:String, index:Int):Bool {
        var arr = _getArrayDynamic(stateName);
        if (arr == null || index < 0 || index >= arr.length) return false;
        var el:Dynamic = arr[index];
        return el != null ? cast(el, Bool) : false;
    }

    /** Get a string field from an object at an index in a named array state. **/
    public static function _getObjectField(stateName:String, index:Int, fieldName:String):String {
        if (fieldName == null) return "";
        var arr = _getArrayDynamic(stateName);
        if (arr == null || index < 0 || index >= arr.length) return "";
        var obj:Dynamic = arr[index];
        if (obj == null) return "";
        var val:Dynamic = Reflect.field(obj, fieldName);
        return val != null ? Std.string(val) : "";
    }

    /** Get an int field from an object at an index in a named array state. **/
    public static function _getObjectIntField(stateName:String, index:Int, fieldName:String):Int {
        if (fieldName == null) return 0;
        var arr = _getArrayDynamic(stateName);
        if (arr == null || index < 0 || index >= arr.length) return 0;
        var obj:Dynamic = arr[index];
        if (obj == null) return 0;
        var val:Dynamic = Reflect.field(obj, fieldName);
        return val != null ? cast(val, Int) : 0;
    }

    /** Get a float field from an object at an index in a named array state. **/
    public static function _getObjectFloatField(stateName:String, index:Int, fieldName:String):Float {
        if (fieldName == null) return 0.0;
        var arr = _getArrayDynamic(stateName);
        if (arr == null || index < 0 || index >= arr.length) return 0.0;
        var obj:Dynamic = arr[index];
        if (obj == null) return 0.0;
        var val:Dynamic = Reflect.field(obj, fieldName);
        return val != null ? cast(val, Float) : 0.0;
    }

    /** Get a bool field from an object at an index in a named array state. **/
    public static function _getObjectBoolField(stateName:String, index:Int, fieldName:String):Bool {
        if (fieldName == null) return false;
        var arr = _getArrayDynamic(stateName);
        if (arr == null || index < 0 || index >= arr.length) return false;
        var obj:Dynamic = arr[index];
        if (obj == null) return false;
        var val:Dynamic = Reflect.field(obj, fieldName);
        return val != null ? cast(val, Bool) : false;
    }

    /** Internal: get the Dynamic array from a named state, or null. **/
    private static function _getArrayDynamic(stateName:String):Array<Dynamic> {
        if (stateName == null) return null;
        var state:Dynamic = _registry.get(stateName);
        if (state == null) return null;
        var val:Dynamic = state._value;
        if (val == null) return null;
        if (Std.isOfType(val, Array)) return cast val;
        return null;
    }

    /**
        Update a SwiftUI state variable by name from Haxe.
        Useful in bridge function closures to update multiple states at once.
    **/
    public static function setByName(key:String, value:String):Void {
        #if cpp
        untyped __cpp__('_hxsui_notify_swift({0}.utf8_str(), {1}.utf8_str())', key, value);
        #end
    }
}
