package sui.ui;

import sui.View;

/**
    A view that displays one or more lines of read-only text.
    Maps to SwiftUI's `Text` view.

    For state interpolation, use `Text.withState()` which generates
    Swift string interpolation referencing @State vars.
**/
class Text extends View {
    public var content:String;

    /** If set, this is a Swift expression used instead of a literal string. **/
    public var swiftExpression:Null<String>;

    public function new(text:String) {
        super();
        this.content = text;
        this.viewType = "Text";
    }

    /**
        Create a text view that interpolates a state variable.
        `template` uses `{stateName}` placeholders, e.g. "Count: {count}"
    **/
    public static function withState(template:String):Text {
        var t = new Text("");
        // Convert {name} to Swift's \(name) interpolation
        var swiftExpr = new StringBuf();
        swiftExpr.add('"');
        var i = 0;
        while (i < template.length) {
            var ch = template.charAt(i);
            if (ch == "{") {
                var end = template.indexOf("}", i);
                if (end != -1) {
                    var varName = template.substr(i + 1, end - i - 1);
                    swiftExpr.add("\\(");
                    swiftExpr.add(varName);
                    swiftExpr.add(")");
                    i = end + 1;
                    continue;
                }
            }
            if (ch == '"') swiftExpr.add('\\');
            swiftExpr.add(ch);
            i++;
        }
        swiftExpr.add('"');
        t.swiftExpression = swiftExpr.toString();
        t.content = template;
        return t;
    }
}
