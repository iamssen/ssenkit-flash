package ssen.components.mxDatagridSupportClasses.chartWeaver {
import flash.events.IEventDispatcher;

public interface IGridAndChartWeaverGridValueObject extends IEventDispatcher {
	//---------------------------------------------
	// highlightedField
	//---------------------------------------------
	/** highlightedField */
	[Bindable(event="propertyChange")]
	function get highlightedField():String;
	function set highlightedField(value:String):void;
}
}
