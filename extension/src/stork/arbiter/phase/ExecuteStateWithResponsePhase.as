/**
 * User: booster
 * Date: 01/02/14
 * Time: 16:40
 */
package stork.arbiter.phase {
import stork.arbiter.ArbiterNode;
import stork.arbiter.arbiter_internal;
import stork.arbiter.request.Request;

use namespace arbiter_internal;

public class ExecuteStateWithResponsePhase extends ExecuteStatePhase {
    arbiter_internal var response:Request = null;

    override arbiter_internal function deactivate():void {
        response = null;

        super.deactivate();
    }

    override protected function executeState(arbiter:ArbiterNode):* {
        state.arbiter = arbiter;
        state.request = response;

        var result:* = state.executeWithResponse();

        arbiter.dispatchEvent(arbiter.didExecuteStateWithResponseEvent.resetEvent(state, null));

        state.arbiter = null;
        state.request = null;

        return result;
    }
}
}
