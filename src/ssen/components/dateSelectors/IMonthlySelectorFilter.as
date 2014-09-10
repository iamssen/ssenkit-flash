package ssen.components.dateSelectors {
import flash.events.IEventDispatcher;

[Event(name="filterChanged", type="flash.events.Event")]

public interface IMonthlySelectorFilter extends IEventDispatcher {
	function isSelectableMonth(yyyymm:int):Boolean;

	function hasNextYear(yyyymm:int):Boolean;

	function hasPrevYear(yyyymm:int):Boolean;
}
}
