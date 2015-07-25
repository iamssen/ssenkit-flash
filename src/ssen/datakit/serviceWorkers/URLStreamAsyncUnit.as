package ssen.datakit.serviceWorkers {
import flash.events.Event;
import flash.net.URLRequest;

import ssen.common.IAsyncUnit;

public class URLStreamAsyncUnit implements IAsyncUnit {
	//==========================================================================================
	// pool
	//==========================================================================================
	private static var pool:ServiceWorkerPool;
	private static var poolReturns:Vector.<Function>;

	private static function getWorker(callback:Function):void {
		if (!pool) {
			if (!poolReturns) {
				poolReturns = new <Function>[];
				poolReturns.push(callback);
			}

			pool = new ServiceWorkerPool;
			pool.addEventListener(Event.INIT, initialized);
			pool.load(new URLRequest("ssen/datakit/serviceWorkers/URLStreamServiceWorker.swf"));
		} else {
			if (poolReturns) {
				poolReturns.push(callback);
			} else {
				pool.get(callback);
			}
		}
	}

	private static function initialized(event:Event):void {
		pool.removeEventListener(Event.INIT, initialized);

		var f:int = -1;
		var fmax:int = poolReturns.length;
		while (++f < fmax) {
			pool.get(poolReturns[f]);
		}

		poolReturns = null;
	}

	//==========================================================================================
	// api
	//==========================================================================================
	private var _worker:ServiceWorkerProxy;
	private var _result:Function;
	private var _fault:Function;

	public function load(url:String):void {
		getWorker(function (worker:ServiceWorkerProxy):void {
			_worker = worker;
			_worker.resultHandler = resultHandler;
			_worker.errorHandler = errorHandler;
			_worker.start({url: url});
		});
	}

	private function resultHandler(result:Object):void {
		if (_result !== null) _result(result);
		dispose();
	}

	private function errorHandler(error:Error):void {
		if (_fault !== null) _fault(error);
		dispose();
	}

	//==========================================================================================
	// implements IAsyncUnit
	//==========================================================================================
	/** @inheritDoc */
	public function get result():Function {
		return _result;
	}

	/** @inheritDoc */
	public function set result(value:Function):void {
		_result = value;
	}

	/** @inheritDoc */
	public function get fault():Function {
		return _fault;
	}

	/** @inheritDoc */
	public function set fault(value:Function):void {
		_fault = value;
	}

	/** @inheritDoc */
	public function close():void {
		dispose();
	}

	/** @inheritDoc */
	public function dispose():void {
		if (_worker) {
			_worker.suspend();
			pool.put(_worker);
		}

		_worker = null;
		_result = null;
		_fault = null;
	}
}
}
