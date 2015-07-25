package ssen.datakit.serviceWorkers {
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.net.URLStream;

public class URLStreamServiceWorker extends ServiceWorker {
	private var stream:URLStream;

	override protected function start(params:Object):void {
		stream = new URLStream;
		stream.addEventListener(Event.COMPLETE, completeHandler);
		stream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		stream.load(new URLRequest(params["url"]));
	}

	override protected function suspend():void {
		if (stream) {
			try {
				removeEvents();
				stream.close();
			} catch (error:Error) {
				trace("URLStreamServiceWorker.suspend()", error);
			} finally {
				stream = null;
			}
		}
	}

	private function errorHandler(event:ErrorEvent):void {
		removeEvents();
		stream = null;
		error(new Error(event.text, event.errorID));
	}

	private function completeHandler(event:Event):void {
		var content:Object = stream.readMultiByte(stream.bytesAvailable, "utf-8");
		removeEvents();
		stream = null;
		result(content);
	}

	private function removeEvents():void {
		stream.removeEventListener(Event.COMPLETE, completeHandler);
		stream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
	}
}
}
