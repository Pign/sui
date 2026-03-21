package sui.ui;

import sui.View;

/**
    A multi-line text input field.
    Maps to SwiftUI's `TextEditor`.

    The `textBinding` parameter is the name of a `@State` String variable to bind to.
**/
@:swiftView("TextEditor")
class TextEditor extends View {
    public var textBinding:String;

    public function new(@:swiftLabel("text") @:swiftBinding textBinding:String) {
        super();
        this.viewType = "TextEditor";
        this.textBinding = textBinding;
    }
}
