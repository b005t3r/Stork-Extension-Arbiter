/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:52
 */
package stork.error {

public class ArbiterIllegalStopError extends Error {
    public function ArbiterIllegalStopError(message:* = "arbiter can only be stopped from an even handler", id:* = 0) {
        super(message, id);
    }
}
}
