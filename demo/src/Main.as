package {

import demo.display.BoardDisplayRefresherNode;
import demo.display.InfoDisplayRefresherNode;
import demo.display.Root;
import demo.logic.GameRestarterNode;
import demo.logic.player.human.MoveRequestPlugin;
import demo.logic.state.GameStateNode;
import demo.model.GameModelNode;

import flash.display.Sprite;

import stork.arbiter.AsyncArbiterNode;
import stork.arbiter.player.PlayerContainer;
import stork.arbiter.player.PluggablePlayerNode;
import stork.arbiter.state.StateContainer;

import stork.core.SceneNode;
import stork.event.SceneEvent;
import stork.starling.StarlingPlugin;

[SWF(width="320", height="380", backgroundColor="#666666", frameRate="60")]
public class Main extends Sprite {
    private var scene:SceneNode;

    public function Main() {
        scene = new SceneNode("Demo Scene");

        var starlingPlugin:StarlingPlugin = new StarlingPlugin(Root, this);
        scene.registerPlugin(starlingPlugin);

        scene.addNode(new GameModelNode());

        scene.addNode(new BoardDisplayRefresherNode());
        scene.addNode(new InfoDisplayRefresherNode());

        var arbiter:AsyncArbiterNode        = new AsyncArbiterNode("MainArbiter");
        var states:StateContainer           = new StateContainer();
        var players:PlayerContainer         = new PlayerContainer();
        var playerOne:PluggablePlayerNode   = new PluggablePlayerNode("PlayerOne");
        var playerTwo:PluggablePlayerNode   = new PluggablePlayerNode("PlayerTwo");

        playerOne.registerPlugin(new MoveRequestPlugin());
        playerTwo.registerPlugin(new MoveRequestPlugin());
        players.registerPlayer(playerOne);
        players.registerPlayer(playerTwo);

        states.pushState(new GameStateNode());

        arbiter.players = players;
        arbiter.states  = states;

        scene.addNode(arbiter);
        scene.addNode(players);
        scene.addNode(states);

        scene.addNode(new GameRestarterNode());

        scene.addEventListener(SceneEvent.SCENE_STARTED, onSceneStarted);

        scene.start();

        function onSceneStarted(event:SceneEvent):void {
            scene.removeEventListener(SceneEvent.SCENE_STARTED, onSceneStarted);

            arbiter.beginExecution();
        }
    }
}
}
