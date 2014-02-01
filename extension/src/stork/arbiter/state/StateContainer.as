/**
 * User: booster
 * Date: 01/02/14
 * Time: 16:31
 */
package stork.arbiter.state {
import stork.core.ContainerNode;
import stork.core.Node;
import stork.event.Event;

public class StateContainer extends ContainerNode {
    public function StateContainer(name:String = "StateContainer") {
        super(name);

        addEventListener(Event.ADDED_TO_PARENT, onChildAdded);
    }

    public function pushState(state:StateNode):void { addNode(state); }

    public function popState():StateNode {
        var state:StateNode = getNodeAt(nodeCount - 1) as StateNode;
        removeNodeAt(nodeCount - 1);

        return state;
    }

    public function get currentState():StateNode {
        if(nodeCount == 0)
            return null;

        return getNodeAt(nodeCount - 1) as StateNode;
    }

    public function get previousState():StateNode {
        if(nodeCount <= 1)
            return null;

        return getNodeAt(nodeCount - 2) as StateNode;
    }

    public function get stateCount():int { return nodeCount; }

    private function onChildAdded(event:Event):void {
        var child:Node = event.target as Node;

        if(child != null && child.parentNode == this && child is StateNode == false)
            throw new TypeError("StateContainer can only hold StateNodes");
    }
}
}
