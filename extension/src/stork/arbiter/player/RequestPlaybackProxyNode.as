/**
 * Created by User on 2016-06-01.
 */
package stork.arbiter.player {
import stork.arbiter.ArbiterNode;
import stork.arbiter.request.Request;
import stork.arbiter.request.RequestRecorderNode;

public class RequestPlaybackProxyNode extends PlayerNode {
    protected var _recorder:RequestRecorderNode;
    protected var _player:PlayerNode;

    public function RequestPlaybackProxyNode(recorder:RequestRecorderNode, player:PlayerNode) {
        super(player.name);

        _recorder   = recorder;
        _player     = player;

        addNode(_player);
    }

    override public function get arbiter():ArbiterNode { return _player.arbiter; }
    override public function set arbiter(value:ArbiterNode):void { _player.arbiter = value; }

    override public function get request():Request { return _player.request; }
    override public function set request(value:Request):void { _player.request = value; }

    override public function processRequest():* {
        if(_recorder.playbackActive)
            return _recorder.getNextRequest(_player);

        return _player.processRequest();
    }
}
}
