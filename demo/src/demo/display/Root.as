/**
 * User: booster
 * Date: 02/02/14
 * Time: 12:43
 */
package demo.display {
import starling.display.StorkRoot;
import starling.events.Event;

public class Root extends StorkRoot {
    public static const WIDTH:Number    = 320;
    public static const HEIGHT:Number   = 380;

    public static const MARGIN:Number = 20;

    public static const LINE_WIDTH:Number = 2;

    public function Root() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        addChild(new BoardDisplay());
        addChild(new InfoDisplay());
    }
}
}
