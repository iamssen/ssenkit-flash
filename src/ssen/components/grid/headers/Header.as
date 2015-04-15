package ssen.components.grid.headers {

import mx.core.IVisualElement;
import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;

import spark.components.Group;

import ssen.common.IDisposable;
import ssen.components.grid.GridElement;
import ssen.components.grid.GridUtils;
import ssen.ssen_internal;

use namespace ssen_internal;
use namespace mx_internal;

[DefaultProperty("columns")]

[Event(name="columnLayoutChanged", type="ssen.components.grid.headers.HeaderEvent")]
[Event(name="columnChanged", type="ssen.components.grid.headers.HeaderEvent")]
[Event(name="scrollChanged", type="ssen.components.grid.headers.HeaderEvent")]
[Event(name="renderComplete", type="ssen.components.grid.headers.HeaderEvent")]

/*
 TODO [x] Branche Column 들이 container 에 의해 잘릴때 렌더링 이어서 해주기
 TODO [ ] Row Layout --> 비균등 Layout 구현을 위한 처리...
 TODO [ ] Sorter? --> 이건 Leaf Column 들에서 구현해야 할듯
 TODO [ ] Resizer? --> 이건 차후로 미루자... 당장은 빡세다
 */

public class Header extends GridElement implements IHeaderElement {
	//==========================================================================================
	// drawing containers
	//==========================================================================================
	//	public function getBlock(block:int):Group {
	//		switch (block) {
	//			case GridBlock.FRONT_LOCK:
	//				return frontLockedContainer;
	//			case GridBlock.BACK_LOCK:
	//				return backLockedContainer;
	//			default:
	//				return unlockedContainer;
	//		}
	//	}

	public function get computedFrontLockedBlockWidth():Number {
		if (_columnLayoutMode === HeaderLayoutMode.RATIO || _frontLockedColumnCount === 0 || !frontLockedContainer) {
			return 0;
		}
		return frontLockedContainer.width;
	}

	public function get computedBackLockedBlockWidth():Number {
		if (_columnLayoutMode === HeaderLayoutMode.RATIO || _backLockedColumnCount === 0 || !backLockedContainer) {
			return 0;
		}
		return backLockedContainer.width;
	}

	public function get computedUnlockedBlockWidth():Number {
		return unlockedContainer.width;
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

	// column들의 사이즈, 구조 정보가 바뀔때
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

	// column 들을 loop 돌면서 초기화 시킨다
	private function initColumns():void {
		// count columns and rows
		var rowsAndColumns:Vector.<int> = GridUtils.countColumnsAndRows(_columns);
		_numRows = rowsAndColumns[0];
		_numColumns = rowsAndColumns[1];

		// set header to columns
		// get leaf columns
		var initializer:ColumnInitializer = new ColumnInitializer;
		initializer.header = this;
		initializer.run(_columns);
		_leafColumns = initializer.leafColumns;
	}

	//---------------------------------------------
	// commit columnLayout
	//---------------------------------------------
	private var columnRatios:Vector.<Number>;

	protected function commit_columnLayout():void {
		if (_columns) {
			// layout 이 ratio 인 경우에는 column 들의 ratio 비율들만 만들어놓는다
			// 비율치이기 때문에 실측값은 updateDisplayList 에서 계산하게 된다
			// 그렇지 않은 경우에는 모든 width 값들을 미리 계산해놓는다
			if (_columnLayoutMode === HeaderLayoutMode.RATIO) {
				columnRatios = GridUtils.computeColumnRatios(_columns);
				_unlockedColumnCount = columnRatios.length;
			} else {
				_computedColumnWidthList = GridUtils.getColumnWidthList(_leafColumns);
				_computedColumnPositionList = GridUtils.sizeToPosition(_computedColumnWidthList, _columnSeparatorSize);

				// front locked column width total
				if (_frontLockedColumnCount > 0) {
					var frontLockStartIndex:int = 0;
					var frontLockEndIndex:int = _frontLockedColumnCount - 1;
					_computedFrontLockedColumnWidthTotal = GridUtils.sumValues(_computedColumnWidthList, frontLockStartIndex, frontLockEndIndex, _columnSeparatorSize);
				} else {
					_computedFrontLockedColumnWidthTotal = 0;
				}

				// back locked column width total
				if (_backLockedColumnCount > 0) {
					var backLockStartIndex:int = _computedColumnWidthList.length - _backLockedColumnCount;
					var backLockEndIndex:int = _computedColumnWidthList.length - 1;
					_computedBackLockedColumnWidthTotal = GridUtils.sumValues(_computedColumnWidthList, backLockStartIndex, backLockEndIndex, _columnSeparatorSize);
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
				_computedUnlockedColumnWidthTotal = GridUtils.sumValues(_computedColumnWidthList, unlockedStartIndex, unlockedEndIndex, _columnSeparatorSize);

				// etc
				_unlockedColumnCount = _computedColumnWidthList.length - _frontLockedColumnCount - _backLockedColumnCount;
				_contentWidth = _computedFrontLockedColumnWidthTotal + _columnSeparatorSize + _computedUnlockedColumnWidthTotal + _columnSeparatorSize + _computedBackLockedColumnWidthTotal;

				columnRatios = null;
				columnLayoutUpdated = true;
			}
		}
	}

	//---------------------------------------------
	// commit columnContent
	//---------------------------------------------
	protected function commit_columnContent():void {
		//		trace("Header.commit_columnContent()", columnLayoutMode, _columns);

		// container 들을 clear 한다
		disposeContainer(frontLockedContainer);
		disposeContainer(unlockedContainer);
		disposeContainer(backLockedContainer);

		// rendering 한다
		if (_columns) {
			var f:int = -1;
			var fmax:int = _columns.length;

			while (++f < fmax) {
				_columns[f].render();
			}
		}
	}

	private static function disposeContainer(container:Group):void {
		var f:int = container.numElements;
		var el:IVisualElement;
		while (--f >= 0) {
			el = container.getElementAt(f);
			if (el is IDisposable) {
				IDisposable(el).dispose();
			}
		}
		container.removeAllElements();
		container.graphics.clear();
	}

	//---------------------------------------------
	// commit scroll
	//---------------------------------------------
	protected function commit_scroll():void {
		if (unlockedContainer) {
			// layout mode가 ratio인 경우에는 scroll들을 비활성 시키고,
			// fixed 일 경우에는 unlocked contents 들의 width total이 unlocked container 보다 큰지 확인한다
			if (_columnLayoutMode === HeaderLayoutMode.RATIO) {
				_scrollEnabled = false;
				initialHorizontalScroll = true;
			} else {
				_scrollEnabled = _computedUnlockedColumnWidthTotal > unlockedContainer.measuredWidth;
				if (!_scrollEnabled) initialHorizontalScroll = true;
			}

			// scroll 을 초기화 시켜버리라는 요청이 있었던 경우에는 scroll 값들을 초기화 시킨다
			// 그렇지 않은 경우에는 unlocked container 의 scroll 을 조정해준다
			if (initialHorizontalScroll) {
				_horizontalScrollPosition = 0;
				unlockedContainer.horizontalScrollPosition = 0;
				initialHorizontalScroll = false;
			} else {
				unlockedContainer.horizontalScrollPosition = _horizontalScrollPosition;
			}

			// horizontal scroll position 에 대한 property change 알림을 준다
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, null, "horizontalScrollPosition"));
		}
	}

	//==========================================================================================
	// render
	//==========================================================================================
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
			var computedWidthList:Vector.<Number>;
			var computedPositionList:Vector.<Number>;
			computedWidthList = GridUtils.adjustRatio(unscaledWidth - (columnSeparatorSize * (numColumns - 1)), columnRatios);
			computedWidthList = GridUtils.cleanPixels(unscaledWidth, columnSeparatorSize, computedWidthList);
			computedPositionList = GridUtils.sizeToPosition(computedWidthList, columnSeparatorSize);

			_computedColumnWidthList = computedWidthList;
			_computedColumnPositionList = computedPositionList;
			_computedFrontLockedColumnWidthTotal = 0;
			_computedUnlockedColumnWidthTotal = unscaledWidth;
			_computedBackLockedColumnWidthTotal = 0;

			columnContentChanged = true;
			columnLayoutUpdated = true;
		}

		//---------------------------------------------
		// visible and resize container
		//---------------------------------------------
		// TODO 코드 정리 필요
		if (_columnLayoutMode === HeaderLayoutMode.FIXED) {
			var frontGap:Number = 0;
			var backGap:Number = 0;

			if (_frontLockedColumnCount > 0) {
				frontLockedContainer.visible = true;
				frontLockedContainer.includeInLayout = true;

				frontGap = columnSeparatorSize;
			} else {
				frontLockedContainer.visible = false;
				frontLockedContainer.includeInLayout = false;

				frontGap = 0;
			}

			if (_backLockedColumnCount > 0) {
				backLockedContainer.visible = true;
				backLockedContainer.includeInLayout = true;

				backGap = columnSeparatorSize;
			} else {
				backLockedContainer.visible = false;
				backLockedContainer.includeInLayout = false;

				backGap = 0;
			}

			var unlockedWidth:Number = unscaledWidth - _computedFrontLockedColumnWidthTotal - frontGap - _computedBackLockedColumnWidthTotal - backGap;
			if (unlockedWidth > _computedUnlockedColumnWidthTotal) unlockedWidth = _computedUnlockedColumnWidthTotal;

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			unlockedContainer.x = _computedFrontLockedColumnWidthTotal + frontGap;
			unlockedContainer.measuredWidth = unlockedWidth;
			unlockedContainer.measuredHeight = unscaledHeight;

			unlockedContainer.invalidateSize();

			if (_frontLockedColumnCount > 0) {
				frontLockedContainer.measuredWidth = _computedFrontLockedColumnWidthTotal;
				frontLockedContainer.measuredHeight = unscaledHeight;

				frontLockedContainer.invalidateSize();
			}

			if (_backLockedColumnCount > 0) {
				backLockedContainer.x = unlockedContainer.x + unlockedContainer.width + _columnSeparatorSize;
				backLockedContainer.measuredWidth = _computedBackLockedColumnWidthTotal;
				backLockedContainer.measuredHeight = unscaledHeight;

				backLockedContainer.invalidateSize();
			}
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

		//---------------------------------------------
		// column layout 이 update 되었으면 dispatch 시킨다
		//---------------------------------------------
		if (columnLayoutUpdated) {
			// column 들의 layout 이 바뀌었으니 연결된 contents 들의 column width 들을 업데이트 하길 알린다
			dispatchEvent(new HeaderEvent(HeaderEvent.COLUMN_LAYOUT_CHANGED));
			// scroller를 위한 contentWidth를 dispatch 시켜준다
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, null, "contentWidth"));

			columnLayoutUpdated = false;
		}

		//---------------------------------------------
		// 바뀐 scroll 값을 적용한다
		//---------------------------------------------
		if (scrollChanged) {
			// 바뀐 scroll 값들을 적용한다
			commit_scroll();
			// scroll 정보가 바뀌었으니 하위 contents 들의 scroll 정보들을 업데이트 하길 알린다
			dispatchEvent(new HeaderEvent(HeaderEvent.SCROLL));

			scrollChanged = false;
		}

		//---------------------------------------------
		// content 를 새롭게 rendering 시킨다
		//---------------------------------------------
		if (columnContentChanged) {
			// 새롭게 rendering 한다
			commit_columnContent();
			// rendering 이 끝났음을 알린다 (외부에서 contents 갱신등에 쓴다)
			dispatchEvent(new HeaderEvent(HeaderEvent.RENDER_COMPLETE));

			columnContentChanged = false;
		}

		//		trace("Header.updateDisplayList(", unscaledWidth, unscaledHeight, ")");
		//		trace("Header.updateDisplayList()", columnRatios.length, columnRatios);
		//		trace("Header.updateDisplayList(", computedColumnWidthList.length, computedColumnWidthList, ")");
		//		trace("Header.updateDisplayList()", leafColumns.length, leafColumns);
	}


}
}

import ssen.components.grid.headers.IHeaderBrancheColumn;
import ssen.components.grid.headers.IHeaderColumn;
import ssen.components.grid.headers.IHeaderElement;
import ssen.components.grid.headers.IHeaderLeafColumn;

class ColumnInitializer {
	public var header:IHeaderElement;
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