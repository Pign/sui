import sui.ViewComponent;
import sui.View;
import sui.ui.*;

/**
    A reusable info card component.
    Takes simple data (no bindings).
**/
class InfoCard extends ViewComponent {
    public var title:String;
    public var subtitle:String;

    public function new(@:swiftLabel("title") title:String, @:swiftLabel("subtitle") subtitle:String) {
        super();
        this.title = title;
        this.subtitle = subtitle;
    }

    override function body():View {
        return new VStack([
            new Text(title)
                .font(FontStyle.Title2)
                .bold(),
            new Text(subtitle)
                .font(FontStyle.Subheadline)
                .foregroundColor(ColorValue.Secondary)
        ])
        .padding()
        .background(ColorValue.Gray)
        .cornerRadius(12);
    }
}
