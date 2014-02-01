/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:36
 */
package stork.arbiter.request {
import stork.arbiter.ArbiterNode;
import stork.arbiter.player.PlayerNode;

public class Request {
    private var _arbiter:ArbiterNode    = null;
    private var _player:PlayerNode      = null;

    /** Arbiter which sent this request. */
    public function get arbiter():ArbiterNode { return _arbiter; }
    public function set arbiter(value:ArbiterNode):void { _arbiter = value; }

    /** Player which is currently processing this request. */
    public function get player():PlayerNode { return _player; }
    public function set player(value:PlayerNode):void { _player = value; }
}
}
