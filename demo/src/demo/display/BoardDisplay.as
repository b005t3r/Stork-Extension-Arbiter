/**
 * User: booster
 * Date: 02/02/14
 * Time: 12:44
 */
package demo.display {
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;

public class BoardDisplay extends Sprite {
    private var _xTexture:Texture;
    private var _oTexture:Texture;

    public function BoardDisplay() {
        name = "BoardDisplay";

        var touchable:Quad = new Quad(Root.WIDTH, Root.WIDTH);
        touchable.alpha = 0;

        addChild(touchable);

        _xTexture = Texture.fromBitmap(new Assets.X(), false);
        _oTexture = Texture.fromBitmap(new Assets.O(), false);

        const size:Number = (Root.WIDTH - 4 * Root.MARGIN - 3) / 3;

        for(var y:int = 0; y < 3; ++y) {
            for(var x:int = 0; x < 3; ++x) {
                var img:Image = new Image(_xTexture);
                img.x = Root.MARGIN + x * (size + Root.MARGIN);
                img.y = Root.MARGIN + y * (size + Root.MARGIN);
                img.width = size; img.height = size;
                img.visible = false;
                img.touchable = true;

                addChild(img);
            }
        }

        for(var h:int = 0; h < 4; ++h) {
            var horizontal:Quad;

            horizontal = new Quad(Root.WIDTH - Root.MARGIN - Root.LINE_WIDTH / 2, Root.LINE_WIDTH, Color.WHITE);
            horizontal.x = Root.MARGIN / 2 - Root.LINE_WIDTH / 2; horizontal.y = Root.MARGIN / 2 - Root.LINE_WIDTH / 2 + h * (size + Root.MARGIN);
            addChild(horizontal);
        }

        for(var v:int = 0; v < 4; ++v) {
            var vertical:Quad;

            vertical = new Quad(Root.LINE_WIDTH, Root.WIDTH - Root.MARGIN - Root.LINE_WIDTH / 2, Color.WHITE);
            vertical.x = Root.MARGIN / 2 - Root.LINE_WIDTH / 2 + v * (size + Root.MARGIN); vertical.y = Root.MARGIN / 2 - Root.LINE_WIDTH / 2;
            addChild(vertical);
        }
    }

    public function get xTexture():Texture { return _xTexture; }
    public function get oTexture():Texture { return _oTexture; }

    public function getImage(x:int, y:int):Image { return getChildAt(1 + x + 3 * y) as Image; }
}
}
