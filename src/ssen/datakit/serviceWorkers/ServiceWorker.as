package ssen.datakit.serviceWorkers {
import flash.display.Sprite;
import flash.events.Event;
import flash.system.MessageChannel;
import flash.system.Worker;

public class ServiceWorker extends Sprite {
	private var startChannel:MessageChannel;
	private var resultChannel:MessageChannel;
	private var suspendChannel:MessageChannel;
	private var errorChannel:MessageChannel;

	public function ServiceWorker() {
		startChannel = Worker.current.getSharedProperty("startChannel") as MessageChannel;
		resultChannel = Worker.current.getSharedProperty("resultChannel") as MessageChannel;
		suspendChannel = Worker.current.getSharedProperty("suspendChannel") as MessageChannel;
		errorChannel = Worker.current.getSharedProperty("errorChannel") as MessageChannel;

		startChannel.addEventListener(Event.CHANNEL_MESSAGE, startMessageHandler);
		suspendChannel.addEventListener(Event.CHANNEL_MESSAGE, suspendMessageHandler);
	}

	private function startMessageHandler(event:Event):void {
		if (!startChannel.messageAvailable) return;
		start(startChannel.receive());
	}

	private function suspendMessageHandler(event:Event):void {
		if (!suspendChannel.messageAvailable) return;
		suspend();
	}

	protected function start(params:Object):void {

	}

	protected function suspend():void {

	}

	final protected function result(result:Object):void {
		resultChannel.send(result);
	}

	final protected function error(error:Error):void {
		errorChannel.send(error);
	}
}
}
