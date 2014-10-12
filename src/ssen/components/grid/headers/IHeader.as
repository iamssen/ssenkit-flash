package ssen.components.grid.headers {
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;

public interface IHeader extends IVisualElementContainer, IVisualElement {
	//==========================================================================================
	// 외부로 줘야 하는 정보들
	//==========================================================================================
	/** 계산된 Column들의 Width들 */
	[Bindable(event="propertyChange")]
	function get computedColumnWidthList():Vector.<Number>;

	[Bindable(event="propertyChange")]
	function get computedColumnPositionList():Vector.<Number>;

	/** 계산된 잠겨있는 Column들의 Width 합계 */
	[Bindable(event="propertyChange")]
	function get computedLockedColumnWidthTotal():Number;

	/** 계산된 잠겨있지 않은 Column들의 Width 합계 */
	[Bindable(event="propertyChange")]
	function get computedUnlockedColumnWidthTotal():Number;

	/** 잠겨있지 않은 Column들의 수 */
	[Bindable(event="propertyChange")]
	function get unlockedColumnCount():int;

	/** Header Component가 scroll을 지원하는지 여부 */
	function get scrollEnabled():Boolean;

	/** leafColumns */
	[Bindable(event="propertyChange")]
	function get leafColumns():Vector.<IHeaderLeafColumn>;

	/** Row 갯수 */
	[Bindable(event="propertyChange")]
	function get numRows():int;

	/** Column 갯수 */
	[Bindable(event="propertyChange")]
	function get numColumns():int;

	/** columnSeparatorSize */
	[Bindable(event="propertyChange")]
	function get columnSeparatorSize():int;

	/** rowSeparatorSize */
	[Bindable(event="propertyChange")]
	function get rowSeparatorSize():int;

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

	/** 잠겨있지 않은 Column들의 Column Count 기준 Scroll 위치 */
	function get horizontalScrollColumnPosition():Number;
	function set horizontalScrollColumnPosition(value:Number):void;
}
}
