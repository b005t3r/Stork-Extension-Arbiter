/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:27
 */
package stork.event {
import stork.arbiter.request.RequestRecorderNode;

public class RequestRecorderEvent extends Event {
    public static const REQUEST_RECORDED:String = "requestRecordedEvent";

    public function RequestRecorderEvent(type:String) {
        super(type, false);
    }

    public function get recorder():RequestRecorderNode { return target as RequestRecorderNode; }
}
}
