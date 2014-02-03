/**
 * User: booster
 * Date: 01/02/14
 * Time: 16:37
 */
package stork.arbiter.phase {
import stork.arbiter.ArbiterNode;
import stork.arbiter.arbiter_internal;
import stork.arbiter.request.Request;
import stork.arbiter.state.StateNode;

use namespace arbiter_internal;

public class ExecuteStatePhase extends ExecutionPhase {
    arbiter_internal var state:StateNode    = null;
    private var result:*            = null;

    override arbiter_internal function run(arbiter:ArbiterNode):ExecutionPhase {
        if(result == null)
            result = executeState(arbiter);

        return processResult(result, arbiter);
    }

    override arbiter_internal function deactivate():void {
        state = result = null;
    }

    protected function executeState(arbiter:ArbiterNode):* {
        state.arbiter = arbiter;

        var response:* = state.execute();

        arbiter.dispatchEvent(arbiter.didExecuteStateEvent.resetEvent(state, null));

        state.arbiter = null;

        return response;
    }

    protected function processResult(response:*, arbiter:ArbiterNode):ExecutionPhase {
        if(response == arbiter.stopExecutionResult()) {
            arbiter.internalStop();

            return null;
        }
        else if(response == arbiter.executeCurrentStateResult()) {
            arbiter.changeStatePhase.oldState = state;
            arbiter.changeStatePhase.newState = state;

            return arbiter.changeStatePhase;
        }
        else if(response == arbiter.executePreviousStateResult()) {
            arbiter.changeStatePhase.oldState = state;
            arbiter.changeStatePhase.newState = arbiter.states.previousState;

            return arbiter.changeStatePhase;
        }
        else if(response is StateNode) {
            arbiter.changeStatePhase.oldState = state;
            arbiter.changeStatePhase.newState = response as StateNode;

            return arbiter.changeStatePhase;
        }
        else if(response is Request) {
            arbiter.sendRequestPhase.request = response as Request;

            return arbiter.sendRequestPhase;
        }
        else {
            throw new Error("invalid response: " + response);
        }
    }
}
}
