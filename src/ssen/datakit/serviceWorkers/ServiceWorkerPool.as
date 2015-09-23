package ssen.datakit.serviceWorkers {
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.system.MessageChannelState;
import flash.utils.ByteArray;

[Event(type="flash.events.Event", name="init")]
[Event(type="flash.events.ErrorEvent", name="error")]

public class ServiceWorkerPool extends EventDispatcher {
	private var workers:Vector.<ServiceWorkerProxy>;
	private var worker:ByteArray;
	private var stream:URLStream;

	private var minimum:int;
	private var created:int;

	public function ServiceWorkerPool(minimumSize:int = 5) {
		minimum = minimumSize;
	}

	public function load(workerRequest:URLRequest):void {
		stream = new URLStream;
		stream.addEventListener(Event.COMPLETE, completeHandler);
		stream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		stream.load(workerRequest);
	}

	private function errorHandler(event:ErrorEvent):void {
		removeEvents();
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, event.text, event.errorID));
	}

	private function completeHandler(event:Event):void {
		removeEvents();
		worker = new ByteArray;
		stream.readBytes(worker);
		workers = new <ServiceWorkerProxy>[];
		dispatchEvent(new Event(Event.INIT));
	}

	private function removeEvents():void {
		stream.removeEventListener(Event.COMPLETE, completeHandler);
		stream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
	}

	public function get(callback:Function):void {
		var w:ServiceWorkerProxy;
		while (true) {
			if (workers.length === 0 || created < minimum) {
				ServiceWorkerProxy.createWorker(worker, callback);
				created++;
				break;
			} else {
				w = workers.shift();
				trace("????????????????????????? ServiceWorkerPool.get()", w.__id, w.channelState);
				if (w.channelState === MessageChannelState.OPEN) {
					callback(w);
					break;
				}
			}
		}

	}

	public function put(worker:ServiceWorkerProxy):void {
		worker.suspend();
		workers.push(worker);
	}
}
}
