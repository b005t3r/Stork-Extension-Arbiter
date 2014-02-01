/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:52
 */
package stork.error {

public class ArbiterIllegalResumeError extends Error {
    public function ArbiterIllegalResumeError(message:* = "arbiter can only be resumed outside of an even handler", id:* = 0) {
        super(message, id);
    }
}
}
