/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:53
 */
package stork.error {

/** Thrown when trying to pause a synchronous IArbiterProcess instance. */
public class SynchronousArbiterError extends Error {
    public function SynchronousArbiterError(message:* = "This is a synchronous arbiter instance - it cannot be paused", id:* = 0) {
        super(message, id);
    }
}
}
