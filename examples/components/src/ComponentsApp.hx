import sui.App;
import sui.View;
import sui.ui.*;
import sui.state.State;
import sui.state.StateAction;

class ComponentsApp extends App {
    static function main() {}

    var movieRating:State<Int>;
    var bookRating:State<Int>;

    public function new() {
        super();
        appName = "Components";
        bundleIdentifier = "com.sui.components";
        movieRating = new State<Int>(3, "movieRating");
        bookRating = new State<Int>(4, "bookRating");
    }

    override function body():View {
        return new NavigationStack(
            new VStack(null, 20, [
                // Reusable InfoCard component (no bindings)
                new InfoCard("Sui", "Build native apps in Haxe"),
                new InfoCard("Components", "Reusable views with @Binding"),

                // Reusable StarRating component (with @Binding)
                new StarRating("Movie:", "movieRating"),
                new StarRating("Book:", "bookRating"),

                // Buttons to modify ratings
                new HStack(null, 12, [
                    new Button("Movie +", null, StateAction.Increment("movieRating", 1)),
                    new Button("Movie -", null, StateAction.Decrement("movieRating", 1)),
                    new Button("Book +", null, StateAction.Increment("bookRating", 1)),
                    new Button("Book -", null, StateAction.Decrement("bookRating", 1)),
                ])
            ]).padding()
            .navigationTitle("Components")
        );
    }
}
