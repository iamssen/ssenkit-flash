package ssen.datakit.serviceWorkers {
import flash.events.Event;
import flash.system.MessageChannel;
import flash.system.Worker;
import flash.system.WorkerDomain;
import flash.system.WorkerState;
import flash.utils.ByteArray;
import flash.utils.getQualifiedClassName;

import mx.utils.StringUtil;

import ssen.common.IDisposable;

final public class ServiceWorkerProxy implements IDisposable {
	private var _worker:Worker;
	private var _activated:Boolean;

	private var _startChannel:MessageChannel;
	private var _resultChannel:MessageChannel;
	private var _suspendChannel:MessageChannel;
	private var _errorChannel:MessageChannel;

	public var __id:String;
	private static var __next:int = 0;

	//==========================================================================================
	// worker management
	//==========================================================================================
	public static function createWorker(swfBytes:ByteArray, callback:Function):void {
		var worker:ServiceWorkerProxy = new ServiceWorkerProxy(swfBytes);
		worker.workerStart(callback);
	}

	public function ServiceWorkerProxy(swfBytes:ByteArray) {
		__id = StringUtil.substitute('[[id={1}]]', getQualifiedClassName(this), __next);
		trace(__id, "ServiceWorkerProxy.ServiceWorkerProxy()");
		__next++;

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
		_resultChannel.addEventListener(Event.CHANNEL_STATE, resultChannelStateHandler);
		_errorChannel.addEventListener(Event.CHANNEL_MESSAGE, errorMessageHandler);
	}

	private function resultChannelStateHandler(event:Event):void {
		trace(__id, "ServiceWorkerProxy.resultChannelStateHandler()", event, _resultChannel.state);
	}

	private var _callback:Function;

	public function get channelState():String {
		return _resultChannel.state;
	}

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
		_suspendChannel.send({});
	}

	private function resultMessageHandler(event:Event):void {
		trace(__id, "ServiceWorkerProxy.resultMessageHandler()", event);
		if (!_resultChannel.messageAvailable) return;
		var receive:ByteArray = _resultChannel.receive();
		var result:Object = receive.readObject();
		trace(__id, "ServiceWorkerProxy.resultMessageHandler() -->", result);
		if (resultHandler !== null) resultHandler(result);
		resultHandler = null;
		errorHandler = null;
	}

	private function errorMessageHandler(event:Event):void {
		trace(__id, "ServiceWorkerProxy.errorMessageHandler()", event);
		if (!_errorChannel.messageAvailable) return;
		var receive:* = _errorChannel.receive();
		trace(__id, "ServiceWorkerProxy.errorMessageHandler() -->", receive);
		if (errorHandler !== null) errorHandler(receive);
		resultHandler = null;
		errorHandler = null;
	}

	//==========================================================================================
	// dispose
	//==========================================================================================
	public function dispose():void {
		trace(__id, "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& ServiceWorkerProxy.dispose()");

		if (!_resultChannel.messageAvailable) _resultChannel.receive();
		if (!_errorChannel.messageAvailable) _errorChannel.receive();

		_resultChannel.removeEventListener(Event.CHANNEL_MESSAGE, resultMessageHandler);
		_errorChannel.removeEventListener(Event.CHANNEL_MESSAGE, errorMessageHandler);

		_startChannel.close();
		_suspendChannel.close();
		_resultChannel.close();
		_errorChannel.close();

		_startChannel = null;
		_suspendChannel = null;
		_resultChannel = null;
		_errorChannel = null;

		_activated = false;

		_worker.terminate();
		_worker = null;
	}
}
}
