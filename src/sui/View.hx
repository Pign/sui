package sui;

import sui.modifiers.ViewModifier;

/**
    Base type representing a SwiftUI view.
    All UI components extend this class.
    Views are compile-time only — they build an AST that macros convert to Swift.
**/
class View {
    public var viewType:String;
    public var children:Array<View>;
    public var modifierChain:Array<ViewModifier>;
    public var properties:Map<String, Dynamic>;

    public function new() {
        children = [];
        modifierChain = [];
        properties = new Map();
        viewType = Type.getClassName(Type.getClass(this));
    }

    /** Override in subclasses to define the view body. **/
    public function body():View {
        return this;
    }

    // --- Modifier methods (return self for chaining) ---

    public function padding(?value:Float):View {
        if (value != null)
            modifierChain.push(ViewModifier.Padding(value));
        else
            modifierChain.push(ViewModifier.PaddingDefault);
        return this;
    }

    public function font(style:FontStyle):View {
        modifierChain.push(ViewModifier.Font(style));
        return this;
    }

    public function foregroundColor(color:ColorValue):View {
        modifierChain.push(ViewModifier.ForegroundColor(color));
        return this;
    }

    public function frame(?width:Float, ?height:Float, ?alignment:Alignment):View {
        modifierChain.push(ViewModifier.Frame(width, height, alignment));
        return this;
    }

    public function background(color:ColorValue):View {
        modifierChain.push(ViewModifier.Background(color));
        return this;
    }

    public function cornerRadius(radius:Float):View {
        modifierChain.push(ViewModifier.CornerRadius(radius));
        return this;
    }

    public function opacity(value:Float):View {
        modifierChain.push(ViewModifier.Opacity(value));
        return this;
    }

    public function bold():View {
        modifierChain.push(ViewModifier.Bold);
        return this;
    }

    public function italic():View {
        modifierChain.push(ViewModifier.Italic);
        return this;
    }

    public function multilineTextAlignment(alignment:TextAlignment):View {
        modifierChain.push(ViewModifier.MultilineTextAlignment(alignment));
        return this;
    }

    public function navigationTitle(title:String):View {
        modifierChain.push(ViewModifier.NavigationTitle(title));
        return this;
    }

    public function disabled(isDisabled:Bool = true):View {
        modifierChain.push(ViewModifier.Disabled(isDisabled));
        return this;
    }

    public function lineLimit(lines:Int):View {
        modifierChain.push(ViewModifier.LineLimit(lines));
        return this;
    }

    public function textFieldStyle(style:TextFieldStyleValue):View {
        modifierChain.push(ViewModifier.TextFieldStyle(style));
        return this;
    }

    public function searchable(textBinding:String, ?prompt:String):View {
        modifierChain.push(ViewModifier.Searchable(textBinding, prompt));
        return this;
    }

    public function sheet(isPresentedBinding:String, content:View):View {
        modifierChain.push(ViewModifier.Sheet(isPresentedBinding, content));
        return this;
    }

    public function alert(title:String, isPresentedBinding:String, ?message:String):View {
        modifierChain.push(ViewModifier.Alert(title, isPresentedBinding, message));
        return this;
    }

    public function confirmationDialog(title:String, isPresentedBinding:String, content:View):View {
        modifierChain.push(ViewModifier.ConfirmationDialog(title, isPresentedBinding, content));
        return this;
    }

    public function toolbar(content:View):View {
        modifierChain.push(ViewModifier.Toolbar(content));
        return this;
    }

    /** Add a toolbar item with a specific placement. **/
    public function toolbarItem(placement:String, content:View):View {
        modifierChain.push(ViewModifier.ToolbarItem(placement, content));
        return this;
    }

    public function animation(value:String):View {
        modifierChain.push(ViewModifier.Animation(value));
        return this;
    }

    public function overlay(content:View):View {
        modifierChain.push(ViewModifier.Overlay(content));
        return this;
    }

    /** Define a navigation destination for String-based programmatic navigation. **/
    public function navigationDestination(content:View):View {
        modifierChain.push(ViewModifier.NavigationDestination(content));
        return this;
    }

    /** Add a tap gesture with a declarative StateAction. **/
    public function onTapGesture(action:sui.state.StateAction):View {
        modifierChain.push(ViewModifier.OnTapGesture(action));
        return this;
    }

    /** Set the tint/accent color for this view and its children. **/
    public function tint(color:ColorValue):View {
        modifierChain.push(ViewModifier.Tint(color));
        return this;
    }

    /** Add a badge to a tab item or list row. **/
    public function badge(value:Dynamic):View {
        modifierChain.push(ViewModifier.Badge(value));
        return this;
    }

    /** Tag a view with a value for use in Picker selection. **/
    public function tag(value:String):View {
        modifierChain.push(ViewModifier.Tag(value));
        return this;
    }

    /** Run a StateAction when the view appears. **/
    public function onAppearAction(action:sui.state.StateAction):View {
        modifierChain.push(ViewModifier.OnAppearAction(action));
        return this;
    }

    /** Run a StateAction as an async task when the view appears. **/
    public function taskAction(action:sui.state.StateAction):View {
        modifierChain.push(ViewModifier.TaskAction(action));
        return this;
    }

    /** Run a closure when the view appears. Runs in Haxe via the bridge. **/
    public function onAppear(action:() -> Void):View {
        var actionId = sui.ui.Button._nextActionId++;
        sui.ui.Button._actionRegistry.set(actionId, action);
        modifierChain.push(ViewModifier.OnAppear(actionId));
        return this;
    }

    /** Run a closure when the view disappears. Runs in Haxe via the bridge. **/
    public function onDisappear(action:() -> Void):View {
        var actionId = sui.ui.Button._nextActionId++;
        sui.ui.Button._actionRegistry.set(actionId, action);
        modifierChain.push(ViewModifier.OnDisappear(actionId));
        return this;
    }

    /** Run an async closure when the view appears. Runs in Haxe via the bridge. **/
    public function task(action:() -> Void):View {
        var actionId = sui.ui.Button._nextActionId++;
        sui.ui.Button._actionRegistry.set(actionId, action);
        modifierChain.push(ViewModifier.TaskOnAppear(actionId));
        return this;
    }
}

enum FontStyle {
    LargeTitle;
    Title;
    Title2;
    Title3;
    Headline;
    Subheadline;
    Body;
    Callout;
    Footnote;
    Caption;
    Caption2;
    Custom(name:String, size:Float);
}

enum ColorValue {
    Primary;
    Secondary;
    Accent;
    Red;
    Orange;
    Yellow;
    Green;
    Blue;
    Purple;
    Pink;
    White;
    Black;
    Gray;
    Clear;
    Custom(hex:String);
}

enum Alignment {
    Center;
    Leading;
    Trailing;
    Top;
    Bottom;
    TopLeading;
    TopTrailing;
    BottomLeading;
    BottomTrailing;
}

enum TextAlignment {
    Leading;
    Center;
    Trailing;
}

enum TextFieldStyleValue {
    Automatic;
    RoundedBorder;
    Plain;
}
