package ssen.components.grid.headers {
import flash.events.IEventDispatcher;

import mx.core.IFactory;

public interface IHeaderColumn extends IEventDispatcher {
	/** header */
	function get header():IHeaderElement;
	function set header(value:IHeaderElement):void;

	//---------------------------------------------
	// headerContent
	//---------------------------------------------
	/** headerContent */
	function get headerContent() : Object;
	function set headerContent(value : Object):void;

	/** renderer */
	function get renderer():IFactory;
	function set renderer(value:IFactory):void;

	/** rowIndex */
	[Bindable(event="propertyChange")]
	function get rowIndex():int;
	function set rowIndex(value:int):void;

	/** columnIndex */
	[Bindable(event="propertyChange")]
	function get columnIndex():int;
	function set columnIndex(value:int):void;

	/** computedColumnWidth */
	function get computedColumnWidth():Number;

	function render():void;
}
}
