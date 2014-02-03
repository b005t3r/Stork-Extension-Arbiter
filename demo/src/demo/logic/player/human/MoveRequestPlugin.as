/**
 * User: booster
 * Date: 03/02/14
 * Time: 10:18
 */
package demo.logic.player.human {
import demo.display.BoardDisplay;
import demo.logic.request.MoveRequest;
import demo.model.GameModelNode;

import starling.display.DisplayObject;

import starling.display.Image;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import stork.arbiter.player.plugin.PlayerPluginNode;
import stork.arbiter.request.Request;

public class MoveRequestPlugin extends PlayerPluginNode {
    private var _gameModel:GameModelNode = null;
    private var _boardDisplay:BoardDisplay = null;

    public function MoveRequestPlugin() {
        super("MoveRequestPlugin");
    }

    [GlobalReference("GameModel")]
    public function get gameModel():GameModelNode { return _gameModel; }

    public function set gameModel(value:GameModelNode):void { _gameModel = value;}

    [StarlingReference("BoardDisplay")]
    public function get boardDisplay():BoardDisplay { return _boardDisplay; }

    public function set boardDisplay(value:BoardDisplay):void { _boardDisplay = value; }

    public function get moveRequest():MoveRequest { return request as MoveRequest; }

    override public function canHandleRequest(request:Request):Boolean { return request is MoveRequest; }

    override public function processRequest():* {
        if(moveRequest.x == -1 && moveRequest.y == -1) {
            boardDisplay.addEventListener(TouchEvent.TOUCH, onTouch);

            return arbiter.pauseExecutionResponse(); // let the user select a unoccupied space
        }
        else {
            boardDisplay.removeEventListener(TouchEvent.TOUCH, onTouch);

            return arbiter.requestProcessedResponse(request);
        }
    }

    private function onTouch(event:TouchEvent):void {
        var touch:Touch = event.getTouch(boardDisplay, TouchPhase.ENDED);

        if(touch == null) return;

        var child:DisplayObject = boardDisplay.hitTest(touch.getLocation(boardDisplay));

        if(child == null)
            return;

        for(var y:int = 0; y < 3; ++y) {
            for(var x:int = 0; x < 3; ++x) {
                var img:Image = boardDisplay.getImage(x, y);

                if(child != img || gameModel.getSymbol(x, y) != GameModelNode.EMPTY)
                    continue;

                moveRequest.x = x;
                moveRequest.y = y;

                arbiter.resumeExecution();
                break;
            }
        }
    }
}
}
