package ssen.components.grid.headers {

import mx.core.IFlexDisplayObject;
import mx.core.IVisualElement;

[Event(name="columnLayoutChanged", type="ssen.components.grid.headers.HeaderEvent")]
[Event(name="columnChanged", type="ssen.components.grid.headers.HeaderEvent")]

public interface IHeader extends IVisualElement, IFlexDisplayObject {
	//==========================================================================================
	// 외부로 계산해서 줘야 하는 정보들
	//==========================================================================================
	//----------------------------------------------------------------
	// grid의 type 정보들 (상수 정보)
	//----------------------------------------------------------------
	/** Header Component가 scroll을 지원하는지 여부 */
	function get scrollEnabled():Boolean;

	//----------------------------------------------------------------
	// grid의 계산된 정보들
	//----------------------------------------------------------------
	//---------------------------------------------
	// column bounds
	//---------------------------------------------
	/** 계산된 Column들의 Width들 */
	function get computedColumnWidthList():Vector.<Number>;

	function get computedColumnPositionList():Vector.<Number>;

	//---------------------------------------------
	// locked info
	//---------------------------------------------
	/** 계산된 잠겨있는 Column들의 Width 합계 */
	function get computedLockedColumnWidthTotal():Number;

	/** 계산된 잠겨있지 않은 Column들의 Width 합계 */
	function get computedUnlockedColumnWidthTotal():Number;

	/** 잠겨있지 않은 Column들의 수 */
	function get unlockedColumnCount():int;

	//---------------------------------------------
	// column and row 정보들
	//---------------------------------------------
	/** leafColumns */
	function get leafColumns():Vector.<IHeaderLeafColumn>;

	/** Row 갯수 */
	function get numRows():int;

	/** Column 갯수 */
	function get numColumns():int;

	//==========================================================================================
	// 외부에서 받아야 하는 정보들
	//==========================================================================================
	/** Column들 */
	function get columns():Vector.<IHeaderColumn>;
	function set columns(value:Vector.<IHeaderColumn>):void;

	/** 잠겨있는 Column들의 수 */
	function get lockedColumnCount():int;
	function set lockedColumnCount(value:int):void;

	/** 잠겨있지 않은 Column들의 Scroll 위치 */
	function get horizontalScrollPosition():Number;
	function set horizontalScrollPosition(value:Number):void;

	//==========================================================================================
	// 내부에서 셋팅되어서 외부로 보내줘야 하는 항목들
	//==========================================================================================
	/** columnSeparatorSize */
	function get columnSeparatorSize():int;

	/** rowSeparatorSize */
	function get rowSeparatorSize():int;

	/** rowHeight */
	function get rowHeight():int;

	function get columnLayoutMode():String;
}
}
