package ssen.components.grid.headers {

import flash.display.Graphics;
import flash.utils.getTimer;

import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;

import spark.components.Group;

import ssen.ssen_internal;

use namespace ssen_internal;
use namespace mx_internal;

[DefaultProperty("columns")]

public class Header extends Group implements IHeaderContainer {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	public var lockedContainer:Group;
	public var unlockedContainer:Group;

	public function Header() {
		clipAndEnableScrolling = true;
	}

	public function getContainer(columnIndex:int):Group {
		return (columnIndex < lockedColumnCount) ? lockedContainer : unlockedContainer;
	}

	//==========================================================================================
	// implements
	//==========================================================================================
	//----------------------------------------------------------------
	// export values
	//----------------------------------------------------------------
	//---------------------------------------------
	// computedColumnWidthList
	//---------------------------------------------
	private var _computedColumnWidthList:Vector.<Number>;

	/** computedColumnWidthList */
	[Bindable(event="propertyChange")]
	public function get computedColumnWidthList():Vector.<Number> {
		return _computedColumnWidthList;
	}

	private function set_computedColumnWidthList(value:Vector.<Number>):void {
		var oldValue:Vector.<Number> = _computedColumnWidthList;
		_computedColumnWidthList = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "computedColumnWidthList", oldValue, _computedColumnWidthList));
		}
	}

	//---------------------------------------------
	// computedColumnPositionList
	//---------------------------------------------
	private var _computedColumnPositionList:Vector.<Number>;

	/** computedColumnPositionList */
	[Bindable(event="propertyChange")]
	public function get computedColumnPositionList():Vector.<Number> {
		return _computedColumnPositionList;
	}

	private function set_computedColumnPositionList(value:Vector.<Number>):void {
		var oldValue:Vector.<Number> = _computedColumnPositionList;
		_computedColumnPositionList = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "computedColumnPositionList", oldValue, _computedColumnPositionList));
		}
	}

	//---------------------------------------------
	// computedLockedColumnWidthTotal
	// TODO locked 구현 필요
	//---------------------------------------------
	private var _computedLockedColumnWidthTotal:Number;

	/** computedLockedColumnWidthTotal */
	[Bindable(event="propertyChange")]
	public function get computedLockedColumnWidthTotal():Number {
		return _computedLockedColumnWidthTotal;
	}

	private function set_computedLockedColumnWidthTotal(value:Number):void {
		var oldValue:Number = _computedLockedColumnWidthTotal;
		_computedLockedColumnWidthTotal = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "computedLockedColumnWidthTotal", oldValue, _computedLockedColumnWidthTotal));
		}
	}

	//---------------------------------------------
	// computedUnlockedColumnWidthTotal
	// TODO locked 구현 필요
	//---------------------------------------------
	private var _computedUnlockedColumnWidthTotal:Number;

	/** computedUnlockedColumnWidthTotal */
	[Bindable(event="propertyChange")]
	public function get computedUnlockedColumnWidthTotal():Number {
		return _computedUnlockedColumnWidthTotal;
	}

	private function set_computedUnlockedColumnWidthTotal(value:Number):void {
		var oldValue:Number = _computedUnlockedColumnWidthTotal;
		_computedUnlockedColumnWidthTotal = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "computedUnlockedColumnWidthTotal", oldValue, _computedUnlockedColumnWidthTotal));
		}
	}

	//---------------------------------------------
	// unlockedColumnCount
	// TODO locked 구현 필요
	//---------------------------------------------
	private var _unlockedColumnCount:int;

	/** unlockedColumnCount */
	[Bindable(event="propertyChange")]
	public function get unlockedColumnCount():int {
		return _unlockedColumnCount;
	}

	private function set_unlockedColumnCount(value:int):void {
		var oldValue:int = _unlockedColumnCount;
		_unlockedColumnCount = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "unlockedColumnCount", oldValue, _unlockedColumnCount));
		}
	}

	//---------------------------------------------
	// scrollEnabled
	// TODO scroll 구현 필요
	//---------------------------------------------
	/** scrollEnabled */
	public function get scrollEnabled():Boolean {
		return false;
	}

	//---------------------------------------------
	// leafColumns
	//---------------------------------------------
	private var _leafColumns:Vector.<IHeaderLeafColumn>;

	/** leafColumns */
	[Bindable(event="propertyChange")]
	public function get leafColumns():Vector.<IHeaderLeafColumn> {
		return _leafColumns;
	}

	private function set_leafColumns(value:Vector.<IHeaderLeafColumn>):void {
		var oldValue:Vector.<IHeaderLeafColumn> = _leafColumns;
		_leafColumns = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "leafColumns", oldValue, _leafColumns));
		}
	}

	//---------------------------------------------
	// numRows
	//---------------------------------------------
	private var _numRows:int;

	/** numRows */
	[Bindable(event="propertyChange")]
	public function get numRows():int {
		return _numRows;
	}

	private function set_numRows(value:int):void {
		var oldValue:int = _numRows;
		_numRows = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "numRows", oldValue, _numRows));
		}
	}

	//---------------------------------------------
	// numColumns
	//---------------------------------------------
	private var _numColumns:int;

	/** numColumns */
	[Bindable(event="propertyChange")]
	public function get numColumns():int {
		return _numColumns;
	}

	private function set_numColumns(value:int):void {
		var oldValue:int = _numColumns;
		_numColumns = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "numColumns", oldValue, _numColumns));
		}
	}

	//----------------------------------------------------------------
	// setting values
	//----------------------------------------------------------------
	//---------------------------------------------
	// columnSeparatorSize
	//---------------------------------------------
	private var _columnSeparatorSize:int = 3;

	/** columnSeparatorSize */
	public function get columnSeparatorSize():int {
		return _columnSeparatorSize;
	}

	public function set columnSeparatorSize(value:int):void {
		_columnSeparatorSize = value;
		invalidate_columnLayout();
	}

	//---------------------------------------------
	// rowSeparatorSize
	//---------------------------------------------
	private var _rowSeparatorSize:int = 3;

	/** rowSeparatorSize */
	public function get rowSeparatorSize():int {
		return _rowSeparatorSize;
	}

	public function set rowSeparatorSize(value:int):void {
		_rowSeparatorSize = value;
		invalidate_columnLayout();
	}

	//---------------------------------------------
	// columns
	//---------------------------------------------
	private var _columns:Vector.<IHeaderColumn>;

	/** columns */
	public function get columns():Vector.<IHeaderColumn> {
		return _columns;
	}

	public function set columns(value:Vector.<IHeaderColumn>):void {
		_columns = value;
		invalidate_columns();
	}

	//---------------------------------------------
	// lockedColumnCount
	// TODO locked 구현 필요
	//---------------------------------------------
	private var _lockedColumnCount:int;

	/** lockedColumnCount */
	public function get lockedColumnCount():int {
		return _lockedColumnCount;
	}

	public function set lockedColumnCount(value:int):void {
		_lockedColumnCount = value;
		invalidate_columnLayout();
	}

	//---------------------------------------------
	// rowHeight
	//---------------------------------------------
	private var _rowHeight:int = 30;

	/** rowHeight */
	public function get rowHeight():int {
		return _rowHeight;
	}

	public function set rowHeight(value:int):void {
		_rowHeight = value;
		invalidate_columnLayout();
	}

	//----------------------------------------------------------------
	// state values
	//----------------------------------------------------------------
	//---------------------------------------------
	// horizontalScrollPosition
	// TODO scroll 구현 필요
	//---------------------------------------------
	//	/** horizontalScrollPosition */
	//	[Bindable]
	//	public function get horizontalScrollPosition():Number {
	//		return 0;
	//	}
	//
	//	public function set horizontalScrollPosition(value:Number):void {
	//	}

	//---------------------------------------------
	// horizontalScrollColumnPosition
	// TODO scroll 구현 필요
	//---------------------------------------------
	/** horizontalScrollColumnPosition */
	public function get horizontalScrollColumnPosition():Number {
		return 0;
	}

	public function set horizontalScrollColumnPosition(value:Number):void {
	}

	//==========================================================================================
	// exclude
	//==========================================================================================
	override public function set maxHeight(value:Number):void {
		trace("Header.maxHeight:set is excluded");
	}

	override public function set minHeight(value:Number):void {
		trace("Header.minHeight:set is excluded");
	}

	override public function set height(value:Number):void {
		trace("Header.height:set is excluded");
	}

	//==========================================================================================
	// invalidate
	//==========================================================================================
	private var columnsChanged:Boolean;
	private var columnLayoutChanged:Boolean;
	private var columnContentChanged:Boolean;
	private var scrollChanged:Boolean;

	// column 정보 자체가 바뀔때
	protected function invalidate_columns():void {
		columnsChanged = true;
		invalidateProperties();
	}

	// column들의 사이즈 정보가 바뀔때
	protected function invalidate_columnLayout():void {
		columnLayoutChanged = true;
		invalidateSize();
	}

	// column 내부의 content가 바뀔때 (renderer 혹은, headerText와 같이...)
	protected function invalidate_columnContent():void {
		columnContentChanged = true;
		invalidateDisplayList();
	}

	// scroll 정보가 바뀔때
	protected function invalidate_scroll():void {
		scrollChanged = true;
		invalidateDisplayList();
	}

	//==========================================================================================
	// commit
	//==========================================================================================
	override protected function commitProperties():void {
		super.commitProperties();

		if (!lockedContainer) {
			lockedContainer = new Group;
			lockedContainer.clipAndEnableScrolling = true;
			addElement(lockedContainer);

			unlockedContainer = new Group;
			unlockedContainer.clipAndEnableScrolling = true;
			addElement(unlockedContainer);
		}

		if (columnsChanged) {
			commit_columns();
			columnsChanged = false;
			columnLayoutChanged = true;
		}

		if (columnLayoutChanged) {
			commit_columnLayout();
			columnLayoutChanged = false;
			invalidate_columnContent();
		}
	}

	override mx_internal function measureSizes():Boolean {
		if (!invalidateSizeFlag) {
			return false;
		}

		// force run measure
		explicitHeight = NaN;
		return super.measureSizes();
	}

	override protected function measure():void {
		super.measure();

		if (_columns) {
			measuredHeight = (rowHeight * numRows) + (rowSeparatorSize * (numRows - 1));
		} else {
			measuredHeight = 100;
		}
	}

	//---------------------------------------------
	// commit columns
	//---------------------------------------------
	protected function commit_columns():void {
		if (_columns) {
			initColumns();
		}
	}

	//---------------------------------------------
	// commit columnLayout
	//---------------------------------------------
	private var columnRatios:Vector.<Number>;

	protected function commit_columnLayout():void {
		if (_columns) {
			columnRatios = HeaderUtils.computeColumnRatios(_columns);
		}
	}

	//	//---------------------------------------------
	//	// commit columnContent
	//	//---------------------------------------------
	//	protected function commit_columnContent():void {
	//		if (component) {
	//			component.variable = _columnContent;
	//		}
	//	}
	//
	//	//---------------------------------------------
	//	// commit scroll
	//	//---------------------------------------------
	//	protected function commit_scroll():void {
	//		if (component) {
	//			component.variable = _scroll;
	//		}
	//	}

	//==========================================================================================
	// render
	//==========================================================================================
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var f:int;
		var fmax:int;

		// clear
		graphics.clear();
		lockedContainer.graphics.clear();
		unlockedContainer.graphics.clear();

		if (!_columns || (unscaledWidth === 0 && unscaledHeight)) {
			return;
		}

		// TODO 활성화 필요
		//		if (scrollChanged) {
		//			commit_scroll();
		//			scrollChanged = false;
		//		}
		//
		//		if (columnContentChanged) {
		//			commit_columnContent();
		//			columnContentChanged = false;
		//		}

		//---------------------------------------------
		// TODO 일단 ratio mode만 작업 중
		//---------------------------------------------
		//		if (_columnMode === "ratio") {
		var computedWidthList:Vector.<Number> = HeaderUtils.adjustRatio(unscaledWidth - (columnSeparatorSize * (numColumns - 1)), columnRatios);
		//		} else {
		//			computed=widthList;
		//		}

		//---------------------------------------------
		// 픽셀이 튀거나 하는 현상을 해결하기 위해 width들을 깔끔하게 다듬는다
		//---------------------------------------------
		computedWidthList = HeaderUtils.cleanPixels(unscaledWidth, columnSeparatorSize, computedWidthList);
		var computedPositionList:Vector.<Number> = HeaderUtils.sizeToPosition(computedWidthList, columnSeparatorSize);
		set_computedColumnWidthList(computedWidthList);
		set_computedColumnPositionList(computedPositionList);

		//---------------------------------------------
		// container visible and resize
		//---------------------------------------------
		if (lockedColumnCount > 0) {
			lockedContainer.visible = true;
			lockedContainer.includeInLayout = true;

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			lockedContainer.setActualSize(computedColumnPositionList[lockedColumnCount] - columnSeparatorSize, unscaledHeight);

			unlockedContainer.x = computedColumnPositionList[lockedColumnCount];
			unlockedContainer.setActualSize(unscaledWidth - lockedContainer.width - columnSeparatorSize, unscaledHeight);
		} else {
			lockedContainer.visible = false;
			lockedContainer.includeInLayout = false;

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			unlockedContainer.x = 0;
			unlockedContainer.setActualSize(unscaledWidth, unscaledHeight);
		}

		trace("Header.updateDisplayList(", unscaledWidth, unscaledHeight, unlockedContainer.width, unlockedContainer.height, ")");
		trace("Header.updateDisplayList()", columnRatios.length, columnRatios);
		trace("Header.updateDisplayList(", computedColumnWidthList.length, computedColumnWidthList, ")");
		//		trace("Header.updateDisplayList()", leafColumns.length, leafColumns);

		// TODO test code
		var g:Graphics = graphics;
		g.beginFill(0, 0.1);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();


		//---------------------------------------------
		// render
		//---------------------------------------------
		f = -1;
		fmax = _columns.length;

		trace("Header.updateDisplayList() --------------------------------------------------------", getTimer());
		while (++f < fmax) {
			_columns[f].render();
		}
	}

	//----------------------------------------------------------------
	// column 들을 loop 돌면서 작업한다
	//----------------------------------------------------------------
	private function initColumns():void {
		// count columns and rows
		var rowsAndColumns:Vector.<int> = HeaderUtils.countColumnsAndRows(_columns);
		set_numRows(rowsAndColumns[0]);
		set_numColumns(rowsAndColumns[1]);

		// set header to columns
		// get leaf columns
		var initializer:ColumnInitializer = new ColumnInitializer;
		initializer.header = this;
		initializer.run(_columns);
		set_leafColumns(initializer.leafColumns);
	}

}
}

