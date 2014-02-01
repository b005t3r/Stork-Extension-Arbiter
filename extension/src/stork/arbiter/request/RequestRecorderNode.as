/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:28
 */
package stork.arbiter.request {
import com.adobe.serialization.json.JSON;

import stork.arbiter.ArbiterNode;
import stork.core.Node;
import stork.event.ArbiterPlayerEvent;
import stork.event.RequestRecorderEvent;

public class RequestRecorderNode extends Node {
    protected var _requestRecordedEvent:RequestRecorderEvent = new RequestRecorderEvent(RequestRecorderEvent.REQUEST_RECORDED);

    protected var _arbiter:ArbiterNode  = null;
    protected var _requests:Object      = {};
    protected var _requestIndex:int     = 0;

    public function RequestRecorderNode(name:String = "RequestRecorderNode") {
        super(name);
    }

    public function get arbiter():ArbiterNode { return _arbiter; }
    public function set arbiter(value:ArbiterNode):void {
        if(_arbiter != null)
            _arbiter.removeEventListener(ArbiterPlayerEvent.DID_PROCESS_REQUEST, onRequestProcessed);

        _arbiter = value;

        if(_arbiter != null)
            _arbiter.addEventListener(ArbiterPlayerEvent.DID_PROCESS_REQUEST, onRequestProcessed);
    }

    public function encodeRecordedRequests():String {
        return com.adobe.serialization.json.JSON.encode(_requests);
    }

    protected function onRequestProcessed(event:ArbiterPlayerEvent):void {
        var wrapper:Object  = {
            "index"     : _requestIndex,
            "request"   : event.request
        };

        var playerRequests:Array = _requests[event.player.name];

        if(playerRequests == null) {
            playerRequests = [];
            _requests[event.player.name] = playerRequests;
        }

        playerRequests.push(wrapper);

        _requestIndex++;

        dispatchEvent(_requestRecordedEvent);
    }
}
}
