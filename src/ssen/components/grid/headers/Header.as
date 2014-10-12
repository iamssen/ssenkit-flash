package ssen.components.grid.headers {

import flash.display.Graphics;

import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;

import spark.components.SkinnableContainer;

import ssen.ssen_internal;

use namespace ssen_internal;
use namespace mx_internal;

[DefaultProperty("columns")]

public class Header extends SkinnableContainer implements IHeaderContainer {

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function Header() {

	}

	//==========================================================================================
	// implements
	//==========================================================================================
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

	//---------------------------------------------
	// columnSeparatorSize
	//---------------------------------------------
	private var _columnSeparatorSize:int = 3;

	/** columnSeparatorSize */
	[Bindable]
	public function get columnSeparatorSize():int {
		return _columnSeparatorSize;
	}

	public function set columnSeparatorSize(value:int):void {
		var oldValue:int = _columnSeparatorSize;
		_columnSeparatorSize = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columnSeparatorSize", oldValue, _columnSeparatorSize));
		}

		invalidate_columnLayout();
	}

	//---------------------------------------------
	// columns
	//---------------------------------------------
	private var _columns:Vector.<IHeaderColumn>;

	/** columns */
	[Bindable]
	public function get columns():Vector.<IHeaderColumn> {
		return _columns;
	}

	public function set columns(value:Vector.<IHeaderColumn>):void {
		if (_columns === value) {
			return;
		}

		var oldValue:Vector.<IHeaderColumn> = _columns;
		_columns = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columns", oldValue, _columns));
		}

		invalidate_columns();
	}

	//---------------------------------------------
	// lockedColumnCount
	// TODO locked 구현 필요
	//---------------------------------------------
	private var _lockedColumnCount:int;

	/** lockedColumnCount */
	[Bindable]
	public function get lockedColumnCount():int {
		return _lockedColumnCount;
	}

	public function set lockedColumnCount(value:int):void {
		var oldValue:int = _lockedColumnCount;
		_lockedColumnCount = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lockedColumnCount", oldValue, _lockedColumnCount));
		}

		invalidate_columnLayout();
	}

	//---------------------------------------------
	// horizontalScrollPosition
	// TODO scroll 구현 필요
	//---------------------------------------------
	/** horizontalScrollPosition */
	[Bindable]
	public function get horizontalScrollPosition():Number {
		return 0;
	}

	public function set horizontalScrollPosition(value:Number):void {
	}

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
	// rowHeight
	//---------------------------------------------
	private var _rowHeight:int = 25;

	/** rowHeight */
	public function get rowHeight():int {
		return _rowHeight;
	}

	public function set rowHeight(value:int):void {
		_rowHeight = value;
		invalidate_columnLayout();
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
	// life cycle
	//==========================================================================================
	override protected function commitProperties():void {
		super.commitProperties();

		if (columnsChanged) {
			commit_columns();
			columnsChanged = false;
			invalidate_columnLayout();
		}
	}

	override mx_internal function measureSizes():Boolean {
		if (!invalidateSizeFlag) {
			return false;
		}

		// force run measure
		explicitHeight = NaN;
		return super.mx_internal::measureSizes();
	}

	override protected function measure():void {
		super.measure();

		if (_columns) {
			if (isNaN(explicitWidth)) {
				explicitWidth = 500;
			}

			measuredWidth = explicitWidth;
			measuredHeight = (rowHeight * numRows) + (rowSeparatorSize * (numRows - 1));
		} else {
			measuredWidth = explicitWidth;
			measuredHeight = 100;
		}

		invalidateSkinState();
		invalidateParentSizeAndDisplayList();
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
			columnRatios = computeColumnRatios(_columns);
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


	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		// clear
		graphics.clear();
		removeAllElements();

		if (!_columns || (unscaledWidth === 0 && unscaledHeight)) {
			return;
		}

		if (columnLayoutChanged) {
			commit_columnLayout();
			columnLayoutChanged = false;
			columnContentChanged = true;
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
		var computedWidthList:Vector.<Number> = adjustRatio(unscaledWidth - (columnSeparatorSize * (numColumns - 1)), columnRatios);
		//		} else {
		//			computed=widthList;
		//		}

		//---------------------------------------------
		// 픽셀이 튀거나 하는 현상을 해결하기 위해 width들을 깔끔하게 다듬는다
		//---------------------------------------------
		computedWidthList = cleanPixels(unscaledWidth, columnSeparatorSize, computedWidthList);
		var computedPositionList:Vector.<Number> = sizeToPosition(computedWidthList, columnSeparatorSize);
		set_computedColumnWidthList(computedWidthList);
		set_computedColumnPositionList(computedPositionList);

		trace("Header.updateDisplayList(", unscaledWidth, unscaledHeight, ")");
		trace("Header.updateDisplayList()", columnRatios);
		trace("Header.updateDisplayList(", computedColumnWidthList.length, computedColumnWidthList, ")");
		trace("Header.updateDisplayList()", leafColumns.length, leafColumns);

		// TODO test code
		var g:Graphics = graphics;
		g.beginFill(0, 0.1);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();

		//---------------------------------------------
		// render
		//---------------------------------------------
		var f:int = -1;
		var fmax:int = _columns.length;

		while (++f < fmax) {
			_columns[f].render();
		}

		// dispatchEvent(new HeaderEvents(HeaderEvents.COMPUTED_WIDTH_LIST));
	}

	//==========================================================================================
	// column width control
	//==========================================================================================
	private static function sizeToPosition(size:Vector.<Number>, columnSeparatorSize:int):Vector.<Number> {
		var pos:Vector.<Number> = new Vector.<Number>(size.length, true);
		var nx:Number = 0;

		var f:int = -1;
		var fmax:int = size.length;
		while (++f < fmax) {
			pos[f] = nx;
			nx += size[f] + columnSeparatorSize;
		}

		return pos;
	}

	//----------------------------------------------------------------
	// column 들을 loop 돌면서 작업한다
	// 1.
	//----------------------------------------------------------------
	private function initColumns():void {
		// count columns and rows
		var rowsAndColumns:Vector.<int> = HeaderUtils.count(_columns);
		set_numRows(rowsAndColumns[0]);
		set_numColumns(rowsAndColumns[1]);

		// set header to columns
		// get leaf columns
		var initializer:ColumnInitializer = new ColumnInitializer;
		initializer.header = this;
		initializer.run(_columns);
		set_leafColumns(initializer.leafColumns);
	}

	//----------------------------------------------------------------
	// column들의 width 들을 계산한다
	// - ratio (no scroll)
	// - real (scroll)
	//----------------------------------------------------------------
	private static function computeColumnRatios(columns:Vector.<IHeaderColumn>):Vector.<Number> {
		var widthList:Vector.<Number> = new Vector.<Number>;

		// source가 되는 widthList를 읽어온다
		readColumnWidth(columns, widthList);

		trace("Header.computeColumnRatios()", widthList.length, widthList);

		return valuesToRatios(widthList);
	}

	// Pixel 단위 사이즈들을 int 단위로 깔끔하게 정리한다
	// int 단위로 정리를 한다음에 여분은 마지막 사이즈에 몰아서 준다
	private static function cleanPixels(w:Number, gap:int, values:Vector.<Number>):Vector.<Number> {
		var cleaned:Vector.<Number> = new Vector.<Number>(values.length, true);
		var fw:int;
		var nx:int = 0;

		var f:int = -1;
		var fmax:int = values.length;
		while (++f < fmax) {
			if (f === fmax - 1) {
				cleaned[f] = w - nx;
			} else {
				fw = values[f];
				cleaned[f] = fw;
				nx += fw + gap;
			}
		}

		return cleaned;
	}

	// Total을 Ratio로 쪼개서 보내준다
	private static function adjustRatio(total:Number, ratios:Vector.<Number>):Vector.<Number> {
		var computed:Vector.<Number> = new Vector.<Number>(ratios.length, true);
		var f:int = -1;
		var fmax:int = ratios.length;
		while (++f < fmax) {
			computed[f] = total * ratios[f];
		}
		return computed;
	}

	// Number 수치들을 Ratio 수치들로 바꾼다
	private static function valuesToRatios(values:Vector.<Number>):Vector.<Number> {
		var total:Number = 0;
		var ratios:Vector.<Number>;

		var f:int = -1;
		var fmax:int = values.length;
		while (++f < fmax) {
			total += values[f];
		}

		if (total !== 1) {
			ratios = new Vector.<Number>(values.length, true);

			f = -1;
			fmax = values.length;
			while (++f < fmax) {
				ratios[f] = values[f] / total;
			}
		} else {
			ratios = values;
		}

		return ratios;
	}

	// Tree 형태의 Vector.<IHeaderColumn>의 재귀 반복을 통해 최종 Leaf들만을 찾아서 widthList로 저장한다.
	private static function readColumnWidth(columns:Vector.<IHeaderColumn>, widthList:Vector.<Number>):void {
		var column:IHeaderColumn;
		var f:int = -1;
		var fmax:int = columns.length;

		while (++f < fmax) {
			column = columns[f];

			// branche 일 경우에는 재귀로 하위를 검색한다
			if (column is IHeaderBrancheColumn) {
				readColumnWidth(IHeaderBrancheColumn(column).columns, widthList);
			}

			if (column is IHeaderLeafColumn) {
				// branche 이면서 동시에 leaf 인 경우도 있기 때문에 else로 할당한다
				// leaf 일 경우에는 widthList에 추가한다
				//				if (column is IHeaderLeafColumn) {
				widthList.push(IHeaderLeafColumn(column).columnWidth);
				//				} else {
				//					throw new Error(column, "is not a IHeaderLeafColumn");
				//				}
			}
		}
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

				//				// branche 이면서 동시에 leaf 인 경우도 있기 때문에 else 로 할당한다
				//				//---------------------------------------------
				//				// add to leaf columns
				//				//---------------------------------------------
				//				if (column is IHeaderLeafColumn) {
				leafColumns.push(column);
				//				} else {
				//					throw new Error(column, "is not a IHeaderLeafColumn");
				//				}
			}

			if (column is IHeaderBrancheColumn) {
				columnCount += analyze(IHeaderBrancheColumn(column).columns, columnIndex + columnCount, rowIndex + 1);
			}
		}

		return columnCount;
	}
}