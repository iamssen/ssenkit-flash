package ssen.components.grid.headers {
import flash.display.Graphics;

public interface IHeaderContainer extends IHeader {
	//==========================================================================================
	// 외부로 줘야 하는 정보들
	//==========================================================================================
	/** graphics */
	function get graphics():Graphics;

	/** rowHeight */
	function get rowHeight():int;
	function set rowHeight(value:int):void;

//	function invalidateColumn():void;
//	function invalidateColumnLayout():void;
//	function invalidateColumnContent():void;
//	function invalidateScroll():void;
}
}
