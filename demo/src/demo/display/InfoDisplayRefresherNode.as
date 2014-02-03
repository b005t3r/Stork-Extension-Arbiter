/**
 * User: booster
 * Date: 03/02/14
 * Time: 12:13
 */
package demo.display {
import demo.logic.state.GameFinishedStateNode;
import demo.logic.state.GameStateNode;
import demo.logic.state.TurnStateNode;
import demo.model.GameModelNode;

import stork.arbiter.ArbiterNode;
import stork.core.Node;
import stork.event.ArbiterStateEvent;

public class InfoDisplayRefresherNode extends Node {
    private var _arbiter:ArbiterNode        = null;
    private var _gameModel:GameModelNode    = null;
    private var _infoDisplay:InfoDisplay    = null;

    public function InfoDisplayRefresherNode() {
        super("InfoDisplayRefresherNode");
    }

    [GlobalReference("MainArbiter")]
    public function get arbiter():ArbiterNode { return _arbiter; }
    public function set arbiter(value:ArbiterNode):void {
        if(_arbiter != null)
            _arbiter.removeEventListener(ArbiterStateEvent.WILL_SWITCH_STATE, onStateChange);

        _arbiter = value;

        if(_arbiter != null)
            _arbiter.addEventListener(ArbiterStateEvent.WILL_SWITCH_STATE, onStateChange);
    }

    [GlobalReference("GameModel")]
    public function get gameModel():GameModelNode { return _gameModel; }
    public function set gameModel(value:GameModelNode):void { _gameModel = value; }

    [StarlingReference("InfoDisplay")]
    public function get infoDisplay():InfoDisplay { return _infoDisplay; }
    public function set infoDisplay(value:InfoDisplay):void { _infoDisplay = value; }

    private function onStateChange(event:ArbiterStateEvent):void {
        // next turn
        if(event.currentState is GameStateNode && event.newState is TurnStateNode) {
            if(gameModel.currentSymbol == GameModelNode.O) {
                infoDisplay.text = "O, make your move.";
            }
            else if(gameModel.currentSymbol == GameModelNode.X) {
                infoDisplay.text = "X, it's your turn.";
            }
        }
        // game finished
        else if(event.currentState is GameStateNode && event.newState is GameFinishedStateNode) {
            if(gameModel.victorSymbol == GameModelNode.O) {
                infoDisplay.text = "O is the new Champion!";
            }
            else if(gameModel.victorSymbol == GameModelNode.X) {
                infoDisplay.text = "Glory to the new Champion, X!";
            }
            else {
                infoDisplay.text = "A tie! You are both equally awesome!";
            }
        }
    }
}
}
