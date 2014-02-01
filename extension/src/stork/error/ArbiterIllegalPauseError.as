/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:51
 */
package stork.error {

public class ArbiterIllegalPauseError extends Error {
    public function ArbiterIllegalPauseError(message:* = "arbiter can only be paused from an even handler", id:* = 0) {
        super(message, id);
    }
}
}
