import sui.App;
import sui.View;
import sui.ui.*;

/**
    Demonstrates LazyVGrid, ContentUnavailableView, ConditionalView,
    onLongPressGesture, and listStyle.
**/
class GridApp extends App {
    static function main() {}

    @:state var selectedItem:String = "";
    @:state var showEmpty:Bool = false;

    public function new() {
        super();
        appName = "GridGallery";
        bundleIdentifier = "com.sui.gridgallery";
    }

    override function body():View {
        return new NavigationStack(
            new VStack([
                new HStack(null, 10, [
                    new Text("Grid Gallery")
                        .font(FontStyle.LargeTitle),
                    new Spacer(),
                    new Button("Toggle Empty", () -> showEmpty = !showEmpty)
                ]).padding(),

                new ConditionalView(showEmpty_,
                    // Empty state
                    new ContentUnavailableView("No Photos", "photo.on.rectangle.angled", "Import photos to see them here."),

                    // Grid of items
                    new ScrollView([
                        new LazyVGrid(3, 8, [
                            new GroupBox("Mountains", [
                                new Image("photo")
                                    .foregroundColor(ColorValue.Blue)
                                    .font(FontStyle.Title)
                            ]).onTapGesture(() -> selectedItem = "Mountains"),

                            new GroupBox("Ocean", [
                                new Image("photo")
                                    .foregroundColor(ColorValue.Green)
                                    .font(FontStyle.Title)
                            ]).onTapGesture(() -> selectedItem = "Ocean"),

                            new GroupBox("Forest", [
                                new Image("photo")
                                    .foregroundColor(ColorValue.Orange)
                                    .font(FontStyle.Title)
                            ]).onTapGesture(() -> selectedItem = "Forest"),

                            new GroupBox("Desert", [
                                new Image("photo")
                                    .foregroundColor(ColorValue.Red)
                                    .font(FontStyle.Title)
                            ]).onLongPressGesture(() -> selectedItem = "Desert (long press!)"),

                            new GroupBox("City", [
                                new Image("photo")
                                    .foregroundColor(ColorValue.Purple)
                                    .font(FontStyle.Title)
                            ]).onTapGesture(() -> selectedItem = "City"),

                            new GroupBox("Lake", [
                                new Image("photo")
                                    .foregroundColor(ColorValue.Gray)
                                    .font(FontStyle.Title)
                            ]).onTapGesture(() -> selectedItem = "Lake")
                        ])
                    ]).padding()
                ),

                Text.bind('Selected: $selectedItem')
                    .font(FontStyle.Headline)
                    .foregroundColor(ColorValue.Secondary)
                    .padding()
            ]).navigationTitle("Gallery")
        );
    }
}
