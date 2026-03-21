package sui.state;

/**
    Represents a piece of reactive state in a view.
    When the C++ bridge is linked, `set()` automatically notifies Swift
    to update the corresponding SwiftUI state.
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
    public var value:T;
    public var name:String;

    private var onChange:Null<T->Void>;

    public function new(initialValue:T, ?name:String) {
        this.value = initialValue;
        this.name = name != null ? name : "";
    }

    public function get():T {
        return value;
    }

    /**
        Set a new value.
        If the C++ bridge is linked, this automatically updates SwiftUI state.
    **/
    public function set(newValue:T):Void {
        value = newValue;
        if (onChange != null) {
            onChange(newValue);
        }
        // Notify Swift via C bridge (weak symbol — no-op if bridge not linked)
        #if cpp
        var k = name;
        var v = Std.string(newValue);
        untyped __cpp__('_hxsui_notify_swift({0}.utf8_str(), {1}.utf8_str())', k, v);
        #end
    }

    public function onValueChanged(callback:T->Void):Void {
        onChange = callback;
    }
}
