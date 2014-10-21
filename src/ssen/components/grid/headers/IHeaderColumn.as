package ssen.components.grid.headers {
import flash.events.IEventDispatcher;
import flash.geom.Rectangle;

public interface IHeaderColumn extends IEventDispatcher {
	/** header */
	function get header():IHeaderElement;
	function set header(value:IHeaderElement):void;

	/** headerText */
	function get headerText():String;
	function set headerText(value:String):void;

	/** renderer */
	function get renderer():IHeaderColumnRenderer;
	function set renderer(value:IHeaderColumnRenderer):void;

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
