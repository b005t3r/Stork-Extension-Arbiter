/**
 * User: booster
 * Date: 01/02/14
 * Time: 11:28
 */
package stork.arbiter.request {
import medkit.collection.ArrayUtil;
import medkit.object.ObjectInputStream;
import medkit.object.ObjectOutputStream;

import stork.arbiter.ArbiterNode;
import stork.arbiter.player.PlayerNode;
import stork.arbiter.player.RequestPlaybackProxyNode;
import stork.core.Node;
import stork.event.ArbiterPlayerEvent;
import stork.event.RequestRecorderEvent;

public class RequestRecorderNode extends Node {
    protected var _requestPlayedBackEvent:RequestRecorderEvent  = new RequestRecorderEvent(RequestRecorderEvent.REQUEST_PLAYED_BACK);
    protected var _requestRecordedEvent:RequestRecorderEvent    = new RequestRecorderEvent(RequestRecorderEvent.REQUEST_RECORDED);

    protected var _arbiter:ArbiterNode              = null;
    protected var _requests:Object                  = { "requestCount" : 0 };
    protected var _requestIndex:int                 = 0;

    public function RequestRecorderNode(name:String = "RequestRecorder") {
        super(name);
    }

    [LocalReference("@stork.arbiter::ArbiterNode")]
    public function get arbiter():ArbiterNode { return _arbiter; }
    public function set arbiter(value:ArbiterNode):void {
        if(_arbiter != null)
            _arbiter.removeEventListener(ArbiterPlayerEvent.DID_PROCESS_REQUEST, onRequestProcessed);

        _arbiter = value;

        if(_arbiter != null)
            _arbiter.addEventListener(ArbiterPlayerEvent.DID_PROCESS_REQUEST, onRequestProcessed);
    }

    public function get playbackActive():Boolean { return _requestIndex < _requests.requestCount; }
    public function get requestIndex():int { return _requestIndex; }

    public function createPlaybackProxy(player:PlayerNode):RequestPlaybackProxyNode {
        return new RequestPlaybackProxyNode(this, player);
    }

    public function decodeRecordedRequests(requestData:String):void {
        var ois:ObjectInputStream = ObjectInputStream.readFromJSONString(requestData);
        _requests = ois.readObject("requests");
        //_requestIndex = int(_requests["requestCount"]);
    }

    public function encodeRecordedRequests():String {
        var oos:ObjectOutputStream = new ObjectOutputStream();
        oos.writeObject(_requests, "requests");

        return oos.saveToJSONString();
    }

    public function getNextRequest(player:PlayerNode):Request {
        var playerRequests:Array = _requests[player.name];

        var count:int = playerRequests.length;
        for (var i:int = 0; i < count; ++i) {
            var requestWrapper:Object = playerRequests[i];

            if(requestWrapper.index == _requestIndex)
                return requestWrapper.request;
        }

        throw new ArgumentError("request for index " + _requestIndex + " not found for player '" + player.name + "'");
    }

    public function trimLastRequests(count:int):void {
        if(count > _requests.requestCount)
            count = _requests.requestCount;

        _requests.requestCount -= count;

        if(_requestIndex >= _requests.requestCount)
            _requestIndex = _requests.requestCount;

        for(var playerName:String in _requests) {
            if(! _requests.hasOwnProperty(playerName) || playerName == "requestCount")
                continue;

            var playerRequests:Array = _requests[playerName];

            var reqCount:int = playerRequests.length;
            for (var i:int = 0; i < reqCount; ++i) {
                var requestWrapper:Object = playerRequests[i];

                if(requestWrapper.index < _requests.requestCount)
                    continue;

                var numMoved:int = reqCount - i - 1;

                if(numMoved > 0)
                    ArrayUtil.arrayCopy(playerRequests, i + 1, playerRequests, i, numMoved);

                --reqCount;
            }

            playerRequests.length = reqCount;
        }
    }

    protected function onRequestProcessed(event:ArbiterPlayerEvent):void {
        // playback
        if(playbackActive) {
            _requestIndex++;

            dispatchEvent(_requestPlayedBackEvent.resetEvent(_requestIndex - 1, event.player.name, event.request));
            trace("playback:", _requestIndex - 1, event.player.name, event.request);
        }
        // recording
        else {
            var wrapper:Object  = {
                "index"     : _requestIndex,
                "request"   : event.request
            };

            var playerRequests:Array = _requests[event.player.name];

            if(playerRequests == null) {
                playerRequests = [];
                _requests[event.player.name] = playerRequests;
            }

            playerRequests[playerRequests.length] = wrapper;

            _requestIndex++;
            _requests.requestCount = _requestIndex;

            dispatchEvent(_requestRecordedEvent.resetEvent(_requestIndex - 1, event.player.name, event.request));
            trace("recording:", _requestIndex - 1, event.player.name, event.request);
        }
    }
}
}
