package ssen.components.grid.headers {
import mx.events.PropertyChangeEvent;

import spark.components.SkinnableContainer;

import ssen.ssen_internal;

use namespace ssen_internal;

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
		var oldValue:Vector.<Number>=_computedColumnWidthList;
		_computedColumnWidthList=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "computedColumnWidthList", oldValue, _computedColumnWidthList));
		}
	}

	//---------------------------------------------
	// computedLockedColumnWidthTotal
	//---------------------------------------------
	private var _computedLockedColumnWidthTotal:Number;

	/** computedLockedColumnWidthTotal */
	[Bindable(event="propertyChange")]
	public function get computedLockedColumnWidthTotal():Number {
		return _computedLockedColumnWidthTotal;
	}

	private function set_computedLockedColumnWidthTotal(value:Number):void {
		var oldValue:Number=_computedLockedColumnWidthTotal;
		_computedLockedColumnWidthTotal=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "computedLockedColumnWidthTotal", oldValue, _computedLockedColumnWidthTotal));
		}
	}

	//---------------------------------------------
	// computedUnlockedColumnWidthTotal
	//---------------------------------------------
	private var _computedUnlockedColumnWidthTotal:Number;

	/** computedUnlockedColumnWidthTotal */
	[Bindable(event="propertyChange")]
	public function get computedUnlockedColumnWidthTotal():Number {
		return _computedUnlockedColumnWidthTotal;
	}

	private function set_computedUnlockedColumnWidthTotal(value:Number):void {
		var oldValue:Number=_computedUnlockedColumnWidthTotal;
		_computedUnlockedColumnWidthTotal=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "computedUnlockedColumnWidthTotal", oldValue, _computedUnlockedColumnWidthTotal));
		}
	}

	//---------------------------------------------
	// unlockedColumnCount
	//---------------------------------------------
	private var _unlockedColumnCount:int;

	/** unlockedColumnCount */
	[Bindable(event="propertyChange")]
	public function get unlockedColumnCount():int {
		return _unlockedColumnCount;
	}

	private function set_unlockedColumnCount(value:int):void {
		var oldValue:int=_unlockedColumnCount;
		_unlockedColumnCount=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "unlockedColumnCount", oldValue, _unlockedColumnCount));
		}
	}

	//---------------------------------------------
	// scrollEnabled
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
		var oldValue:Vector.<IHeaderLeafColumn>=_leafColumns;
		_leafColumns=value;

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
		var oldValue:int=_numRows;
		_numRows=value;

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
		var oldValue:int=_numColumns;
		_numColumns=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "numColumns", oldValue, _numColumns));
		}
	}

	//---------------------------------------------
	// columnSeparatorSize
	//---------------------------------------------
	private var _columnSeparatorSize:int;

	/** columnSeparatorSize */
	[Bindable]
	public function get columnSeparatorSize():int {
		return _columnSeparatorSize;
	}

	public function set columnSeparatorSize(value:int):void {
		var oldValue:int=_columnSeparatorSize;
		_columnSeparatorSize=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columnSeparatorSize", oldValue, _columnSeparatorSize));
		}

		invalidateColumnLayout();
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

		var oldValue:Vector.<IHeaderColumn>=_columns;
		_columns=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columns", oldValue, _columns));
		}

		invalidateColumn();
	}

	//---------------------------------------------
	// lockedColumnCount
	//---------------------------------------------
	private var _lockedColumnCount:int;

	/** lockedColumnCount */
	[Bindable]
	public function get lockedColumnCount():int {
		return _lockedColumnCount;
	}

	public function set lockedColumnCount(value:int):void {
		var oldValue:int=_lockedColumnCount;
		_lockedColumnCount=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lockedColumnCount", oldValue, _lockedColumnCount));
		}

		invalidateColumnLayout();
	}

	//---------------------------------------------
	// horizontalScrollPosition
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
	private var _rowSeparatorSize:int;

	/** rowSeparatorSize */
	public function get rowSeparatorSize():int {
		return _rowSeparatorSize;
	}

	public function set rowSeparatorSize(value:int):void {
		_rowSeparatorSize=value;

		invalidateColumnLayout();
	}

	//---------------------------------------------
	// rowHeight
	//---------------------------------------------
	private var _rowHeight:int;

	/** rowHeight */
	public function get rowHeight():int {
		return _rowHeight;
	}

	public function set rowHeight(value:int):void {
		_rowHeight=value;

		invalidateColumnLayout();
	}

	//==========================================================================================
	// invalidate
	//==========================================================================================
	private var columnChanged:Boolean;
	private var columnLayoutChanged:Boolean;
	private var columnContentChanged:Boolean;
	private var scrollChanged:Boolean;

	public function invalidateColumn():void {
		columnChanged=true;
		invalidateProperties();
	}

	public function invalidateColumnLayout():void {
		columnLayoutChanged=true;
		invalidateProperties();
	}

	public function invalidateColumnContent():void {
		columnContentChanged=true;
		invalidateProperties();
	}

	public function invalidateScroll():void {
	}

	//	//==========================================================================================
	//	// event handlers
	//	//==========================================================================================
	//	private function columnChangedHandler():void {
	//		invalidateDisplayList();
	//	}
	//
	//	private function columnContentChangedHandler():void {
	//		invalidateDisplayList();
	//	}

	//==========================================================================================
	// life cycle
	//==========================================================================================
	override protected function measure():void {
		super.measure();

		var oldMeasuredWidth:Number=measuredWidth;
		var oldMeasuredHeight:Number=measuredHeight;
		var newMeasuredHeight:Number=(rowHeight * numRows) + (rowSeparatorSize * (numRows - 1));

		if (oldMeasuredHeight != newMeasuredHeight) {
			measuredHeight=newMeasuredHeight;
			invalidateDisplayList();
		}
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		// clear
		graphics.clear();
		removeAllElements();

		if (!_columns || (unscaledWidth === 0 && unscaledHeight)) {
			return;
		}

		var computedWidthList:Vector.<Number>=computeColumnWidth(unscaledWidth - (columnSeparatorSize * (numColumns - 1)));
		hostWeaver.setProperty(HeaderEvents.COMPUTED_WIDTH_LIST, computedWidthList);

		trace("GridHeader.updateDisplayList(", unscaledWidth, unscaledHeight, ")");
		trace("GridHeader.updateDisplayList(", computedWidthList, ")");

		//		var g:Graphics=graphics;
		//		g.beginFill(0, 0.1);
		//		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		//		g.endFill();

		var f:int=-1;
		var fmax:int=_columns.length;
		var column:IHeaderColumn;
		var columnIndex:int=0;

		while (++f < fmax) {
			column=_columns[f];
			//			trace("GridHeader.updateDisplayList(", column.headerText, columnIndex, ")");
			columnIndex=column.draw(this, 0, columnIndex);
		}

		// dispatchEvent(new HeaderEvents(HeaderEvents.COMPUTED_WIDTH_LIST));
	}

	//==========================================================================================
	// column width control
	//==========================================================================================
	private function computeColumnsAndRows():void {
		// count columns and rows
		var rowsAndColumns:Vector.<int>=HeaderUtils.count(_columns);
		hostWeaver.setProperty(HeaderEvents.NUM_ROWS, rowsAndColumns[0]);
		hostWeaver.setProperty(HeaderEvents.NUM_COLUMNS, rowsAndColumns[1]);

		injectHeaderToColumns(_columns);
	}

	private function injectHeaderToColumns(list:Vector.<IHeaderColumn>):void {
		var column:IHeaderColumn;
		var f:int=-1;
		var fmax:int=list.length;

		while (++f < fmax) {
			column=list[f];
			column.weaver=hostWeaver;

			// set header
			// column.header=this;

			if (column is IHeaderBrancheColumn) {
				injectHeaderToColumns(IHeaderBrancheColumn(column).columns);
			}
		}
	}

	private function computeColumnWidth(w:Number):Vector.<Number> {
		var f:int;
		var fmax:int;
		var widthList:Vector.<Number>=new Vector.<Number>;
		var computed:Vector.<Number>;

		readColumnWidth(_columns, widthList);

		//		if (_columnMode === "ratio") {
		var total:Number=0;
		var ratios:Vector.<Number>;

		f=-1;
		fmax=widthList.length;
		while (++f < fmax) {
			total+=widthList[f];
		}

		if (total !== 1) {
			ratios=new Vector.<Number>(widthList.length, true);

			f=-1;
			fmax=widthList.length;
			while (++f < fmax) {
				ratios[f]=widthList[f] / total;
			}
		} else {
			ratios=widthList;
		}

		computed=new Vector.<Number>(widthList.length, true);

		f=-1;
		fmax=ratios.length;
		while (++f < fmax) {
			computed[f]=ratios[f] * w;
		}
		//		} else {
		//			computed=widthList;
		//		}

		// 
		var floored:Vector.<Number>=new Vector.<Number>(computed.length, true);
		var fw:int;
		var nx:int=0;

		f=-1;
		fmax=computed.length;
		while (++f < fmax) {
			if (f === fmax - 1) {
				floored[f]=unscaledWidth - nx;
			} else {
				fw=computed[f];
				floored[f]=fw;
				nx+=fw + columnSeparatorSize;
			}
		}

		return floored;
	}

	private function readColumnWidth(list:Vector.<IHeaderColumn>, widthList:Vector.<Number>):void {
		var column:IHeaderColumn;
		var f:int=-1;
		var fmax:int=list.length;
		var width:Number;

		while (++f < fmax) {
			column=list[f];

			if (column is IHeaderLeafColumn) {
				widthList.push(IHeaderLeafColumn(column).columnWidth);
			}

			if (column is IHeaderBrancheColumn) {
				readColumnWidth(IHeaderBrancheColumn(column).columns, widthList);
			}
		}
	}



}
}
