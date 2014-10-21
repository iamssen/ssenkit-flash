package ssen.components.grid.contents {

import mx.core.IVisualElement;

import ssen.components.grid.headers.IHeader;

public interface IGridContent extends IVisualElement {
	//---------------------------------------------
	// header
	//---------------------------------------------
	/** header */
	function get header():IHeader;

	function set header(value:IHeader):void;

	function invalidateColumnContent():void;

	function invalidateScroll():void;
}
}
