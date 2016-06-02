/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:27
 */
package stork.event {
import stork.arbiter.request.Request;
import stork.arbiter.request.RequestRecorderNode;

public class RequestRecorderEvent extends Event {
    public static const REQUEST_RECORDED:String     = "requestRecordedEvent";
    public static const REQUEST_PLAYED_BACK:String  = "requestPlayerBackEvent";

    private var _requestIndex:int = -1;
    private var _playerName:String;
    private var _request:Request;

    public function RequestRecorderEvent(type:String) {
        super(type, false);
    }

    public function get recorder():RequestRecorderNode { return target as RequestRecorderNode; }

    public function get requestIndex():int { return _requestIndex; }
    public function get playerName():String { return _playerName; }
    public function get request():Request { return _request; }

    public function resetEvent(requestIndex:int, playerName:String, request:Request):RequestRecorderEvent {
        _requestIndex   = requestIndex;
        _playerName     = playerName;
        _request        = request;

        return RequestRecorderEvent(reset());
    }
}
}
