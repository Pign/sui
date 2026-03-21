import sui.App;
import sui.View;
import sui.ui.*;
import sui.state.State;
import sui.state.StateAction;

class NavApp extends App {
    static function main() {}

    public function new() {
        super();
        appName = "Navigation";
        bundleIdentifier = "com.haxeapple.navigation";
    }

    override function body():View {
        return new NavigationStack(
            new List([
                new Section("Declarative Navigation", [
                    new NavigationLink("Simple Detail",
                        new VStack(null, 20, [
                            new Text("Detail View")
                                .font(FontStyle.LargeTitle),
                            new Text("Pushed via NavigationLink")
                                .foregroundColor(ColorValue.Secondary)
                        ]).navigationTitle("Detail")
                    ),
                    new NavigationLink("Settings Page",
                        new Form([
                            new Section("Account", [
                                new Text("User: Haxe Developer")
                                    .font(FontStyle.Body),
                                new Text("Plan: Pro")
                                    .foregroundColor(ColorValue.Secondary)
                            ]),
                            new Section("About", [
                                new Text("Built with sui")
                                    .font(FontStyle.Caption)
                            ])
                        ]).navigationTitle("Settings")
                    ),
                    new NavigationLink("Nested Navigation",
                        new List([
                            new NavigationLink("Level 2",
                                new VStack([
                                    new Text("Two levels deep!")
                                        .font(FontStyle.Title),
                                    new NavigationLink("Level 3",
                                        new Text("Three levels deep!")
                                            .font(FontStyle.LargeTitle)
                                            .navigationTitle("Level 3")
                                    )
                                ]).navigationTitle("Level 2")
                            )
                        ]).navigationTitle("Nested")
                    )
                ])
            ]).navigationTitle("Navigation Demo")
        );
    }
}
