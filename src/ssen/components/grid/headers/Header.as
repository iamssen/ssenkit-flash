package ssen.components.grid.headers {

import flash.utils.getTimer;

import mx.core.mx_internal;

import spark.components.Group;
import spark.components.supportClasses.SkinnableComponent;

import ssen.ssen_internal;

use namespace ssen_internal;
use namespace mx_internal;

[DefaultProperty("columns")]

[Event(name="columnLayoutChanged", type="ssen.components.grid.headers.HeaderEvent")]
[Event(name="columnChanged", type="ssen.components.grid.headers.HeaderEvent")]

public class Header extends SkinnableComponent implements IHeaderContainer {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart(required="true")]
	public var lockedContainer:Group;

	[SkinPart(required="true")]
	public var unlockedContainer:Group;

	public function Header() {
		setStyle("skinClass", HeaderSkin);
	}

	public function getContainer(columnIndex:int):Group {
		return (columnIndex < lockedColumnCount) ? lockedContainer : unlockedContainer;
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
			_horizontalScrollPosition = 0;
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
	// computedLockedColumnWidthTotal
	// TODO locked 구현 필요
	//---------------------------------------------
	private var _computedLockedColumnWidthTotal:Number;

	/** computedLockedColumnWidthTotal */
	public function get computedLockedColumnWidthTotal():Number {
		return _computedLockedColumnWidthTotal;
	}

	//---------------------------------------------
	// computedUnlockedColumnWidthTotal
	// TODO locked 구현 필요
	//---------------------------------------------
	private var _computedUnlockedColumnWidthTotal:Number;

	/** computedUnlockedColumnWidthTotal */
	public function get computedUnlockedColumnWidthTotal():Number {
		return _computedUnlockedColumnWidthTotal;
	}

	//---------------------------------------------
	// unlockedColumnCount
	// TODO locked 구현 필요
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
	// - commitProperties 에서 width 들을 계산한다
	// - scroll 은 updateDisplayList 에서 체크해서 활성화 된다
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
			if (_columnLayoutMode === HeaderLayoutMode.RATIO) {
				columnRatios = HeaderUtils.computeColumnRatios(_columns);
			} else {
				_computedColumnWidthList = HeaderUtils.getColumnWidthList(_leafColumns);
				_computedColumnPositionList = HeaderUtils.sizeToPosition(_computedColumnWidthList, _columnSeparatorSize);
			}
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
	override public function invalidateDisplayList():void {
		super.invalidateDisplayList();
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var f:int;
		var fmax:int;

		//---------------------------------------------
		// clear containers
		//---------------------------------------------
		if (lockedContainer && unlockedContainer) {
			lockedContainer.graphics.clear();
			unlockedContainer.graphics.clear();
		} else {
			return;
		}

		//---------------------------------------------
		// return
		//---------------------------------------------
		if (!_columns || unscaledWidth === 0 || unscaledHeight === 0) {
			return;
		}

		//---------------------------------------------
		// calculate ratio width
		//---------------------------------------------
		if (_columnLayoutMode === HeaderLayoutMode.RATIO) {
			var computedWidthList:Vector.<Number>;
			var computedPositionList:Vector.<Number>;
			computedWidthList = HeaderUtils.adjustRatio(unscaledWidth - (columnSeparatorSize * (numColumns - 1)), columnRatios);
			computedWidthList = HeaderUtils.cleanPixels(unscaledWidth, columnSeparatorSize, computedWidthList);
			computedPositionList = HeaderUtils.sizeToPosition(computedWidthList, columnSeparatorSize);

			_computedColumnWidthList = computedWidthList;
			_computedColumnPositionList = computedPositionList;

			columnContentChanged = true;
		}
		//		else {
		//			computedWidthList = _computedColumnWidthList;
		//			computedPositionList = _computedColumnPositionList;
		//		}

		//---------------------------------------------
		// container visible and resize
		//---------------------------------------------
		if (lockedColumnCount > 0) {
			lockedContainer.visible = true;
			lockedContainer.includeInLayout = true;

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			lockedContainer.measuredWidth = computedColumnPositionList[lockedColumnCount] - columnSeparatorSize;
			lockedContainer.measuredHeight = unscaledHeight;

			unlockedContainer.x = computedColumnPositionList[lockedColumnCount];
			unlockedContainer.measuredWidth = unscaledWidth - lockedContainer.width - columnSeparatorSize;
			unlockedContainer.measuredHeight = unscaledHeight;
		} else {
			lockedContainer.visible = false;
			lockedContainer.includeInLayout = false;

			unlockedContainer.visible = true;
			unlockedContainer.includeInLayout = true;

			unlockedContainer.x = 0;
			unlockedContainer.measuredWidth = unscaledWidth;
			unlockedContainer.measuredHeight = unscaledHeight;
			unlockedContainer.invalidateSize();
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

		trace("Header.updateDisplayList(", unscaledWidth, unscaledHeight, ")");
		trace("Header.updateDisplayList()", columnRatios.length, columnRatios);
		trace("Header.updateDisplayList(", computedColumnWidthList.length, computedColumnWidthList, ")");
		//		trace("Header.updateDisplayList()", leafColumns.length, leafColumns);

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