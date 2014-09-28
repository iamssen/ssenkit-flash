package ssen.common {
import flash.utils.setTimeout;

[Exclude]

public class AsyncTest {

	private static const MAX:int = 100;
	private static const LIMIT:int = 10;

	//==========================================================================================
	// basic
	//==========================================================================================
	private static function task0(result:Function, fault:Function):void {
		setTimeout(result, 1, 0);
	}

	private static function task1(result:Function, fault:Function):void {
		setTimeout(result, 1, 1);
	}

	private static function task2(result:Function, fault:Function):void {
		setTimeout(result, 1, 2);
	}

	private static function task3(result:Function, fault:Function):void {
		setTimeout(result, 1, 3);
	}

	private static function task4(result:Function, fault:Function):void {
		setTimeout(result, 1, 4);
	}

	private static function task5(result:Function, fault:Function):void {
		setTimeout(result, 1, 5);
	}

	private static function task6(result:Function, fault:Function):void {
		setTimeout(result, 1, 6);
	}

	private static function task7(result:Function, fault:Function):void {
		setTimeout(result, 1, 7);
	}

	private function tasksTest(done:Function, unit:IAsyncUnit):void {
		unit.result = function (resultArray:Array):void {
			if (validateTaskValues(resultArray)) {
				done();
			} else {
				done(new Error("Validate failed"));
			}
		};
		unit.fault = function (error:Error):void {
			done(error);
		};
	}

	private static function validateTaskValues(values:Array):Boolean {
		var f:int = -1;
		var fmax:int = values.length;
		while (++f < fmax) {
			if (values[f] !== f) {
				return false;
			}
		}
		return true;
	}

	//----------------------------------------------------------------
	// test
	//----------------------------------------------------------------
	[Test]
	public function series(done:Function):void {
		tasksTest(done, Async.series(new <Function>[task0, task1, task2, task3, task4, task5, task6, task7]));
	}

	[Test]
	public function parallel(done:Function):void {
		tasksTest(done, Async.parallel(new <Function>[task0, task1, task2, task3, task4, task5, task6, task7]));
	}

	[Test]
	public function limit(done:Function):void {
		tasksTest(done, Async.limit(new <Function>[task0, task1, task2, task3, task4, task5, task6, task7], LIMIT));
	}

	//==========================================================================================
	// each
	//==========================================================================================
	private function eachTest(done:Function, unit:IAsyncUnit):void {
		unit.result = function (resultArray:Array):void {
			if (validateEachItems(resultArray)) {
				done();
			} else {
				done(new Error("Validate failed"));
			}
		};
		unit.fault = function (error:Error):void {
			done(error);
		};
	}

	private static function eachTask(item:Item, result:Function, fault:Function):void {
		item.bool = true;
		setTimeout(result, 1, item);
	}

	private static function validateEachItems(items:Array):Boolean {
		var f:int = -1;
		var fmax:int = items.length;
		var item:Item;
		while (++f < fmax) {
			item = items[f];
			if (!item.bool || item.index !== f) {
				return false;
			}
		}
		return true;
	}

	private static function getEachItems():Array {
		var items:Array = [];
		var f:int = -1;
		var fmax:int = MAX;
		var item:Item;
		while (++f < fmax) {
			item = new Item();
			item.index = f;
			items.push(item);
		}
		return items;
	}

	//----------------------------------------------------------------
	// test
	//----------------------------------------------------------------
	[Test]
	public function eachSeries(done:Function):void {
		eachTest(done, Async.eachSeries(getEachItems(), eachTask));

	}

	[Test]
	public function eachParallel(done:Function):void {
		eachTest(done, Async.eachParallel(getEachItems(), eachTask));
	}

	[Test]
	public function eachLimit(done:Function):void {
		eachTest(done, Async.eachLimit(getEachItems(), eachTask, LIMIT));
	}

	//==========================================================================================
	// each
	//==========================================================================================
	private function mapTest(done:Function, unit:IAsyncUnit):void {
		unit.result = function (resultArray:Array):void {
			if (validateMapItems(resultArray)) {
				done();
			} else {
				done(new Error("Validate failed"));
			}
		};
		unit.fault = function (error:Error):void {
			done(error);
		};
	}

	private static function mapTask(key:String, item:Item, result:Function, fault:Function):void {
		item.bool = true;
		setTimeout(result, 1, item);
	}

	private static function validateMapItems(items:Array):Boolean {
		var f:int = -1;
		var fmax:int = items.length;
		var item:Item;
		while (++f < fmax) {
			item = items[f];
			if (!item.bool) {
				return false;
			}
		}
		return fmax === MAX;
	}

	private static function getMapItems():Object {
		var items:Object = [];
		var f:int = -1;
		var fmax:int = MAX;
		var item:Item;
		while (++f < fmax) {
			item = new Item();
			items["item" + f] = item;
		}
		return items;
	}

	//----------------------------------------------------------------
	// test
	//----------------------------------------------------------------
	[Test]
	public function mapSeries(done:Function):void {
		mapTest(done, Async.mapSeries(getMapItems(), mapTask));
	}

	[Test]
	public function mapParallel(done:Function):void {
		mapTest(done, Async.mapParallel(getMapItems(), mapTask));
	}

	[Test]
	public function mapLimit(done:Function):void {
		mapTest(done, Async.mapLimit(getMapItems(), mapTask, LIMIT));
	}

	//==========================================================================================
	// times
	//==========================================================================================
	private var n:int;

	private function timesTest(done:Function, unit:IAsyncUnit):void {
		unit.result = function (resultArray:Array):void {
			if (n === MAX) {
				done();
			} else {
				done(new Error("Validate failed"));
			}
		};
		unit.fault = function (error:Error):void {
			done(error);
		};
	}

	private function timesTask(index:int, result:Function, fault:Function):void {
		n++;
		setTimeout(result, 1);
	}

	//----------------------------------------------------------------
	// test
	//----------------------------------------------------------------
	[Test]
	public function timesSeries(done:Function):void {
		n = 0;
		timesTest(done, Async.timesSeries(MAX, timesTask));
	}

	[Test]
	public function timesParallel(done:Function):void {
		n = 0;
		timesTest(done, Async.timesParallel(MAX, timesTask));
	}

	[Test]
	public function timesLimit(done:Function):void {
		n = 0;
		timesTest(done, Async.timesLimit(MAX, timesTask, LIMIT));
	}

	//==========================================================================================
	// whilist
	//==========================================================================================
	private var i:int;
	private var imax:int;

	private function whilstTest():Boolean {
		return ++i < imax;
	}

	private static function whilstTask(result:Function, fault:Function):void {
		setTimeout(result, 1);
	}

	[Test]
	public function whilst(done:Function):void {
		i = 0;
		imax = MAX;

		var unit:IAsyncUnit = Async.whilst(whilstTest, whilstTask);
		unit.result = function (resultArray:Array):void {
			if (resultArray.length === MAX) {
				done();
			} else {
				done(new Error("Validate failed"));
			}
		};
		unit.fault = function (error:Error):void {
			done(error);
		};
	}
}
}

import ssen.common.StringUtils;

class Item {
	public var index:int;
	public var bool:Boolean;

	public function toString():String {
		return StringUtils.formatToString("[Item index={0}]", index);
	}
}