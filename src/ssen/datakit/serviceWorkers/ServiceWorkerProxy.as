package ssen.datakit.serviceWorkers {
import flash.events.Event;
import flash.system.MessageChannel;
import flash.system.Worker;
import flash.system.WorkerDomain;
import flash.system.WorkerState;
import flash.utils.ByteArray;

import ssen.common.IDisposable;

final public class ServiceWorkerProxy implements IDisposable {
	private var _worker:Worker;
	private var _activated:Boolean;

	private var _startChannel:MessageChannel;
	private var _resultChannel:MessageChannel;
	private var _suspendChannel:MessageChannel;
	private var _errorChannel:MessageChannel;

	//==========================================================================================
	// worker management
	//==========================================================================================
	public static function createWorker(swfBytes:ByteArray, callback:Function):void {
		var worker:ServiceWorkerProxy = new ServiceWorkerProxy(swfBytes);
		worker.workerStart(callback);
	}

	public function ServiceWorkerProxy(swfBytes:ByteArray) {
		_worker = WorkerDomain.current.createWorker(swfBytes, true);

		_startChannel = Worker.current.createMessageChannel(_worker);
		_suspendChannel = Worker.current.createMessageChannel(_worker);
		_resultChannel = _worker.createMessageChannel(Worker.current);
		_errorChannel = _worker.createMessageChannel(Worker.current);

		_worker.setSharedProperty("startChannel", _startChannel);
		_worker.setSharedProperty("suspendChannel", _suspendChannel);
		_worker.setSharedProperty("resultChannel", _resultChannel);
		_worker.setSharedProperty("errorChannel", _errorChannel);

		_resultChannel.addEventListener(Event.CHANNEL_MESSAGE, resultMessageHandler);
		_errorChannel.addEventListener(Event.CHANNEL_MESSAGE, errorMessageHandler);
	}

	private var _callback:Function;

	private function workerStart(callback:Function):void {
		_callback = callback;

		_worker.addEventListener(Event.WORKER_STATE, workerStarted);
		_worker.start();
	}

	private function workerStarted(event:Event):void {
		_worker.removeEventListener(Event.WORKER_STATE, workerStarted);

		if (_worker.state === WorkerState.RUNNING) {
			_callback(this);
			_callback = null;
		}
	}

	//==========================================================================================
	// api
	//==========================================================================================
	public function get activated():Boolean { return _activated; }

	public var resultHandler:Function;
	public var errorHandler:Function;

	public function start(params:Object):void {
		if (_activated) return;
		_activated = true;
		_startChannel.send(params);
	}

	public function suspend():void {
		if (!_activated) return;
		_activated = false;
		_suspendChannel.send(null);
	}

	private function resultMessageHandler(event:Event):void {
		_activated = false;
		resultHandler(_resultChannel.receive());
		resultHandler = null;
		errorHandler = null;
	}

	private function errorMessageHandler(event:Event):void {
		_activated = false;
		errorHandler(_errorChannel.receive());
		resultHandler = null;
		errorHandler = null;
	}

	//==========================================================================================
	// dispose
	//==========================================================================================
	public function dispose():void {
		_activated = false;

		_resultChannel.removeEventListener(Event.CHANNEL_MESSAGE, resultMessageHandler);
		_errorChannel.removeEventListener(Event.CHANNEL_MESSAGE, errorMessageHandler);

		_startChannel.close();
		_suspendChannel.close();
		_resultChannel.close();
		_errorChannel.close();

		_worker.terminate();
		_worker = null;
	}
}
}
