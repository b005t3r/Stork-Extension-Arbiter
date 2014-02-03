/**
 * User: booster
 * Date: 03/02/14
 * Time: 10:37
 */
package demo.logic.state {
import stork.arbiter.state.StateNode;

public class GameFinishedStateNode extends StateNode {
    public function GameFinishedStateNode() {
        super("GameFinishedState");
    }

    override public function execute():* {
        return arbiter.stopExecutionResult();
    }
}
}
