/**
 * User: booster
 * Date: 01/02/14
 * Time: 16:40
 */
package stork.arbiter.phase {
import stork.arbiter.ArbiterNode;
import stork.arbiter.arbiter_internal;
import stork.arbiter.state.StateNode;

use namespace arbiter_internal;

public class ChangeStatePhase extends ExecutionPhase {
    internal var oldState:StateNode = null;
    internal var newState:StateNode = null;

    private var eventSent:Boolean = false;

    override arbiter_internal function run(arbiter:ArbiterNode):ExecutionPhase {
        if(! eventSent) {
            eventSent = true;

            arbiter.willSwitchStateEvent.currentState = oldState;
            arbiter.willSwitchStateEvent.newState = newState;

            arbiter.dispatchEvent(arbiter.willSwitchStateEvent);

            arbiter.willSwitchStateEvent.currentState = null;
            arbiter.willSwitchStateEvent.newState = null;
        }

        if(arbiter.isStopped())
            return null;

        if(arbiter.isPaused())
            return this;

        if(oldState == arbiter.states.currentState && newState == arbiter.states.previousState) {
            arbiter.states.popState();
        }
        else if(oldState != newState) {
            arbiter.states.pushState(newState);
        }

        if(newState != null) {
            arbiter.executeStatePhase.state = newState;

            return arbiter.executeStatePhase;
        }
        else {
            // this arbiter has finished its execution
            return null;
        }
    }

    override arbiter_internal function deactivate():void {
        eventSent = false;
        oldState = newState = null;
    }
}
}
