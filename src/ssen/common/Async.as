package ssen.common {

/**
 * 비동기 함수 실행 유틸
 *
 * @includeDocument Async.md
 * @includeDocument AsyncFlow.md
 * @see AsyncFlow
 */
public class Async {

	/**
	 * test 조건에 의해서 task 들을 반복 실행한다 (while)
	 *
	 * @param test `():Boolean`
	 * @param task `(result:(*), fault:(Error)):void`
	 */
	public static function whilst(test:Function, task:Function):IAsyncUnit {
		return new SeriesRunner().run(new WhileTaskIterator(test, task));
	}

	/**
	 * items의 갯수만큼 task를 실행한다 (for each)
	 *
	 * @param test `():Boolean`
	 * @param task `(item:Object, result:(*), fault:(Error)):void`
	 * @param flow `AsyncFlow` 실행 방식
	 * @param limitCount `flow`가 `AsyncFlow.PARALLEL_LIMIT`일 경우에만 적용된다
	 */
	public static function each(items:Array, task:Function, flow:String = "parallelLimit", limitCount:int = 5):IAsyncUnit {
		return runTask(new EachTaskIterator(items, task), flow, limitCount);
	}

	/**
	 * count 만큼 task를 실행한다 (for)
	 *
	 * @param test `():Boolean`
	 * @param task `(index:int, result:(*), fault:(Error)):void`
	 * @param flow `AsyncFlow` 실행 방식
	 * @param limitCount `flow`가 `AsyncFlow.PARALLEL_LIMIT`일 경우에만 적용된다
	 */
	public static function times(count:int, task:Function, flow:String = "parallelLimit", limitCount:int = 5):IAsyncUnit {
		return runTask(new TimesTaskIterator(count, task), flow, limitCount);
	}

	/**
	 * map의 갯수만큼 task를 실행한다 (for in)
	 *
	 * @param test `():Boolean`
	 * @param task `(key:String, value:Object, result:(*), fault:(Error)):void`
	 * @param flow `AsyncFlow` 실행 방식
	 * @param limitCount `flow`가 `AsyncFlow.PARALLEL_LIMIT`일 경우에만 적용된다
	 */
	public static function map(map:Object, task:Function, flow:String = "parallelLimit", limitCount:int = 5):IAsyncUnit {
		return runTask(new MapTaskIterator(map, task), flow, limitCount);
	}

	/**
	 * task들을 실행한다
	 *
	 * @param tasks `(result:(*), fault:(Error)):void`
	 * @param flow `AsyncFlow` 실행 방식
	 * @param limitCount `flow`가 `AsyncFlow.PARALLEL_LIMIT`일 경우에만 적용된다
	 */
	public static function run(tasks:Vector.<Function>, flow:String = "parallelLimit", limitCount:int = 5):IAsyncUnit {
		return runTask(new TaskIterator(tasks), flow, limitCount);
	}

	//==========================================================================================
	// utils
	//==========================================================================================
	private static function runTask(taskIterator:ITaskIterator, flow:String, limitCount:int):IAsyncUnit {
		switch (flow) {
			case AsyncFlow.SERIES:
				return new SeriesRunner().run(taskIterator);
			case AsyncFlow.PARALLEL:
				return new ParallelRunner().run(taskIterator);
			default:
				return new LimitRunner(limitCount).run(taskIterator);
		}
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
