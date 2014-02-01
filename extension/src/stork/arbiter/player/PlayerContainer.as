/**
 * User: booster
 * Date: 01/02/14
 * Time: 16:31
 */
package stork.arbiter.player {
import stork.core.ContainerNode;
import stork.core.Node;
import stork.event.Event;

public class PlayerContainer extends ContainerNode {
    public function PlayerContainer(name:String = "PlayerContainer") {
        super(name);

        addEventListener(Event.ADDED_TO_PARENT, onChildAdded);
    }

    public function registerPlayer(player:PlayerNode):void { addNode(player); }
    public function unregisterPlayer(player:PlayerNode):void { removeNode(player); }

    public function get playerCount():int { return nodeCount; }

    public function getPlayer(index:int):PlayerNode { return getNodeAt(index) as PlayerNode; }

    private function onChildAdded(event:Event):void {
        var child:Node = event.target as Node;

        if(child != null && child.parentNode == this && child is PlayerNode == false)
            throw new TypeError("PlayerContainer can only hold PlayerNodes");
    }
}
}
