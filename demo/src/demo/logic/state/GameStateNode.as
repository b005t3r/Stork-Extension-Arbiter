/**
 * User: booster
 * Date: 03/02/14
 * Time: 10:33
 */
package demo.logic.state {
import demo.model.GameModelNode;

import stork.arbiter.state.StateNode;

public class GameStateNode extends StateNode {
    private var _gameModel:GameModelNode = null;

    public function GameStateNode() {
        super("GameState");
    }

    [GlobalReference("GameModel")]
    public function get gameModel():GameModelNode { return _gameModel; }
    public function set gameModel(value:GameModelNode):void { _gameModel = value;}

    override public function execute():* {
        // 1. check for victory
        var victorSymbol:int = getVictor();

        if(victorSymbol != GameModelNode.EMPTY || gameModel.boardFull) {
            gameModel.victorSymbol = victorSymbol;

            return arbiter.executeStateResult(new GameFinishedStateNode());
        }

        // 2. set current player
        _gameModel.currentSymbol = _gameModel.nextSymbol();

        // 3. let TurnState do its part
        return arbiter.executeStateResult(new TurnStateNode());
    }

    private function getVictor():int {
        var i:int;
        var sum:int = getRowSum(i);
        for(i = 0; i < 3; i++) {
            sum = getRowSum(i);

            if(sum / GameModelNode.O == 3)
                return GameModelNode.O;
            else if(sum / GameModelNode.X == 3)
                return GameModelNode.X;
        }

        for(i = 0; i < 3; i++) {
            sum = getColumnSum(i);

            if(sum / GameModelNode.O == 3)
                return GameModelNode.O;
            else if(sum / GameModelNode.X == 3)
                return GameModelNode.X;
        }

        sum = getLeftDiagonalSum();

        if(sum / GameModelNode.O == 3)
            return GameModelNode.O;
        else if(sum / GameModelNode.X == 3)
            return GameModelNode.X;

        sum = getRightDiagonalSum();

        if(sum / GameModelNode.O == 3)
            return GameModelNode.O;
        else if(sum / GameModelNode.X == 3)
            return GameModelNode.X;

        return GameModelNode.EMPTY;
    }

    private function getRowSum(row:int):int {
        return _gameModel.getSymbol(row, 0) + _gameModel.getSymbol(row, 1) + _gameModel.getSymbol(row, 2);
    }

    private function getColumnSum(col:int):int {
        return _gameModel.getSymbol(0, col) + _gameModel.getSymbol(1, col) + _gameModel.getSymbol(2, col);
    }

    private function getLeftDiagonalSum():int {
        return _gameModel.getSymbol(0, 0) + _gameModel.getSymbol(1, 1) + _gameModel.getSymbol(2, 2);
    }

    private function getRightDiagonalSum():int {
        return _gameModel.getSymbol(2, 0) + _gameModel.getSymbol(1, 1) + _gameModel.getSymbol(0, 2);
    }}
}
