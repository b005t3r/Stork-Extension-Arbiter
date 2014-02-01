/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:49
 */
package stork.arbiter.state {
import stork.arbiter.ArbiterNode;
import stork.arbiter.request.Request;
import stork.core.Node;

public class StateNode extends Node {
    private var _arbiter:ArbiterNode    = null;
    private var _request:Request        = null;

    public function StateNode(name:String = "StateNode") {
        super(name);
    }

    public function execute():* {
        throw new Error("this method has to be implemented by a subclass");
    }

    public function executeWithResponse():* {
        throw new Error("this method has to be implemented by a subclass");
    }

    public function get arbiter():ArbiterNode { return _arbiter; }
    public function set arbiter(value:ArbiterNode):void { _arbiter = value; }

    public function get request():Request { return _request; }
    public function set request(value:Request):void { _request = value; }
}
}
