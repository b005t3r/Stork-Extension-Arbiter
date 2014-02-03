/**
 * User: booster
 * Date: 03/02/14
 * Time: 12:05
 */
package demo.display {
import demo.logic.request.MoveRequest;
import demo.logic.state.TurnStateNode;
import demo.model.GameModelNode;

import starling.display.Image;

import stork.arbiter.ArbiterNode;
import stork.core.Node;
import stork.event.ArbiterStateEvent;

public class BoardDisplayRefresherNode extends Node {
    private var _arbiter:ArbiterNode        = null;
    private var _gameModel:GameModelNode    = null;
    private var _boardDisplay:BoardDisplay  = null;

    public function BoardDisplayRefresherNode() {
        super("BoardDisplayRefresherNode");
    }

    [GlobalReference("MainArbiter")]
    public function get arbiter():ArbiterNode { return _arbiter; }
    public function set arbiter(value:ArbiterNode):void {
        if(_arbiter != null)
            _arbiter.removeEventListener(ArbiterStateEvent.DID_EXECUTE_STATE_WITH_RESPONSE, onStateExecutedWithResponse);

        _arbiter = value;

        if(_arbiter != null)
            _arbiter.addEventListener(ArbiterStateEvent.DID_EXECUTE_STATE_WITH_RESPONSE, onStateExecutedWithResponse);
    }

    [GlobalReference("GameModel")]
    public function get gameModel():GameModelNode { return _gameModel; }
    public function set gameModel(value:GameModelNode):void { _gameModel = value; }

    [StarlingReference("BoardDisplay")]
    public function get boardDisplay():BoardDisplay { return _boardDisplay; }
    public function set boardDisplay(value:BoardDisplay):void { _boardDisplay = value; }

    private function onStateExecutedWithResponse(event:ArbiterStateEvent):void {
        if(event.currentState is TurnStateNode == false || event.currentState.request is MoveRequest == false)
            return;

        refreshDisplays();
    }

    private function refreshDisplays():void {
        for(var y:int = 0; y < 3; y++) {
            for(var x:int = 0; x < 3; x++) {
                var symbol:int = _gameModel.getSymbol(x, y);

                var box:Image = boardDisplay.getImage(x, y);

                switch(symbol) {
                    case GameModelNode.O:
                        box.texture = boardDisplay.oTexture;
                        box.visible = true;
                        break;

                    case GameModelNode.X:
                        box.texture = boardDisplay.xTexture;
                        box.visible = true;
                        break;

                    default:
                        box.visible = false;
                        break;
                }
            }
        }
    }
}
}
