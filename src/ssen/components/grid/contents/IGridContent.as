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

	// column 들의 사이즈 재배치
	function invalidateColumnLayout():void;

	// 스크롤 재배치
	function invalidateScroll():void;
}
}
