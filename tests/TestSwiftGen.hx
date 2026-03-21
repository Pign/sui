import sui.App;
import sui.View;
import sui.ui.*;
import sui.state.State;
import sui.state.StateAction;

/**
    Test app used by the test harness to verify Swift generation.
    The actual assertions happen in tests/run_tests.sh by comparing
    generated Swift output against expected files.
**/
class TestSwiftGen extends App {
    static function main() {}

    var count:State<Int>;

    public function new() {
        super();
        appName = "TestApp";
        bundleIdentifier = "com.test.app";
        count = new State<Int>(0, "count");
    }

    override function body():View {
        return new VStack([
            new Text("Hello")
                .font(FontStyle.LargeTitle)
                .padding(),
            Text.withState("Value: {count}")
                .bold(),
            new HStack(null, 10, [
                new Button("-", () -> count.set(count.get() - 1), StateAction.Decrement("count", 1)),
                new Button("+", () -> count.set(count.get() + 1), StateAction.Increment("count", 1))
            ]),
            new Spacer()
        ]);
    }
}
