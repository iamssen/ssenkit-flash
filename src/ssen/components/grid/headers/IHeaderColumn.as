package ssen.components.grid.headers {
import flash.events.IEventDispatcher;

public interface IHeaderColumn extends IEventDispatcher {
	/** header */
	function get header():IHeaderContainer;
	function set header(value:IHeaderContainer):void;

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
}
}
