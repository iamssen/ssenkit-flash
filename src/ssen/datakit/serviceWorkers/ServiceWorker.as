package ssen.datakit.serviceWorkers {
import flash.display.Sprite;
import flash.events.Event;
import flash.system.MessageChannel;
import flash.system.MessageChannelState;
import flash.system.Worker;
import flash.utils.ByteArray;

public class ServiceWorker extends Sprite {
	private var startChannel:MessageChannel;
	private var resultChannel:MessageChannel;
	private var suspendChannel:MessageChannel;
	private var errorChannel:MessageChannel;

	public function ServiceWorker() {
		startChannel = Worker.current.getSharedProperty("startChannel") as MessageChannel;
		suspendChannel = Worker.current.getSharedProperty("suspendChannel") as MessageChannel;
		resultChannel = Worker.current.getSharedProperty("resultChannel") as MessageChannel;
		errorChannel = Worker.current.getSharedProperty("errorChannel") as MessageChannel;

		if (startChannel) startChannel.addEventListener(Event.CHANNEL_MESSAGE, startMessageHandler);
		if (suspendChannel) suspendChannel.addEventListener(Event.CHANNEL_MESSAGE, suspendMessageHandler);
	}

	private function startMessageHandler(event:Event):void {
		if (!startChannel.messageAvailable) return;
		var receive:Object = startChannel.receive();
		start(receive);
		trace(__id__, "ServiceWorker.startMessageHandler()", receive, channelState);
	}

	private function resultChannelStateHandler(event:Event):void {
		trace(__id__, "ServiceWorker.resultChannelStateHandler()", resultChannel.state, resultChannel.messageAvailable);
	}

	private function suspendMessageHandler(event:Event):void {
		if (!suspendChannel.messageAvailable) return;
		var receive:Object = suspendChannel.receive();
		trace(__id__, "ServiceWorker.suspendMessageHandler()", receive);
		suspend();
	}

	protected function start(params:Object):void {

	}

	protected function suspend():void {

	}

	final protected function result(result:Object):void {
		if (resultChannel.state === MessageChannelState.OPEN) {
			trace(__id__, "ServiceWorker.result() 1", channelState);
			var bytes:ByteArray = new ByteArray;
			bytes.writeObject(result);
			try {
				resultChannel.send(bytes);
			} catch (error:Error) {
				trace(__id__, "ServiceWorker.result() Catch Error!!!!!", channelState, error);
			}
			trace(__id__, "ServiceWorker.result() 2", channelState);
		} else {
			trace(__id__, "ServiceWorker.result()", startChannel.messageAvailable, startChannel.state);
			trace(__id__, "ServiceWorker.result()", suspendChannel.messageAvailable, suspendChannel.state);
			trace(__id__, "ServiceWorker.result()", resultChannel.messageAvailable, resultChannel.state);
		}
	}

	final protected function error(error:Error):void {
		if (errorChannel.state === MessageChannelState.OPEN) {
			errorChannel.send(error);
		} else {
			trace(__id__, "ServiceWorker.error()", startChannel.messageAvailable, startChannel.state);
			trace(__id__, "ServiceWorker.error()", suspendChannel.messageAvailable, suspendChannel.state);
			trace(__id__, "ServiceWorker.error()", errorChannel.messageAvailable, errorChannel.state);
		}
	}

	protected function get __id__():String {
		return "";
	}

	protected function get channelState():String {
		return resultChannel.state;
	}
}
}
