/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:46
 */
package stork.event {
import stork.arbiter.state.StateNode;

public class ArbiterStateEvent extends ArbiterEvent {
    public static var WILL_SWITCH_STATE:String                  = "willSwitchStateEvent";
    public static var DID_EXECUTE_STATE:String                  = "didExecuteStateEvent";
    public static var DID_EXECUTE_STATE_WITH_RESPONSE:String    = "didExecuteStateWithResponseEvent";

    private var _currentState:StateNode = null;
    private var _newState:StateNode     = null;

    public function ArbiterStateEvent(type:String) {
        super(type);
    }

    public function get currentState():StateNode { return _currentState; }
    public function get newState():StateNode { return _newState; }

    public function resetEvent(currentState:StateNode, newState:StateNode):ArbiterStateEvent {
        _currentState = currentState;
        _newState = newState;

        return reset() as ArbiterStateEvent;
    }
}
}
