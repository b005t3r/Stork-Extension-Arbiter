/**
 * Created by User on 2016-07-02.
 */
package stork.arbiter {
import stork.arbiter.phase.ExecutionPhase;
import stork.arbiter.request.RequestRecorderNode;

public class PlaybackArbiterNode extends ArbiterNode {
    private var _requestRecorder:RequestRecorderNode;

    private var _requestsToProcessCount:int = -1;

    public function PlaybackArbiterNode(name:String = "PlaybackArbiter") {
        super(name);
    }

    [LocalReference("@stork.arbiter.request::RequestRecorderNode")]
    public function get requestRecorder():RequestRecorderNode { return _requestRecorder; }
    public function set requestRecorder(value:RequestRecorderNode):void { _requestRecorder = value; }

    public function get requestsToProcessCount():int { return _requestsToProcessCount; }
    public function set requestsToProcessCount(value:int):void { _requestsToProcessCount = value; }

    override protected function shouldExecuteNextPhase():Boolean {
        use namespace arbiter_internal;

        if(! super.shouldExecuteNextPhase())
            return false;

        if(_activePhase != executeStatePhase)
            return true;

        var processedAll:Boolean = _requestsToProcessCount >= 0 && _requestRecorder.requestIndex >= _requestsToProcessCount;

        return ! processedAll && _requestRecorder.playbackActive;
    }
}
}