import ssen.components.grid.headers.IHeaderBrancheColumn;
import ssen.components.grid.headers.IHeaderColumn;
import ssen.components.grid.headers.IHeaderContainer;
import ssen.components.grid.headers.IHeaderLeafColumn;

class ColumnInitializer {
	public var header:IHeaderContainer;
	public var leafColumns:Vector.<IHeaderLeafColumn>;

	public function run(columns:Vector.<IHeaderColumn>):void {
		leafColumns = null;
		leafColumns = new Vector.<IHeaderLeafColumn>;

		analyze(columns, 0, 0);
	}

	private function analyze(columns:Vector.<IHeaderColumn>, columnIndex:int, rowIndex:int):int {
		var column:IHeaderColumn;
		var f:int = -1;
		var fmax:int = columns.length;
		var columnCount:int = 0;

		while (++f < fmax) {
			column = columns[f];

			//---------------------------------------------
			// inject IHeader to IHeaderColumn
			//---------------------------------------------
			column.header = header;
			column.columnIndex = columnIndex + columnCount;
			column.rowIndex = rowIndex;

			if (column is IHeaderLeafColumn) {
				columnCount += 1;

				//---------------------------------------------
				// add to leaf columns
				//---------------------------------------------
				leafColumns.push(column);
			}

			if (column is IHeaderBrancheColumn) {
				columnCount += analyze(IHeaderBrancheColumn(column).columns, columnIndex + columnCount, rowIndex + 1);
			}
		}

		return columnCount;
	}
}