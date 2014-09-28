package ssen.common {

public class Async {

	//==========================================================================================
	// only series functions
	//==========================================================================================
	/**
	 * 조건에 의해서 실행을 멈춘다.
	 * @param test `():Boolean`
	 * @param task `(result:(*), fault:(Error)):void`
	 */
	public static function whilst(test:Function, task:Function):IAsyncUnit {
		return new SeriesRunner().run(new WhileTaskIterator(test, task));
	}

	//==========================================================================================
	// each
	//==========================================================================================
	/**
	 * items의 갯수만큼 "순차적으로" task를 실행한다.
	 * @param test `():Boolean`
	 * @param task `(item:Object, result:(*), fault:(Error)):void`
	 */
	public static function eachSeries(items:Array, task:Function):IAsyncUnit {
		return new SeriesRunner().run(new EachTaskIterator(items, task));
	}

	/**
	 * items의 갯수만큼 "일괄적으로" task를 실행한다.
	 * @param test `():Boolean`
	 * @param task `(item:Object, result:(*), fault:(Error)):void`
	 */
	public static function eachParallel(items:Array, task:Function):IAsyncUnit {
		return new ParallelRunner().run(new EachTaskIterator(items, task));
	}

	/**
	 * items의 갯수만큼 "특정 갯수를 순차적으로" task를 실행한다.
	 * @param test `():Boolean`
	 * @param task `(item:Object, result:(*), fault:(Error)):void`
	 */
	public static function eachLimit(items:Array, task:Function, executeCount:int = 4):IAsyncUnit {
		return new LimitRunner(executeCount).run(new EachTaskIterator(items, task));
	}

	//==========================================================================================
	// times
	//==========================================================================================
	public static function timesSeries(count:int, task:Function):IAsyncUnit {
		return new SeriesRunner().run(new TimesTaskIterator(count, task));
	}

	public static function timesParallel(count:int, task:Function):IAsyncUnit {
		return new ParallelRunner().run(new TimesTaskIterator(count, task));
	}

	public static function timesLimit(count:int, task:Function, executeCount:int = 4):IAsyncUnit {
		return new LimitRunner(executeCount).run(new TimesTaskIterator(count, task));
	}

	//==========================================================================================
	// map
	//==========================================================================================
	public static function mapSeries(map:Object, task:Function):IAsyncUnit {
		return new SeriesRunner().run(new MapTaskIterator(map, task));
	}

	public static function mapParallel(map:Object, task:Function):IAsyncUnit {
		return new ParallelRunner().run(new MapTaskIterator(map, task));
	}

	public static function mapLimit(map:Object, task:Function, executeCount:int = 4):IAsyncUnit {
		return new LimitRunner(executeCount).run(new MapTaskIterator(map, task));
	}

	//==========================================================================================
	// basic control
	//==========================================================================================
	public static function series(tasks:Vector.<Function>):IAsyncUnit {
		return new SeriesRunner().run(new TaskIterator(tasks));
	}

	public static function parallel(tasks:Vector.<Function>):IAsyncUnit {
		return new ParallelRunner().run(new TaskIterator(tasks));
	}

	public static function limit(tasks:Vector.<Function>, executeCount:int = 4):IAsyncUnit {
		return new LimitRunner(executeCount).run(new TaskIterator(tasks));
	}
}
}

import ssen.common.IAsyncUnit;

//==========================================================================================
// core
//==========================================================================================
class Task {
	public var index:int;
	public var callback:Function;
	public var result:*;
	public var error:Error;
	public var complete:Boolean;
}

interface ITaskIterator {
	function hasNext():Boolean;

	function execute(task:Task):void;
}

class TaskManager {
	private var tasks:Vector.<Task>;
	private var lastIndex:int;

	public function TaskManager() {
		tasks = new <Task>[];
		lastIndex = -1;
	}

	public function getTask(callback:Function):Task {
		lastIndex += 1;

		var task:Task = new Task;
		task.index = lastIndex;
		task.callback = callback;

		tasks.push(task);

		return task;
	}

	public function numAliveTask():int {
		var alive:int = 0;
		var f:int = tasks.length;
		while (--f >= 0) {
			if (!tasks[f].complete) {
				alive += 1;
			}
		}
		return alive;
	}

	public function getResultList():Array {
		var list:Array = [];
		var f:int = -1;
		var fmax:int = tasks.length;
		while (++f < fmax) {
			list.push(tasks[f].result);
		}
		return list;
	}
}

class TaskResponder {
	private var task:Task;

	public function TaskResponder(task:Task) {
		this.task = task;
	}

	public function resultCallback(result:* = null):void {
		task.result = result;
		task.complete = true;
		task.callback(task);
	}

	public function faultCallback(error:Error):void {
		task.error = error;
		task.complete = true;
		task.callback(task);
	}
}

interface ITaskRunner extends IAsyncUnit {
	function run(taskIterator:ITaskIterator):IAsyncUnit;
}

//==========================================================================================
// executer
//==========================================================================================
class TaskRunner implements ITaskRunner {
	//---------------------------------------------
	// result
	//---------------------------------------------
	private var _result:Function;

	/** result */
	public function get result():Function {
		return _result;
	}

	public function set result(value:Function):void {
		_result = value;
	}

	//---------------------------------------------
	// fault
	//---------------------------------------------
	private var _fault:Function;

