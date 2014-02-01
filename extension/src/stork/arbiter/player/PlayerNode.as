/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:39
 */
package stork.arbiter.player {
import stork.arbiter.ArbiterNode;
import stork.arbiter.request.Request;
import stork.core.ContainerNode;

public class PlayerNode extends ContainerNode {
    protected var _arbiter:ArbiterNode  = null;
    protected var _request:Request      = null;

    public function PlayerNode(name:String = "Player") {
        super(name);
    }

    public function get arbiter():ArbiterNode { return _arbiter; }
    public function set arbiter(value:ArbiterNode):void { _arbiter = value; }

    public function get request():Request { return _request; }
    public function set request(value:Request):void { _request = value; }

    public function processRequest():* {
        throw new Error("this method has to be implemented by a subclass");
    }}
}
