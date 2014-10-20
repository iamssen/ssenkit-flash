package ssen.components.grid.headers {

import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;

import spark.components.Group;
import spark.components.supportClasses.SkinnableComponent;

import ssen.ssen_internal;

use namespace ssen_internal;
use namespace mx_internal;

[DefaultProperty("columns")]

[Event(name="columnLayoutChanged", type="ssen.components.grid.headers.HeaderEvent")]
[Event(name="columnChanged", type="ssen.components.grid.headers.HeaderEvent")]
[Event(name="scrollChanged", type="ssen.components.grid.headers.HeaderEvent")]
[Event(name="renderComplete", type="ssen.components.grid.headers.HeaderEvent")]

public class Header extends SkinnableComponent implements IHeaderContainer {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart(required="true")]
	public var frontLockedContainer:Group;

	[SkinPart(required="true")]
	public var backLockedContainer:Group;

	[SkinPart(required="true")]
	public var unlockedContainer:Group;

	public function Header() {
		setStyle("skinClass", HeaderSkin);
	}

	public function getContainerId(columnIndex:int):int {
		if (_columnLayoutMode === HeaderLayoutMode.RATIO) {
			return HeaderContainerId.UNLOCK;
		} else if (columnIndex < frontLockedColumnCount) {
			return HeaderContainerId.FRONT_LOCK;
		} else if (columnIndex >= numColumns - backLockedColumnCount) {
			return HeaderContainerId.BACK_LOCK;
		} else {
			return HeaderContainerId.UNLOCK;
		}
	}

	public function getContainer(containerId:int):Group {
		switch (containerId) {
			case HeaderContainerId.FRONT_LOCK:
				return frontLockedContainer;
			case HeaderContainerId.BACK_LOCK:
				return backLockedContainer;
			default:
				return unlockedContainer;
		}
	}

	//---------------------------------------------
	// columnLayoutMode
	//---------------------------------------------
	private var _columnLayoutMode:String = "ratio";

	/** columnLayoutMode */
	public function get columnLayoutMode():String {
		return _columnLayoutMode;
	}

	[Inspectable(type="String", defaultValue="ratio", enumeration="ratio,fixed")]
	public function set columnLayoutMode(value:String):void {
		_columnLayoutMode = value;
		if (value === HeaderLayoutMode.RATIO) {
			_scrollEnabled = false;
		} else {
			initialHorizontalScroll = true;
			invalidate_scroll();
		}
		invalidate_columnLayout();
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
	public function get computedColumnWidthList():Vector.<Number> {
		return _computedColumnWidthList;
	}

	//---------------------------------------------
	// computedColumnPositionList
	//---------------------------------------------
	private var _computedColumnPositionList:Vector.<Number>;

	/** computedColumnPositionList */
	public function get computedColumnPositionList():Vector.<Number> {
		return _computedColumnPositionList;
	}

	//---------------------------------------------
	// computedFrontLockedColumnWidthTotal
	//---------------------------------------------
	private var _computedFrontLockedColumnWidthTotal:Number;

	/** computedFrontLockedColumnWidthTotal */
	public function get computedFrontLockedColumnWidthTotal():Number {
		return _computedFrontLockedColumnWidthTotal;
	}

	//---------------------------------------------
	// computedBackLockedColumnWidthTotal
	//---------------------------------------------
	private var _computedBackLockedColumnWidthTotal:Number;

	/** computedBackLockedColumnWidthTotal */
	public function get computedBackLockedColumnWidthTotal():Number {
		return _computedBackLockedColumnWidthTotal;
	}

	//---------------------------------------------
	// computedUnlockedColumnWidthTotal
	//---------------------------------------------
	private var _computedUnlockedColumnWidthTotal:Number;

	/** computedUnlockedColumnWidthTotal */
	public function get computedUnlockedColumnWidthTotal():Number {
		return _computedUnlockedColumnWidthTotal;
	}

	//---------------------------------------------
	// unlockedColumnCount
	//---------------------------------------------
	private var _unlockedColumnCount:int;

	/** unlockedColumnCount */
	public function get unlockedColumnCount():int {
		return _unlockedColumnCount;
	}

	//---------------------------------------------
	// scrollEnabled
	//---------------------------------------------
	private var _scrollEnabled:Boolean;

	/** scrollEnabled */
	public function get scrollEnabled():Boolean {
		return _scrollEnabled;
	}

	//---------------------------------------------
	// leafColumns
	//---------------------------------------------
	private var _leafColumns:Vector.<IHeaderLeafColumn>;

	/** leafColumns */
	public function get leafColumns():Vector.<IHeaderLeafColumn> {
		return _leafColumns;
	}

	//---------------------------------------------
	// numRows
	//---------------------------------------------
	private var _numRows:int;

	/** numRows */
	public function get numRows():int {
		return _numRows;
	}

	//---------------------------------------------
	// numColumns
	//---------------------------------------------
	private var _numColumns:int;

	/** numColumns */
	public function get numColumns():int {
		return _numColumns;
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
	// frontLockedColumnCount
	//---------------------------------------------
	private var _frontLockedColumnCount:int;

	/** frontLockedColumnCount */
	public function get frontLockedColumnCount():int {
		return _frontLockedColumnCount;
	}

	public function set frontLockedColumnCount(value:int):void {
		_frontLockedColumnCount = value;
		initialHorizontalScroll = true;
		invalidate_scroll();
		invalidate_columnLayout();
	}

	//---------------------------------------------
	// backLockedColumnCount
	//---------------------------------------------
	private var _backLockedColumnCount:int;

	/** backLockedColumnCount */
	public function get backLockedColumnCount():int {
		return _backLockedColumnCount;
	}

	public function set backLockedColumnCount(value:int):void {
		_backLockedColumnCount = value;
		initialHorizontalScroll = true;
		invalidate_scroll();
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

	//==========================================================================================
	// implements IViewPort
	//==========================================================================================
	//---------------------------------------------
	// horizontalScrollPosition
	//---------------------------------------------
	private var _horizontalScrollPosition:Number;

	/** horizontalScrollPosition */
	public function get horizontalScrollPosition():Number {
		if (_columnLayoutMode === HeaderLayoutMode.RATIO) {
			return 0;
		}

		return _horizontalScrollPosition;
	}

	public function set horizontalScrollPosition(value:Number):void {
		_horizontalScrollPosition = value;
		invalidate_scroll();
	}

	private var _contentWidth:Number;

	public function get contentWidth():Number {
		if (_columnLayoutMode === HeaderLayoutMode.RATIO) {
			return width;
		}

		return _contentWidth;
	}

	public function get contentHeight():Number {
		return height;
	}

	public function get verticalScrollPosition():Number {
		return 0;
	}

	public function set verticalScrollPosition(value:Number):void {
	}

	// TODO horizontal scroll
	public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number {
		return 0;
	}

	public function getVerticalScrollPositionDelta(navigationUnit:uint):Number {
		return 0;
	}

	public function get clipAndEnableScrolling():Boolean {
		return true;
	}

	public function set clipAndEnableScrolling(value:Boolean):void {
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
	private var columnLayoutUpdated:Boolean;
	private var initialHorizontalScroll:Boolean;

	// column 정보 자체가 바뀔때
	protected function invalidate_columns():void {
		columnsChanged = true;
		invalidateProperties();
	}

	// column들의 사이즈 정보가 바뀔때
	protected function invalidate_columnLayout():void {
		columnLayoutChanged = true;
		invalidateProperties();
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


	//	override public function invalidateProperties():void {
	//		super.invalidateProperties();
	//	}
	//
	//	override public function invalidateDisplayList():void {
	//		super.invalidateDisplayList();
	//	}
	//
	//	override public function invalidateSize():void {
	//		super.invalidateSize();
	//	}

	public function invalidateColumns():void {
		invalidate_columns();
	}

	public function invalidateColumnLayout():void {
		invalidate_columnLayout();
	}

	public function invalidateColumnContent():void {
		invalidate_columnContent();
	}

	public function invalidateScroll():void {
		invalidate_scroll();
	}

	//==========================================================================================
	// commit
	//
	// ratio
	// - [x] commitProperties 에서 ratio 비율을 계산하고,
	// - [x] updateDisplayList 에서 실제 width 들을 계산한다
	// - [x] scroll 은 무조건 비활성 된다
	//
	// fixed
	// - [x] commitProperties 에서 width 들을 계산한다
	// - [x] scroll 은 updateDisplayList 에서 체크해서 활성화 된다
	//==========================================================================================
	override protected function commitProperties():void {
		super.commitProperties();

		if (columnsChanged) {
			commit_columns();
			columnsChanged = false;
			columnLayoutChanged = true;
		}

		if (columnLayoutChanged) {
			commit_columnLayout();
			columnLayoutChanged = false;
			columnLayoutUpdated = true;
			columnContentChanged = true;
			invalidateDisplayList();
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
			dispatchEvent(new HeaderEvent(HeaderEvent.COLUMN_CHANGED));
		}
	}

	//---------------------------------------------
	// commit columnLayout
	//---------------------------------------------
	private var columnRatios:Vector.<Number>;

	protected function commit_columnLayout():void {
		if (_columns) {
			if (_columnLayoutMode === HeaderLayoutMode.RATIO) {
				columnRatios = HeaderUtils.computeColumnRatios(_columns);
				_unlockedColumnCount = columnRatios.length;
			} else {
				_computedColumnWidthList = HeaderUtils.getColumnWidthList(_leafColumns);
				_computedColumnPositionList = HeaderUtils.sizeToPosition(_computedColumnWidthList, _columnSeparatorSize);

				// front locked column width total
				if (_frontLockedColumnCount > 0) {
					var frontLockStartIndex:int = 0;
					var frontLockEndIndex:int = _frontLockedColumnCount - 1;
					_computedFrontLockedColumnWidthTotal = HeaderUtils.sum(_computedColumnWidthList, frontLockStartIndex, frontLockEndIndex, _columnSeparatorSize);
				} else {
					_computedFrontLockedColumnWidthTotal = 0;
				}

				// back locked column width total
				if (_backLockedColumnCount > 0) {
					var backLockStartIndex:int = _computedColumnWidthList.length - _backLockedColumnCount;
					var backLockEndIndex:int = _computedColumnWidthList.length - 1;
					_computedBackLockedColumnWidthTotal = HeaderUtils.sum(_computedColumnWidthList, backLockStartIndex, backLockEndIndex, _columnSeparatorSize);
				} else {
					_computedBackLockedColumnWidthTotal = 0;
				}

				// unlocked column width total
				var unlockedStartIndex:int;
				var unlockedEndIndex:int;
				if (_frontLockedColumnCount > 0) {
					unlockedStartIndex = _frontLockedColumnCount;
				} else {
					unlockedStartIndex = 0;
				}
				if (_backLockedColumnCount > 0) {
					unlockedEndIndex = _computedColumnWidthList.length - _backLockedColumnCount - 1;
				} else {
					unlockedEndIndex = _computedColumnWidthList.length - 1;
				}
				_computedUnlockedColumnWidthTotal = HeaderUtils.sum(_computedColumnWidthList, unlockedStartIndex, unlockedEndIndex, _columnSeparatorSize);

				_unlockedColumnCount = _computedColumnWidthList.length - _frontLockedColumnCount - _backLockedColumnCount;
				_contentWidth = _computedFrontLockedColumnWidthTotal + _computedUnlockedColumnWidthTotal + _computedBackLockedColumnWidthTotal;

				columnRatios = null;
				columnLayoutUpdated = true;
			}
		}
	}

	//---------------------------------------------
	// commit columnContent
	//---------------------------------------------
	protected function commit_columnContent():void {
		trace("Header.commit_columnContent()", columnLayoutMode, _columns);

		frontLockedContainer.graphics.clear();
		unlockedContainer.graphics.clear();
		backLockedContainer.graphics.clear();

		if (_columns) {
			var f:int = -1;
			var fmax:int = _columns.length;

			while (++f < fmax) {
				_columns[f].render();
			}
		}
	}

	//---------------------------------------------
	// commit scroll
	//---------------------------------------------
	protected function commit_scroll():void {
		if (unlockedContainer) {
			if (_columnLayoutMode === HeaderLayoutMode.RATIO) {
				_scrollEnabled = false;
				initialHorizontalScroll = true;
			} else {
				_scrollEnabled = _computedUnlockedColumnWidthTotal > unlockedContainer.measuredWidth;

				if (_scrollEnabled) {
				} else {
					initialHorizontalScroll = true;
				}
			}

			if (initialHorizontalScroll) {
				_horizontalScrollPosition = 0;
				unlockedContainer.horizontalScrollPosition = 0;
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, null, "horizontalScrollPosition"));
				initialHorizontalScroll = false;
			} else {
				unlockedContainer.horizontalScrollPosition = _horizontalScrollPosition;
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, null, "horizontalScrollPosition"));
			}

			invalidate_scroll();
		}
	}

	//==========================================================================================
	// render
	//==========================================================================================
	private var lastChangedUnscaledWidth:Number;
	private var lastChangedUnscaledHeight:Number;

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		//---------------------------------------------
		// return
		//---------------------------------------------
		if (!frontLockedContainer || !unlockedContainer || !backLockedContainer || !_columns || unscaledWidth === 0 || unscaledHeight === 0) {
			return;
		}

		//---------------------------------------------
		// calculate ratio width
		//---------------------------------------------
		if (_columnLayoutMode === HeaderLayoutMode.RATIO) {
			var changedSize:Boolean = lastChangedUnscaledWidth !== unscaledWidth || lastChangedUnscaledHeight !== unscaledHeight;
			var validateSomething:Boolean = columnContentChanged || columnLayoutChanged || columnLayoutUpdated;

			trace("Header.updateDisplayList()", changedSize, validateSomething);

			if (changedSize || validateSomething) {
				var computedWidthList:Vector.<Number>;
				var computedPositionList:Vector.<Number>;
				computedWidthList = HeaderUtils.adjustRatio(unscaledWidth - (columnSeparatorSize * (numColumns - 1)), columnRatios);
				computedWidthList = HeaderUtils.cleanPixels(unscaledWidth, columnSeparatorSize, computedWidthList);
				computedPositionList = HeaderUtils.sizeToPosition(computedWidthList, columnSeparatorSize);

				_computedColumnWidthList = computedWidthList;
				_computedColumnPositionList = computedPositionList;
				_computedFrontLockedColumnWidthTotal = 0;
				_computedUnlockedColumnWidthTotal = unscaledWidth;
				_computedBackLockedColumnWidthTotal = 0;

				columnContentChanged = true;
				columnLayoutUpdated = true;

				lastChangedUnscaledWidth = unscaledWidth;
				lastChangedUnscaledHeight = unscaledHeight;
			} else {
				return;
			}
		}
		//		else {
		//			computedWidthList = _computedColumnWidthList;
		//			computedPositionList = _computedColumnPositionList;
		//		}

		//---------------------------------------------
		// visible and resize container
		//---------------------------------------------
		if (_columnLayoutMode === HeaderLayoutMode.FIXED) {
			if (_frontLockedColumnCount > 0) {
				frontLockedContainer.visible = true;
				frontLockedContainer.includeInLayout = true;

				frontLockedContainer.measuredWidth = _computedFrontLockedColumnWidthTotal;
				frontLockedContainer.measuredHeight = unscaledHeight;

				frontLockedContainer.invalidateSize();
			} else {
				frontLockedContainer.visible = false;
				frontLockedContainer.includeInLayout = false;
			}

			if (_backLockedColumnCount > 0) {
				backLockedContainer.visible = true;
				backLockedContainer.includeInLayout = true;

				backLockedContainer.x = unscaledWidth - _computedBackLockedColumnWidthTotal;
				backLockedContainer.measuredWidth = _computedBackLockedColumnWidthTotal;
				backLockedContainer.measuredHeight = unscaledHeight;

				backLockedContainer.invalidateSize();
			} else {
				backLockedContainer.visible = false;
				backLockedContainer.includeInLayout = false;
			}

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			unlockedContainer.x = _computedFrontLockedColumnWidthTotal + columnSeparatorSize;
			unlockedContainer.measuredWidth = unscaledWidth - _computedFrontLockedColumnWidthTotal - columnSeparatorSize - _computedBackLockedColumnWidthTotal - columnSeparatorSize;
			unlockedContainer.measuredHeight = unscaledHeight;

			unlockedContainer.invalidateSize();
		} else {
			frontLockedContainer.visible = false;
			frontLockedContainer.includeInLayout = false;

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			backLockedContainer.visible = false;
			backLockedContainer.includeInLayout = false;

			unlockedContainer.x = 0;
			unlockedContainer.measuredWidth = unscaledWidth;
			unlockedContainer.measuredHeight = unscaledHeight;

			unlockedContainer.invalidateSize();
		}

		if (columnLayoutUpdated) {
			dispatchEvent(new HeaderEvent(HeaderEvent.COLUMN_LAYOUT_CHANGED));
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, null, "contentWidth"));
			//			trace("Header.updateDisplayList()", _computedUnlockedColumnWidthTotal, _computedColumnWidthList.slice(_frontLockedColumnCount));
			columnLayoutUpdated = false;
		}

		if (scrollChanged) {
			commit_scroll();
			scrollChanged = false;
			dispatchEvent(new HeaderEvent(HeaderEvent.SCROLL_CHANGED));
		}

		if (columnContentChanged) {
			commit_columnContent();
			columnContentChanged = false;
			dispatchEvent(new HeaderEvent(HeaderEvent.RENDER_COMPLETE));
		}

		//		trace("Header.updateDisplayList(", unscaledWidth, unscaledHeight, ")");
		//		trace("Header.updateDisplayList()", columnRatios.length, columnRatios);
		//		trace("Header.updateDisplayList(", computedColumnWidthList.length, computedColumnWidthList, ")");
		//		trace("Header.updateDisplayList()", leafColumns.length, leafColumns);
	}

	//----------------------------------------------------------------
	// column 들을 loop 돌면서 작업한다
	//----------------------------------------------------------------
	private function initColumns():void {
		// count columns and rows
		var rowsAndColumns:Vector.<int> = HeaderUtils.countColumnsAndRows(_columns);
		_numRows = rowsAndColumns[0];
		_numColumns = rowsAndColumns[1];

		// set header to columns
		// get leaf columns
		var initializer:ColumnInitializer = new ColumnInitializer;
		initializer.header = this;
		initializer.run(_columns);
		_leafColumns = initializer.leafColumns;
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