/**
 * User: booster
 * Date: 03/02/14
 * Time: 10:35
 */
package demo.logic.state {
import demo.model.*;
import demo.logic.request.MoveRequest;

import stork.arbiter.player.PlayerNode;

import stork.arbiter.state.StateNode;

public class TurnStateNode extends StateNode {
    private var _gameModel:GameModelNode = null;

    public function TurnStateNode() {
        super("TurnState");
    }

    public function get moveRequest():MoveRequest { return request as MoveRequest; }

    [GlobalReference("GameModel")]
    public function get gameModel():GameModelNode { return _gameModel; }
    public function set gameModel(value:GameModelNode):void { _gameModel = value; }

    override public function execute():* {
        var playerIndex:int     = _gameModel.currentSymbol == GameModelNode.O ? 0 : 1;
        var player:PlayerNode   = arbiter.players.getPlayer(playerIndex);

        return arbiter.sendRequestResult(new MoveRequest(), player);
    }

    override public function executeWithResponse():* {
        _gameModel.putSymbol(_gameModel.currentSymbol, moveRequest.x, moveRequest.y);

        return arbiter.executePreviousStateResult();
    }
}
}
