/**
 * User: booster
 * Date: 01/02/14
 * Time: 17:25
 */
package stork.arbiter {
import stork.error.ArbiterIllegalPauseError;
import stork.error.ArbiterIllegalResumeError;
import stork.event.Event;
import stork.event.SceneStepEvent;

use namespace arbiter_internal;

public class AsyncArbiterNode extends ArbiterNode {
    protected var _paused:Boolean = false;

    public function AsyncArbiterNode(name:String = "Async Arbiter") {
        super(name);

        addEventListener(Event.ADDED_TO_SCENE, onAddedToScene);
        addEventListener(Event.REMOVED_FROM_SCENE, onRemovedFromScene);
    }

    private function onAddedToScene(event:Event):void { addEventListener(SceneStepEvent.STEP, onStep); }
    private function onRemovedFromScene(event:Event):void { removeEventListener(SceneStepEvent.STEP, onStep); }

    private function onStep(event:SceneStepEvent):void {
        if(shouldExecuteNextPhase())
            runExecutionLoop(_activePhase);
    }

    override public function beginExecution():void {
        _running = true;
        _paused = false;

        executeStatePhase.state = states.currentState;
        _activePhase = executeStatePhase;

        // runExecutionLoop() will be called on next step() call
    }

    override public function isPaused():Boolean { return _paused; }

    override public function pauseExecution():void {
        if(! _dispatchingEvents)
            throw new ArbiterIllegalPauseError();

        _paused = true;
    }

    override public function resumeExecution():void {
        if(_dispatchingEvents)
            throw new ArbiterIllegalResumeError();

        _paused = false;
    }

    override arbiter_internal function internalPause():void { _paused = true; }

    override protected function shouldExecuteNextPhase():Boolean {
        return ! _paused && super.shouldExecuteNextPhase();
    }
}
}
