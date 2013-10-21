package ssen.datakit.asyncunits {
import flash.utils.clearTimeout;
import flash.utils.setTimeout;


public class SetTimeoutAsyncUnit implements IAsyncUnit {
	private var id:uint;
	private var alive:Boolean;
	private var _result:Function;
	private var _fault:Function;
	private var _resultValue:*;
	private var _faultValue:*;
	private var _respondToResult:Boolean;

	public function SetTimeoutAsyncUnit(time:uint, resultValue:*=null, faultValue:*=null, respondToResult:Boolean=true) {
		alive=true;
		id=setTimeout(timeout, time);
		_resultValue=resultValue;
		_faultValue=faultValue;
		_respondToResult=respondToResult;
	}

	private function timeout():void {
		if (_respondToResult) {
			if (_result !== null) {
				_result(_resultValue);
			} else if (_fault !== null) {
				_fault(_faultValue);
			}
		}

		alive=false;
		dispose();
	}

	public function get result():Function {
		return _result;
	}

	public function set result(value:Function):void {
		_result=value;
	}

	public function get fault():Function {
		return _fault;
	}

	public function set fault(value:Function):void {
		_fault=value;
	}

	public function close():void {
		dispose();
	}

	public function dispose():void {
		if (alive) {
			clearTimeout(id);
		}
		alive=false;

		_result=null;
		_fault=null;
		_resultValue=null;
		_faultValue=null;
	}
}
}
