/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:35
 */
package stork.event {
import stork.arbiter.player.PlayerNode;
import stork.arbiter.request.Request;

public class ArbiterPlayerEvent extends ArbiterEvent {
    public static var WILL_PROCESS_REQUEST:String   = "willProcessRequestEvent";
    public static var DID_PROCESS_REQUEST:String    = "didProcessRequestEvent";

    private var _request:Request    = null;
    private var _player:PlayerNode  = null;

    public function ArbiterPlayerEvent(type:String) {
        super(type);
    }

    public function get request():Request { return _request; }
    public function get player():PlayerNode { return _player; }

    public function resetEvent(player:PlayerNode, request:Request):ArbiterPlayerEvent {
        _player = player;
        _request = request;

        return reset() as ArbiterPlayerEvent;
    }
}
}
