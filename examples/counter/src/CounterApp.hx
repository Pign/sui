import sui.App;
import sui.View;
import sui.ui.*;
import sui.state.StateAction;

class CounterApp extends App {
    static function main() {}

    @:state var count:Int = 0;

    public function new() {
        super();
        appName = "Counter";
        bundleIdentifier = "com.sui.counter";
    }

    override function body():View {
        return new VStack([
            Text.withState("Count: {count}")
                .font(FontStyle.Title)
                .padding(),
            new HStack(null, 20, [
                new Button("-", () -> count.value = count.value - 1, StateAction.Decrement("count", 1)),
                new Button("+", () -> count.value = count.value + 1, StateAction.Increment("count", 1))
            ])
        ]);
    }
}
