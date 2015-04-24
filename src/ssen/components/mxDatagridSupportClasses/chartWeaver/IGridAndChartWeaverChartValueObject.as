package ssen.components.mxDatagridSupportClasses.chartWeaver {
import flash.events.IEventDispatcher;

public interface IGridAndChartWeaverChartValueObject extends IEventDispatcher {
	//---------------------------------------------
	// horizontalPosition
	//---------------------------------------------
	/** horizontalPosition */
	function get horizontalPosition():Number;
	function set horizontalPosition(value:Number):void;

	//---------------------------------------------
	// highlighted
	//---------------------------------------------
	/** highlighted */
	function get highlighted():Boolean;
	function set highlighted(value:Boolean):void;

	//---------------------------------------------
	// highlightedField
	//---------------------------------------------
	/** highlightedField */
	function get highlightedField():String;
	function set highlightedField(value:String):void;
}
}
