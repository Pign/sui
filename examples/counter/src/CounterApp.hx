import sui.App;
import sui.View;
import sui.ui.*;
import sui.state.State;
import sui.state.StateAction;

class CounterApp extends App {
    static function main() {}

    var count:State<Int>;

    public function new() {
        super();
        appName = "Counter";
        bundleIdentifier = "com.haxeapple.counter";
        count = new State<Int>(0, "count");
    }

    override function body():View {
        return new VStack([
            Text.withState("Count: {count}")
                .font(FontStyle.Title)
                .padding(),
            new HStack(null, 20, [
                new Button("-", () -> count.set(count.get() - 1), StateAction.Decrement("count", 1)),
                new Button("+", () -> count.set(count.get() + 1), StateAction.Increment("count", 1))
            ])
        ]);
    }
}
