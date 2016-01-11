/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:36
 */
package stork.arbiter.request {
import medkit.object.ObjectInputStream;
import medkit.object.ObjectOutputStream;

import stork.arbiter.ArbiterNode;
import stork.arbiter.player.PlayerNode;
import medkit.object.Equalable;
import medkit.object.Serializable;

public class Request implements Equalable, Serializable {
    private var _arbiter:ArbiterNode    = null;
    private var _player:PlayerNode      = null;

    /** Arbiter which sent this request. */
    public function get arbiter():ArbiterNode { return _arbiter; }
    public function set arbiter(value:ArbiterNode):void { _arbiter = value; }

    /** Player which is currently processing this request. */
    public function get player():PlayerNode { return _player; }
    public function set player(value:PlayerNode):void { _player = value; }

    /** Serializable */
    public function readObject(input:ObjectInputStream):void {}
    public function writeObject(output:ObjectOutputStream):void {}

    /** Equalable */
    public function equals(object:Equalable):Boolean
    {
        if (!(object is Request))
            return false;

        return true;
    }
}
}
