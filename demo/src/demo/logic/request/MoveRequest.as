/**
 * User: booster
 * Date: 03/02/14
 * Time: 10:00
 */
package demo.logic.request {
import stork.arbiter.request.Request;

public class MoveRequest extends Request {
    private var _x:int = -1;
    private var _y:int = -1;

    public function get x():int { return _x; }
    public function set x(value:int):void { _x = value; }

    public function get y():int { return _y; }
    public function set y(value:int):void { _y = value; }}
}
