package ssen.flexkit.components.input {
import flash.events.Event;
import flash.events.EventDispatcher;

[Event(name="filterChanged", type="flash.events.Event")]

public class RangedMonthlySelectorFilter extends EventDispatcher implements IMonthlySelectorFilter {
	//---------------------------------------------
	// from
	//---------------------------------------------
	private var _from:int=198007;

	/** from */
	public function get from():int {
		return _from;
	}

	public function set from(value:int):void {
		_from=value;
		dispatchEvent(new Event("filterChanged"));
	}

	//---------------------------------------------
	// to
	//---------------------------------------------
	private var _to:int=210001;

	/** to */
	public function get to():int {
		return _to;
	}

	public function set to(value:int):void {
		_to=value;
		dispatchEvent(new Event("filterChanged"));
	}

	public function isSelectableMonth(yyyymm:int):Boolean {
		return yyyymm > _from && yyyymm < _to;
	}

	public function hasNextYear(yyyymm:int):Boolean {
		return int(_to / 100) > int(yyyymm / 100);
	}

	public function hasPrevYear(yyyymm:int):Boolean {
		return int(_from / 100) < int(yyyymm / 100);
	}
}
}
