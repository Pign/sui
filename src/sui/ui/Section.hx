package sui.ui;

import sui.View;

class Section extends View {
    public var header:String;

    public function new(?header:String, content:Array<View>) {
        super();
        this.viewType = "Section";
        this.header = header;
        this.children = content;
    }
}
