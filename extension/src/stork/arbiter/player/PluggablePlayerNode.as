/**
 * User: booster
 * Date: 03/02/14
 * Time: 10:10
 */
package stork.arbiter.player {
import stork.arbiter.player.plugin.PlayerPluginNode;
import stork.core.Node;
import stork.event.Event;

public class PluggablePlayerNode extends PlayerNode {
    protected static var REEVALUATE_ACTIVE_PLUGIN_RESULT:String = "reevaluateActivePluginResult";

    protected var _activePlugin:PlayerPluginNode = null;

    public function PluggablePlayerNode(name:String = "Player") {
        super(name);
    }

    public function registerPlugin(plugin:PlayerPluginNode):void { addNode(plugin); }
    public function unregisterPlugin(plugin:PlayerPluginNode):void { removeNode(plugin); }

    public function reevaluateActivePluginResult():* { return REEVALUATE_ACTIVE_PLUGIN_RESULT; }

    public function resetActivePlugin():void {
        if(_activePlugin != null) {
            _activePlugin.deactivate();
            _activePlugin = null;
        }
    }

    override public function processRequest():* {
        var count:int = nodeCount;
        var maximumIterations:int = 10000;
        while(--maximumIterations > 0) {
            for (var i:int = 0; i < count; ++ i) {
                var plugin:PlayerPluginNode = getNodeAt(i) as PlayerPluginNode;

                if(plugin == null || ! plugin.canHandleRequest(request))
                    continue;

                // deactivate previously used plugin and activate the new one, if different from the previous one
                if(_activePlugin == null) {
                    _activePlugin = plugin;
                    _activePlugin.activate();
                }
                else if(_activePlugin != plugin) {
                    _activePlugin.deactivate();
                    _activePlugin = plugin;
                    _activePlugin.activate();
                }

                var response:* = _activePlugin.processRequest();

                // check if another plugin should be activated and handle execution
                if(response == reevaluateActivePluginResult())
                    break;

                // don't deactivate current plugin, if just pausing
                if(response == arbiter.pauseExecutionResponse())
                    return response;

                _activePlugin.deactivate();
                _activePlugin = null;

                return response;
            }
        }

        if(maximumIterations == 0)
            throw new Error("infinite loop detected - no plugin can handle the request");
    }
}
}
