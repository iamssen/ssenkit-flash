package ssen.common {

/** 비동기 로직 작성을 도와주는 유틸 */
public class Async {
	/** 최대 대기 시간 */
	public static var timeout:int = 1000;

	/**
	 * 같은 task를 실행하고, 조건에 의해서 실행을 멈춘다.
	 * @param test `function():boolean`
	 * @param task `function(callback:function):void`
	 * @param callback `function(error:error):void`
	 */
	public static function whilst(test:Function, task:Function, callback:Function):void {
		new Whilist().execute(test, task, callback);
	}

	/**
	 * 같은 task를 실행하고, 특정 횟수만큼 반복한다.
	 * @param loop
	 * @param task
	 * @param callback
	 */
	public static function times(loop:int, task:Function, callback:Function):void {
		new Times().execute(loop, task, callback);
	}

	public static function timesSeries(loop:int, task:Function, callback:Function):void {
		new TimesSeries().execute(loop, task, callback);
	}

	public static function waterfall(tasks:Vector.<Function>, callback:Function):void {
		new Waterfall().execute(tasks, callback);
	}

	public static function series(tasks:*, callback:Function):void {
		new Series().execute(tasks, callback);
	}

	public static function parallel(tasks:*, callback:Function):void {
		new Parallel().execute(tasks, callback);
	}

	public static function parallelLimit(tasks:*, limit:int, callback:Function):void {
		new ParallelLimit().execute(tasks, limit, callback);
	}
}
}

import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ssen.common.Async;
import ssen.common.StringUtils;

class Whilist {
	private var test:Function;
	private var task:Function;
	private var callback:Function;
	private var values:Array;
	private var f:int;

	public function execute(test:Function, task:Function, callback:Function):void {
		this.f = -1;
		this.test = test;
		this.task = task;
		this.callback = callback;
		this.values = [];

		next();
	}

	private function next():void {
		if (test()) {
			// 0 : execute
			f++;
			var executer:Executer = new Executer;
			executer.exec(task, result);
		} else {
			// 2 : complete callback
			callback(null, values);
			dispose();
		}
	}

	private function result(executer:Executer):void {
		// 1 : result
		if (executer.error !== null) {
			// exception
			callback(executer.error, values);
			dispose();
		} else {
			values.push(executer.value);
			next();
		}
	}

	private function dispose():void {
		task = null;
		callback = null;
		values = null;
	}
}

class Times {
	private var loop:int;
	private var task:Function;
	private var callback:Function;
	private var executers:Array;

	public function execute(loop:int, task:Function, callback:Function):void {
		this.loop = loop;
		this.task = task;
		this.callback = callback;
		this.executers = [];
		this.executers.length = loop;

		var i:int = -1;
		var imax:int = loop;
		var executer:Executer;

		// 0 : execute all
		while (++i < imax) {
			executer = new Executer;
			executer.times = true;
			executer.index = i;
			executer.exec(task, next);
		}
	}

	private function next(executer:Executer):void {
		// 1 : keep executer
		executers[executer.index] = executer;

		// 2 : complete
		if (--loop === 0) {
			var error:Error;
			var values:Array = [];

			var f:int = -1;
			var fmax:int = executers.length;
			var executer:Executer;

			// read error and values
			while (++f < fmax) {
				executer = executers[f];

				if (error !== null && executer.error !== null) {
					error = executer.error;
				}

				values[executer.index] = executer.value;
			}

			// callback
			callback(error, values);
			dispose();
		}
	}

	private function dispose():void {
		task = null;
		callback = null;
		executers = null;
	}
}

class TimesSeries {
	private var f:int;
	private var fmax:int;
	private var callback:Function;
	private var task:Function;
	private var values:Array;

	public function execute(loop:int, task:Function, callback:Function):void {
		this.f = -1;
		this.fmax = loop;
		this.task = task;
		this.callback = callback;
		this.values = [];

		next();
	}

	private function next():void {
		if (++f < fmax) {
			// 0 : execute 
			var executer:Executer = new Executer;
			executer.times = true;
			executer.index = f;
			executer.exec(task, result);
		} else {
			// 2 : complete callback
			callback(null, values);
			dispose();
		}
	}

	private function result(executer:Executer):void {
		// 1 : result
		if (executer.error !== null) {
			// exception
			callback(executer.error, values);
			dispose();
		} else {
			values[executer.index] = executer.value;
			next();
		}
	}

	private function dispose():void {
		task = null;
		callback = null;
		values = null;
	}
}


class SeriesBase {
	protected var tasks:Vector.<Function>;
	protected var keys:Vector.<String>;

	protected function setTasks(tasks:*):void {
		if (tasks is Vector.<Function>) {
			this.tasks = tasks;
		} else if (tasks is Array) {
			this.tasks = Vector.<Function>(tasks);
		} else {
			this.tasks = new Vector.<Function>;
			this.keys = new Vector.<String>;

			for (var key:String in tasks) {
				this.tasks.push(tasks[key]);
				this.keys.push(key);
			}
		}

	}

	protected function makeValues(executers:Array):Array {
		return (keys !== null) ? getObjectedValues(executers) : getArrayedValues(executers);
	}

	private function getObjectedValues(executers:Array):Array {
		var error:Error;
		var values:Object = {};

		var f:int = -1;
		var fmax:int = executers.length;
		var executer:Executer;

		while (++f < fmax) {
			executer = executers[f];

			if (error !== null && executer.error !== null) {
				error = executer.error;
			}

			values[keys[executer.index]] = executer.value;
		}

		return [error, values];
	}

