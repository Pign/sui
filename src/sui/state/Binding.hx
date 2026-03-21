package sui.state;

/**
    A two-way binding to a piece of state.
    Maps to SwiftUI's `@Binding` property wrapper.

    Allows child views to read and write a parent's state.
**/
class Binding<T> {
    private var getter:() -> T;
    private var setter:T->Void;

    public function new(getter:() -> T, setter:T->Void) {
        this.getter = getter;
        this.setter = setter;
    }

    /** Get the bound value. **/
    public var value(get, set):T;

    function get_value():T {
        return getter();
    }

    function set_value(v:T):T {
        setter(v);
        return v;
    }

    /** Create a binding from a State. **/
    public static function fromState<T>(state:State<T>):Binding<T> {
        return new Binding<T>(() -> state.get(), (v) -> state.set(v));
    }
}
