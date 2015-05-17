/**
 * User: booster
 * Date: 03/02/14
 * Time: 12:57
 */
package demo.logic {
import demo.display.BoardDisplay;
import demo.display.Root;
import demo.logic.state.GameFinishedStateNode;
import demo.model.GameModelNode;

import starling.events.Touch;

import starling.events.TouchEvent;
import starling.events.TouchPhase;

import stork.arbiter.ArbiterNode;
import stork.arbiter.state.StateContainerNode;
import stork.core.Node;
import stork.core.SceneNode;
import stork.event.ArbiterStateEvent;

public class GameRestarterNode extends Node {
    private var _arbiter:ArbiterNode        = null;
    private var _boardDisplay:BoardDisplay  = null;

    public function GameRestarterNode() {
        super("GameRestarterNode");
    }

    [GlobalReference("MainArbiter")]
    public function get arbiter():ArbiterNode { return _arbiter; }
    public function set arbiter(value:ArbiterNode):void {
        if(_arbiter != null)
            _arbiter.removeEventListener(ArbiterStateEvent.DID_EXECUTE_STATE, onStateExecuted);

        _arbiter = value;

        if(_arbiter != null)
            _arbiter.addEventListener(ArbiterStateEvent.DID_EXECUTE_STATE, onStateExecuted);
    }

    [StarlingReference("BoardDisplay")]
    public function get boardDisplay():BoardDisplay { return _boardDisplay; }
    public function set boardDisplay(value:BoardDisplay):void { _boardDisplay = value; }

    private function onStateExecuted(event:ArbiterStateEvent):void {
        if(event.currentState is GameFinishedStateNode == false)
            return;

        _boardDisplay.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    private function onTouch(event:TouchEvent):void {
        var touch:Touch = event.getTouch(boardDisplay, TouchPhase.ENDED);

        if(touch == null)
            return;

        boardDisplay.removeEventListener(TouchEvent.TOUCH, onTouch);

        restartGame();
    }

    private function restartGame():void {
        var scene:SceneNode = sceneNode;

        var gameModel:GameModelNode = scene.getNodeByName("GameModel") as GameModelNode;
        var states:StateContainerNode   = scene.getNodeByName("StateContainer") as StateContainerNode;

        states.popState(); // remove GameFinishedStateComponent

        scene.removeNode(gameModel); // now GameModelNode is unplugged from all referencing nodes
        scene.addNode(new GameModelNode()); // a new instance is plugged in to all referencing nodes

        for(var y:int = 0; y < 3; ++y)
            for(var x:int = 0; x < 3; ++x)
                boardDisplay.getImage(x, y).visible = false;

        arbiter.beginExecution();
    }
}
}
