/**
 * User: booster
 * Date: 03/02/14
 * Time: 10:12
 */
package stork.arbiter.player.plugin {
import stork.arbiter.ArbiterNode;
import stork.arbiter.player.PluggablePlayerNode;
import stork.arbiter.request.Request;
import stork.core.Node;

public class PlayerPluginNode extends Node {
    public function PlayerPluginNode(name:String = "PlayerPlugin") {
        super(name);
    }

    // abstract methods

    public function canHandleRequest(request:Request):Boolean {
        throw new Error("this method has to be implemented by a subclass");
    }

    public function processRequest():* {
        throw new Error("this method has to be implemented by a subclass");
    }

    // implemented methods

    public function get player():PluggablePlayerNode { return parentNode as PluggablePlayerNode; }

    public function activate():void {}
    public function deactivate():void {}

    public function get arbiter():ArbiterNode { return player.arbiter; }
    public function set arbiter(value:ArbiterNode):void { player.arbiter = value; }

    public function get request():Request { return player.request; }
    public function set request(value:Request):void { player.request = value; }
}
}
