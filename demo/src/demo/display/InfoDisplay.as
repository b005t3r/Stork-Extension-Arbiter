/**
 * User: booster
 * Date: 03/02/14
 * Time: 9:41
 */
package demo.display {
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;
import starling.utils.VAlign;

public class InfoDisplay extends Sprite {
    private var _textField:TextField;

    public function InfoDisplay() {
        name = "InfoDisplay";

        x = 0; y = Root.WIDTH;
        width = Root.WIDTH; height = Root.HEIGHT - Root.WIDTH;

        _textField = new TextField(Root.WIDTH - 2 * Root.MARGIN, Root.HEIGHT - Root.WIDTH - 2 * Root.MARGIN, "Now you see me...", "Verdana", 12, Color.WHITE, true);
        _textField.hAlign = HAlign.CENTER; _textField.vAlign = VAlign.CENTER;
        _textField.x = Root.MARGIN; _textField.y = Root.MARGIN;
        addChild(_textField);

        for(var h:int = 0; h < 2; ++h) {
            var horizontal:Quad;

            horizontal = new Quad(Root.WIDTH - Root.MARGIN, Root.LINE_WIDTH, Color.WHITE);
            horizontal.x = Root.MARGIN / 2 - Root.LINE_WIDTH / 2; horizontal.y = Root.MARGIN / 2 - Root.LINE_WIDTH / 2 + h * (_textField.height + Root.MARGIN);
            addChild(horizontal);
        }

        for(var v:int = 0; v < 2; ++v) {
            var vertical:Quad;

            vertical = new Quad(Root.LINE_WIDTH, _textField.height + Root.MARGIN - Root.LINE_WIDTH / 2, Color.WHITE);
            vertical.x = Root.MARGIN / 2 - Root.LINE_WIDTH / 2 + v * (_textField.width + Root.MARGIN - Root.LINE_WIDTH); vertical.y = Root.MARGIN / 2;
            addChild(vertical);
        }
    }

    public function get text():String { return _textField.text; }
    public function set text(value:String):void { _textField.text = value; }
}
}
