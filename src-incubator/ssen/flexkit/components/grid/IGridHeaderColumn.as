package ssen.flexkit.components.grid {
import flash.events.IEventDispatcher;

public interface IGridHeaderColumn extends IEventDispatcher {
	//---------------------------------------------
	// header
	//---------------------------------------------
	/** header */
	function get header():GridHeader;
	function set header(value:GridHeader):void;

	//---------------------------------------------
	// headerText
	//---------------------------------------------
	/** headerText */
	function get headerText():String;
	function set headerText(value:String):void;

	function draw(container:GridHeader, rowIndex:int, columnIndex:int):int;
}
}
