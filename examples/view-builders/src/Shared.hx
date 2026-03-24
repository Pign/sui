import sui.View;
import sui.ui.*;

/**
    Reusable view builders — static functions that return View.
    These are inlined by the macro at compile time.
**/
class Shared {
    public static function header(title:String):View {
        return new Text(title)
            .font(FontStyle.LargeTitle)
            .padding();
    }

    public static function infoRow(label:String, value:String):View {
        return new HStack([
            new Text(label)
                .font(FontStyle.Headline),
            new Spacer(),
            new Text(value)
                .foregroundColor(ColorValue.Secondary)
        ]).padding();
    }
}
