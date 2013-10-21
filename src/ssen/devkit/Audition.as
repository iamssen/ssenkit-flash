package ssen.devkit {
import flash.display.Sprite;

import ssen.common.StringUtils;

public class Audition {
	private var plots:Vector.<Plot>;

	private var currentPlot:int;
	private var numPlots:int;
	private var errors:int;

	public function Audition() {
		plots=new Vector.<Plot>;
	}

	public function add(actor:Class):void {
		plots.push(new Plot(actor));
	}

	public function start(theater:Sprite):void {
		trace("---------------------------------------------");
		trace("Audition start");
		trace("---------------------------------------------");

		errors=0;
		currentPlot=-1;
		numPlots=plots.length;

		runPlot();
	}

	private function runPlot():void {
		if (++currentPlot < numPlots) {
			var plot:Plot=plots[currentPlot];
			plot.run(runPlot, printResult);
		} else {
			completePlot();
		}
	}

	private function completePlot():void {
		if (errors > 0) {
			trace("---------------------------------------------");
			trace(StringUtils.formatToString("Audition not pass. {0} errors", errors));
			trace("---------------------------------------------");
		} else {
			trace("---------------------------------------------");
			trace("Pass audition.");
			trace("---------------------------------------------");
		}
	}

	protected function printResult(result:Result):void {
		if (result.success) {
			trace(".");
		} else {
			errors++;

			var stackTrace:String=result.error.getStackTrace();
			var index:int=stackTrace.indexOf("	at SyncAct/act()");

			if (index === -1) {
				index=stackTrace.indexOf("	at AsyncAct/act()");
			}

			var lines:Array=stackTrace.substr(0, index).split("\n");
			var nlines:Vector.<String>=new Vector.<String>;

			var line:String;

			var f:int=-1;
			var fmax:int=lines.length;
			while (++f < fmax) {
				line=lines[f];

				if (line.indexOf("at ssen.devkit::Should") === -1) {
					nlines.push(line);
				}
			}

			trace(StringUtils.formatToString('{0}) {1} "Runtime Error ID : {3}"', errors, result.method, result.error.name, result.error.errorID, result.error.message));
			trace(nlines.join("\n"));
		}
	}
}
}
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;
import flash.utils.setTimeout;

class Plot {
	public var actor:Class;

	private var actorInstance:Object;

	private var callback:Function;
	private var resultCallback:Function;

	private var before:Act;
	private var after:Act;
	private var beforeEach:Act;
	private var afterEach:Act;
	private var acts:Vector.<Act>;

	private var currentAct:int;
	private var numActs:int;

	public function Plot(actor:Class) {
		this.actor=actor;
	}

	public function run(callback:Function, resultCallback:Function):void {
		if (!makeActs()) {
			callback();
		} else {
			this.callback=callback;
			this.resultCallback=resultCallback;
			runActs();
		}
	}

	private function makeActs():Boolean {
		var spec:XML=describeType(actor);

		var metadatas:XMLList;

		metadatas=spec..metadata.(@name.toString().toLowerCase() == "test");
		if (metadatas.length() === 0) {
			return false;
		}

		var f:int=-1;
		var fmax:int=metadatas.length();

		acts=new Vector.<Act>(fmax, true);

		while (++f < fmax) {
			acts[f]=getSingleAct(metadatas[f]);
		}

		metadatas=spec..metadata.(@name.toString().toLowerCase() == "before");
		if (metadatas.length() > 0) {
			before=getSingleAct(metadatas[0]);
		}

		metadatas=spec..metadata.(@name.toString().toLowerCase() == "beforeeach");
		if (metadatas.length() > 0) {
			beforeEach=getSingleAct(metadatas[0]);
		}

		metadatas=spec..metadata.(@name.toString().toLowerCase() == "after");
		if (metadatas.length() > 0) {
			after=getSingleAct(metadatas[0]);
		}

		metadatas=spec..metadata.(@name.toString().toLowerCase() == "aftereach");
		if (metadatas.length() > 0) {
			afterEach=getSingleAct(metadatas[0]);
		}

		return true;
	}

	private function getSingleAct(metadata:XML):Act {
		var member:XML=metadata.parent();

		if (member.name() != "method") {
			return null;
		}

		var params:XMLList=member.parameter;
		var act:Act;

		if (params.length() === 0) {
			var sync:SyncAct=new SyncAct;
			act=sync;
		} else if (params.length() === 1 && params[0].@type == "Function") {
			var async:AsyncAct=new AsyncAct;
			act=async;
		}

		act.method=member.@name;

		return act;
	}

	private function runActs():void {
		actorInstance=new actor();
		currentAct=-1;
		numActs=acts.length;

		runBefore();
	}

	private function runBefore():void {
		if (before) {
			sequence(before, runBeforeEach);
		} else {
			runBeforeEach();
		}
	}

	private function runBeforeEach():void {
		if (++currentAct < numActs) {
			if (beforeEach) {
				sequence(beforeEach, runAct);
			} else {
				runAct();
			}
		} else {
			runAfter();
		}
	}

	private function runAct():void {
		sequence(acts[currentAct], runAfterEach);
	}

	private function runAfterEach():void {
		if (afterEach) {
			sequence(afterEach, runBeforeEach);
		} else {
			runBeforeEach();
		}
	}

	private function runAfter():void {
		if (after) {
			sequence(after, complete);
		} else {
			complete();
		}
	}

	private function complete():void {
		callback();
	}

	private function sequence(act:Act, next:Function):void {
		setTimeout(function():void {
			act.act(actorInstance, function(result:Result):void {
				resultCallback(result);
				next();
			});
		}, 1);
	}
}

class Act {
	public var method:String;

	public function act(actor:Object, callback:Function):void {
		trace("ssen.devkit.audition.Act.act(", getQualifiedClassName(this), method, ")");
	}

	protected function getMethod(actor:Object, method:String):String {
		return getQualifiedClassName(actor) + "#" + method + "()";
	}
}

class SyncAct extends Act {
	override public function act(actor:Object, callback:Function):void {
		var result:Result=new Result;
		result.method=getMethod(actor, method);

		try {
			actor[method]();
			callback(result);
		} catch (err:Error) {
			result.success=false;
			result.error=err;
			callback(result);
		}
	}
}

class AsyncAct extends Act {
	override public function act(actor:Object, callback:Function):void {
		var resulted:Boolean;
		var result:Result=new Result;
		result.method=getMethod(actor, method);

		try {
			actor[method](function(err:Error=null):void {
				if (err) {
					result.success=false;
					result.error=err;
				}
				if (!resulted) {
					callback(result);
					resulted=true;
				}
			});
		} catch (err:Error) {
			result.success=false;
			result.error=err;
			if (!resulted) {
				callback(result);
				resulted=true;
			}
		}
	}
}

class Result {
	public var success:Boolean=true;

	public var error:Error;

	public var method:String;
}
