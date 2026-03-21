package sui.state;

/**
    Base class for observable data models.
    Maps to Swift's `@Observable` macro (Observation framework).

    Extend this class and declare public properties — changes will
    automatically trigger SwiftUI view updates.

    ```haxe
    class TodoModel extends Observable {
        public var items:Array<String> = [];
        public var newItemText:String = "";
    }
    ```

    Generates:
    ```swift
    @Observable
    class TodoModel {
        var items: [String] = []
        var newItemText: String = ""
    }
    ```
**/
class Observable {
    /** Internal: tracks which properties have been modified. **/
    private var _changedProperties:Array<String>;

    public function new() {
        _changedProperties = [];
    }

    /** Mark a property as changed. Called by generated setters. **/
    public function notifyPropertyChanged(propertyName:String):Void {
        if (_changedProperties.indexOf(propertyName) == -1) {
            _changedProperties.push(propertyName);
        }
    }

    /** Get and clear the list of changed properties. Used by the bridge. **/
    public function consumeChanges():Array<String> {
        var changes = _changedProperties.copy();
        _changedProperties = [];
        return changes;
    }
}
