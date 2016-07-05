/**
 * User: booster
 * Date: 01/02/14
 * Time: 17:25
 */
package stork.arbiter {
import stork.error.ArbiterIllegalResumeError;
import stork.event.Event;
import stork.event.SceneStepEvent;

use namespace arbiter_internal;

public class AsyncArbiterNode extends ArbiterNode {
    protected var _pausedCount:int = 0;

    public function AsyncArbiterNode(name:String = "AsyncArbiter") {
        super(name);

        addEventListener(Event.ADDED_TO_SCENE, onAddedToScene);
        addEventListener(Event.REMOVED_FROM_SCENE, onRemovedFromScene);
    }

    override public function beginExecution():void {
        _running = true;
        _pausedCount = 0;

        executeStatePhase.state = states.currentState;
        _activePhase = executeStatePhase;

        // runExecutionLoop() will be called on next step() call
    }

    public function continueExecution(playbackArbiter:PlaybackArbiterNode):void {
        use namespace arbiter_internal;

        _running = true;
        _pausedCount = 0;

        executeStatePhase.state = states.currentState;
        _activePhase = playbackArbiter._activePhase;

        // runExecutionLoop() will be called on next step() call
    }

    override public function isPaused():Boolean { return _pausedCount > 0; }

    override public function pauseExecution():void {
        // not sure if this ever made sense - it doesn't break anything to pause while dispatching events
//        if(! _dispatchingEvents)
//            throw new ArbiterIllegalPauseError();

        ++_pausedCount;
    }

    override public function resumeExecution():void {
        // not sure if this ever made sense - it doesn't break anything to resume while dispatching events
//        if(_dispatchingEvents)
//            throw new ArbiterIllegalResumeError();

        if(_pausedCount == 0)
            throw new ArbiterIllegalResumeError("arbiter already resumed, pausedCount == 0");

        --_pausedCount;
    }

    override arbiter_internal function internalPause():void {
        ++_pausedCount;
    }

    override protected function shouldExecuteNextPhase():Boolean {
        return _pausedCount == 0 && super.shouldExecuteNextPhase();
    }

    private function onAddedToScene(event:Event):void { sceneNode.addEventListener(SceneStepEvent.STEP, onStep); }
    private function onRemovedFromScene(event:Event):void { sceneNode.removeEventListener(SceneStepEvent.STEP, onStep); }

    private function onStep(event:SceneStepEvent):void {
        if(shouldExecuteNextPhase())
            runExecutionLoop(_activePhase);
    }
}
}