	/** fault */
	public function get fault():Function {
		return _fault;
	}

	public function set fault(value:Function):void {
		_fault = value;
	}

	//----------------------------------------------------------------
	//
	//----------------------------------------------------------------
	protected var iterator:ITaskIterator;
	protected var closed:Boolean;
	protected var taskManager:TaskManager;

	public function TaskRunner() {
		this.taskManager = new TaskManager;
	}

	public function run(iterator:ITaskIterator):IAsyncUnit {
		this.iterator = iterator;
		this.closed = false;
		exec();
		return this;
	}

	public function close():void {
		dispose();
	}

	public function dispose():void {
		iterator = null;
		taskManager = null;
		closed = true;

		_result = null;
		_fault = null;
	}

	//----------------------------------------------------------------
	//
	//----------------------------------------------------------------
	protected function exec():void {
		iterator.execute(taskManager.getTask(callback));
	}

	protected function callback(task:Task):Boolean {
		if (closed) {
			return false;
		}

		if (task.error) {
			closed = true;

			if (_fault !== null) {
				_fault(task.error);
			} else {
				throw task.error;
			}

			return false;
		}

		return true;
	}

	final protected function complete():void {
		if (_result !== null) {
			_result(taskManager.getResultList());
		}
		dispose();
	}
}

class SeriesRunner extends TaskRunner {
	override protected function callback(task:Task):Boolean {
		if (super.callback(task)) {
			if (iterator.hasNext()) {
				exec();
			} else {
				complete();
			}
		}
		return true;
	}
}

class ParallelRunner extends TaskRunner {
	override protected function exec():void {
		while (iterator.hasNext()) {
			iterator.execute(taskManager.getTask(callback));
		}
	}

	override protected function callback(task:Task):Boolean {
		if (super.callback(task)) {
			if (taskManager.numAliveTask() === 0) {
				complete();
			}
		}
		return true;
	}
}

class LimitRunner extends TaskRunner {
	private var executeCount:int;

	public function LimitRunner(executeCount:int) {
		this.executeCount = executeCount;
	}

	override protected function exec():void {
		if (!iterator.hasNext()) {
			return;
		}

		var aliveCount:int = taskManager.numAliveTask();

		var f:int = executeCount - aliveCount;
		while (iterator.hasNext() && --f >= 0) {
			iterator.execute(taskManager.getTask(callback));
		}
	}

	override protected function callback(task:Task):Boolean {
		if (super.callback(task)) {
			if (iterator.hasNext()) {
				exec();
			} else if (taskManager.numAliveTask() === 0) {
				complete();
			}
		}
		return true;
	}
}

//==========================================================================================
// task iterator
//==========================================================================================
class TimesTaskIterator implements ITaskIterator {
	private var count:int;
	private var task:Function;
	private var f:int;

	public function TimesTaskIterator(count:int, task:Function) {
		this.count = count;
		this.task = task;
		this.f = -1;
	}

	public function hasNext():Boolean {
		return f + 1 < count;
	}

	public function execute(t:Task):void {
		var res:TaskResponder = new TaskResponder(t);
		f += 1;
		task(f, res.resultCallback, res.faultCallback);
	}
}

class EachTaskIterator implements ITaskIterator {
	private var items:Array;
	private var count:int;
	private var task:Function;
	private var f:int;

	public function EachTaskIterator(items:Array, task:Function) {
		this.items = items;
		this.count = items.length;
		this.task = task;
		this.f = -1;
	}

	public function hasNext():Boolean {
		return f + 1 < count;
	}

	public function execute(t:Task):void {
		var res:TaskResponder = new TaskResponder(t);
		f += 1;
		task(items[f], res.resultCallback, res.faultCallback);
	}
}

class MapTaskIterator implements ITaskIterator {
	private var keys:Vector.<String>;
	private var items:Array;
	private var task:Function;
	private var f:int;
	private var count:int;

	public function MapTaskIterator(items:Object, task:Function) {
		this.keys = new <String>[];
		this.items = [];

		for (var key:String in items) {
			this.keys.push(key);
			this.items.push(items[key]);
		}

		this.count = this.keys.length;
		this.task = task;
		this.f = -1;
	}

	public function hasNext():Boolean {
		return f + 1 < count;
	}

	public function execute(t:Task):void {
		var res:TaskResponder = new TaskResponder(t);
		f += 1;
		task(keys[f], items[f], res.resultCallback, res.faultCallback);
	}
}

class TaskIterator implements ITaskIterator {
	private var tasks:Vector.<Function>;
	private var count:int;
	private var f:int;

	public function TaskIterator(tasks:Vector.<Function>) {
		this.tasks = tasks;
		this.count = tasks.length;
		this.f = -1;
	}

	public function hasNext():Boolean {
		return f + 1 < count;
	}

	public function execute(t:Task):void {
		var res:TaskResponder = new TaskResponder(t);
		f += 1;
		tasks[f](res.resultCallback, res.faultCallback);
	}
}

class WhileTaskIterator implements ITaskIterator {
	private var test:Function;
	private var task:Function;

	public function WhileTaskIterator(test:Function, task:Function) {
		this.test = test;
		this.task = task;
	}

	public function hasNext():Boolean {
		return test();
	}

	public function execute(t:Task):void {
		var res:TaskResponder = new TaskResponder(t);
		task(res.resultCallback, res.faultCallback);
	}
}
