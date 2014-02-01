/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:32
 */
package stork.event {
import stork.arbiter.ArbiterNode;

public class ArbiterEvent extends Event {
    public function ArbiterEvent(type:String) {
        super(type, false);
    }

    public function get arbiter():ArbiterNode { return target as ArbiterNode; }
}
}
