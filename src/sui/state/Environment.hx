package sui.state;

/**
    Provides access to environment values, similar to SwiftUI's `@Environment`.
    Environment values flow down the view hierarchy.
**/
class Environment<T> {
    public var key:String;
    public var defaultValue:T;

    private static var values:Map<String, Dynamic> = new Map();

    public function new(key:String, defaultValue:T) {
        this.key = key;
        this.defaultValue = defaultValue;
    }

    /** Get the current environment value. **/
    public function get():T {
        if (values.exists(key)) {
            return cast values.get(key);
        }
        return defaultValue;
    }

    /** Set an environment value (typically done at a parent view level). **/
    public static function setValue(key:String, value:Dynamic):Void {
        values.set(key, value);
    }

    /** Standard environment keys. **/
    public static inline var COLOR_SCHEME = "colorScheme";
    public static inline var DISMISS = "dismiss";
    public static inline var OPEN_URL = "openURL";
}
