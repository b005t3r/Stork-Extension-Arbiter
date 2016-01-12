/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:34
 */
package stork.arbiter {
import stork.arbiter.phase.ChangeStatePhase;
import stork.arbiter.phase.ExecuteStatePhase;
import stork.arbiter.phase.ExecuteStateWithResponsePhase;
import stork.arbiter.phase.ExecutionPhase;
import stork.arbiter.phase.SendRequestPhase;
import stork.arbiter.player.PlayerContainerNode;
import stork.arbiter.player.PlayerNode;
import stork.arbiter.request.Request;
import stork.arbiter.state.StateContainerNode;
import stork.arbiter.state.StateNode;
import stork.core.Node;
import stork.core.reference.LocalReference;
import stork.error.ArbiterIllegalStopError;
import stork.error.SynchronousArbiterError;
import stork.event.ArbiterPlayerEvent;
import stork.event.ArbiterStateEvent;
import stork.event.Event;

use namespace arbiter_internal;

public class ArbiterNode extends Node {
    protected static var STOP_EXECUTION_RESULT:String                           = "stopExecutionResult";
    protected static var EXECUTE_CURRENT_STATE_RESULT:String                    = "executeCurrentState";
    protected static var EXECUTE_PREVIOUS_STATE_RESULT:String                   = "executePreviousState";
    protected static var STOP_EXECUTION_RESPONSE:String                         = "stopExecutionResponse";
    protected static var PAUSE_EXECUTION_RESPONSE:String                        = "pauseExecutionResponse";

    protected var _players:PlayerContainerNode                                      = null;
    protected var _states:StateContainerNode                                        = null;

    protected var _dispatchingEvents:Boolean                                    = false;

    arbiter_internal var _running:Boolean                                       = false;

    arbiter_internal var willSwitchStateEvent:ArbiterStateEvent                         = new ArbiterStateEvent(ArbiterStateEvent.WILL_SWITCH_STATE);
    arbiter_internal var didExecuteStateEvent:ArbiterStateEvent                         = new ArbiterStateEvent(ArbiterStateEvent.DID_EXECUTE_STATE);
    arbiter_internal var didExecuteStateWithResponseEvent:ArbiterStateEvent             = new ArbiterStateEvent(ArbiterStateEvent.DID_EXECUTE_STATE_WITH_RESPONSE);
    arbiter_internal var willSendRequestEvent:ArbiterPlayerEvent                        = new ArbiterPlayerEvent(ArbiterPlayerEvent.WILL_PROCESS_REQUEST);
    arbiter_internal var didSendRequestEvent:ArbiterPlayerEvent                         = new ArbiterPlayerEvent(ArbiterPlayerEvent.DID_PROCESS_REQUEST);

    arbiter_internal var executeStatePhase:ExecuteStatePhase                            = new ExecuteStatePhase();
    arbiter_internal var executeStateWithResponsePhase:ExecuteStateWithResponsePhase    = new ExecuteStateWithResponsePhase();
    arbiter_internal var changeStatePhase:ChangeStatePhase                              = new ChangeStatePhase();
    arbiter_internal var sendRequestPhase:SendRequestPhase                              = new SendRequestPhase();

    protected var _activePhase:ExecutionPhase = null;

    public function ArbiterNode(name:String = "BasicArbiter") {
        super(name);
    }

    [LocalReference("@stork.arbiter.player::PlayerContainerNode")]
    public function set players(value:PlayerContainerNode):void { _players = value; }
    public function get players():PlayerContainerNode { return _players; }

    [LocalReference("@stork.arbiter.state::StateContainerNode")]
    public function set states(value:StateContainerNode):void { _states = value; }
    public function get states():StateContainerNode { return _states; }

    public function beginExecution():void {
        _running = true;

        executeStatePhase.state = states.currentState;

        runExecutionLoop(executeStatePhase);
    }

    public function stopExecutionResult():* { return STOP_EXECUTION_RESULT; }
    public function executeCurrentStateResult():* { return EXECUTE_CURRENT_STATE_RESULT; }
    public function executePreviousStateResult():* { return EXECUTE_PREVIOUS_STATE_RESULT; }
    public function executeStateResult(state:StateNode):* { return state; }

    public function sendRequestResult(request:Request, player:PlayerNode):* {
        request.player = player;

        return request;
    }

    public function requestProcessedResponse(request:Request):* { return request; }

    public function stopExecutionResponse():* { return STOP_EXECUTION_RESPONSE; }
    public function pauseExecutionResponse():* { return PAUSE_EXECUTION_RESPONSE; }

    public function isStopped():Boolean { return ! _running; }
    public function stopExecution():void {
        if(! _dispatchingEvents)
            throw new ArbiterIllegalStopError();

        _running = false;
    }

    public function isPaused():Boolean { return false; }
    public function pauseExecution():void { throw new SynchronousArbiterError(); }
    public function resumeExecution():void { throw new SynchronousArbiterError(); }

    override public function dispatchEvent(event:Event):void {
        _dispatchingEvents = true;

        super.dispatchEvent(event);

        _dispatchingEvents = false;
    }

    arbiter_internal function internalStop():void { _running = false; }
    arbiter_internal function internalPause():void { throw new SynchronousArbiterError(); }

    protected function runExecutionLoop(phase:ExecutionPhase):void {
        if(phase != _activePhase) {
            _activePhase = phase;

            _activePhase.activate();
        }

        while(shouldExecuteNextPhase()) {
            var nextPhase:ExecutionPhase = _activePhase.run(this);

            if(nextPhase != _activePhase) {
                _activePhase.deactivate();

                _activePhase = nextPhase;

                if(_activePhase != null)
                    _activePhase.activate();
            }
        }
    }

    protected function shouldExecuteNextPhase():Boolean {
        return _running && _activePhase != null;
    }
}
}