	private function getArrayedValues(executers:Array):Array {
		var error:Error = null;
		var values:Array = [];

		var f:int = -1;
		var fmax:int = executers.length;
		var executer:Executer;

		while (++f < fmax) {
			executer = executers[f];

			if (error !== null && executer.error !== null) {
				error = executer.error;
			}

			values[executer.index] = executer.value;
		}

		return [error, values];
	}

	protected function dispose():void {
		tasks = null;
		keys = null;
	}
}

class Parallel extends SeriesBase {
	private var callback:Function;
	private var executers:Array;
	private var loop:int;

	public function execute(tasks:*, callback:Function):void {
		this.setTasks(tasks);
		this.callback = callback;
		this.executers = [];
		this.loop = this.tasks.length;

		var i:int = -1;
		var imax:int = this.tasks.length;
		var executer:Executer;

		// 0 : execute all
		while (++i < imax) {
			executer = new Executer;
			executer.index = i;
			executer.exec(this.tasks[i], next);
		}
	}

	private function next(executer:Executer):void {
		// 1 : keep executer
		executers[executer.index] = executer;

		// 2 : complete
		if (--loop === 0) {
			try {
				var result:Array = makeValues(executers);
				callback(result[0], result[1]);
			} catch (error:Error) {
				callback(error);
			}
			dispose();
		}
	}

	override protected function dispose():void {
		super.dispose();
		callback = null;
		executers = null;
	}
}

class Series extends SeriesBase {
	private var f:int;
	private var fmax:int;
	private var callback:Function;
	private var executers:Array;

	public function execute(tasks:*, callback:Function):void {
		this.setTasks(tasks);
		this.callback = callback;
		this.executers = [];

		this.f = -1;
		this.fmax = this.tasks.length;

		next();
	}

	private function next():void {
		if (++f < fmax) {
			// 0 : execute 
			var executer:Executer = new Executer;
			executer.index = f;
			executer.exec(tasks[f], result);
		} else {
			// 2 : complete callback
			try {
				var resultArr:Array = makeValues(executers);
				callback(resultArr[0], resultArr[1]);
			} catch (error:Error) {
				callback(error);
			}
			dispose();
		}
	}

	private function result(executer:Executer):void {
		// 1 : result
		if (executer.error !== null) {
			// exception
			callback(executer.error);
			dispose();
		} else {
			executers[executer.index] = executer;
			next();
		}
	}

	override protected function dispose():void {
		super.dispose();
		callback = null;
		executers = null;
	}
}

class ParallelLimit extends SeriesBase {
	private var f:int;
	private var fmax:int;
	private var limit:int;
	private var callback:Function;
	private var executers:Array;
	private var loop:int;

	public function execute(tasks:*, limit:int, callback:Function):void {
		this.setTasks(tasks);
		this.callback = callback;
		this.executers = [];
		this.limit = limit;

		this.f = 0;
		this.fmax = this.tasks.length;

		next();
	}

	private function next():void {
		if (f < fmax) {
			// 0 : execute
			loop = (limit < fmax - f) ? limit : fmax - f;

			var i:int = loop;
			var executer:Executer;

			while (--i >= 0) {
				executer = new Executer;
				executer.index = f;
				executer.exec(this.tasks[f], result);
				f++;
			}
		} else {
			// 3 : complete callback
			try {
				var resultArr:Array = makeValues(executers);
				callback(resultArr[0], resultArr[1]);
			} catch (error:Error) {
				callback(error);
			}
			dispose();
		}
	}

	private function result(executer:Executer):void {
		// 1 : keep executer
		executers[executer.index] = executer;

		// 2 : limit complete
		if (--loop === 0) {
			next();
		}
	}

	override protected function dispose():void {
		super.dispose();
		callback = null;
		executers = null;
	}
}

class Waterfall {
	private var f:int;
	private var fmax:uint;
	private var tasks:Vector.<Function>;
	private var callback:Function;
	private var tid:int = -1;

	public function execute(tasks:Vector.<Function>, callback:Function):void {
		this.f = -1;
		this.fmax = tasks.length;
		this.tasks = tasks;
		this.callback = callback;

		next();
	}

	private function next(...args):void {
		if (++f < fmax) {
			try {
				// 0 : execute
				args.push(result);
				tasks[f].apply(null, args);
				tid = setTimeout(timeout, Async.timeout);
			} catch (error:Error) {
				// exception
				callback(error);
				dispose();
			}
		} else {
			// 2 : complete callback
			callback(null, args);
			dispose();
		}
	}

	private function timeout():void {
		callback(new Error(StringUtils.formatToString("timeout {0}ms", Async.timeout)));
	}

	private function result(error:Error, ...params):void {
		if (tid > -1) {
			clearTimeout(tid);
		}
		if (error !== null) {
			// exception
			callback(error);
			dispose();
		} else {
			// 1 : result
			next.apply(null, params);
		}
	}

	private function dispose():void {
		tasks = null;
		callback = null;
	}
}

class Executer {
	public var times:Boolean;
	public var index:int;
	public var error:Error;
	public var value:*;

	private var next:Function;
	private var tid:int = -1;

	public function exec(task:Function, next:Function):void {
		this.next = next;

		try {
			if (times) {
				task(index, callback);
			} else {
				task(callback);
			}
			tid = setTimeout(timeout, Async.timeout);
		} catch (error:Error) {
			this.error = error;
			next(this);
		}
	}

	private function timeout():void {
		callback(new Error(StringUtils.formatToString("timeout {0}ms", Async.timeout)));
	}

	private function callback(error:Error = null, value:* = null):void {
		if (tid > -1) {
			clearTimeout(tid);
		}
		this.error = error;
		this.value = value;

		next(this);
	}
}
