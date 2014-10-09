package ssen.components.grid.headers {
import flash.display.Graphics;

public interface IHeaderContainer extends IHeader {
	/** graphics */
	function get graphics():Graphics;

	/** rowSeparatorSize */
	function get rowSeparatorSize():int;
	function set rowSeparatorSize(value:int):void;

	/** columnSeparatorSize */
	function set columnSeparatorSize(value:int):void;

	/** rowHeight */
	function get rowHeight():int;
	function set rowHeight(value:int):void;

	function invalidateColumn():void;
	function invalidateColumnLayout():void;
	function invalidateColumnContent():void;
	function invalidateScroll():void;
}
}
