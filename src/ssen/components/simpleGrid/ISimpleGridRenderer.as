package ssen.components.simpleGrid {
import mx.core.IVisualElement;

public interface ISimpleGridRenderer extends IVisualElement {
	//---------------------------------------------
	// data
	//---------------------------------------------
	/** data */
	function get data():Object;

	function set data(value:Object):void;

	//---------------------------------------------
	// column
	//---------------------------------------------
	/** column */
	function get column():SimpleGridColumn;

	function set column(value:SimpleGridColumn):void;

	/** validateNow */
	function validateNow():void;

	function dispose():void;
}
}
