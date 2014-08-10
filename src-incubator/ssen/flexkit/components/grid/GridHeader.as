package ssen.flexkit.components.grid {
import flash.display.Graphics;

import spark.components.SkinnableContainer;

import ssen.ssen_internal;

use namespace ssen_internal;

[DefaultProperty("columns")]

[Event(name="computedWidthList", type="ssen.flexkit.components.grid.GridHeaderEvent")]

public class GridHeader extends SkinnableContainer {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// flags
	//----------------------------------------------------------------

	//----------------------------------------------------------------
	// public
	//----------------------------------------------------------------
	//---------------------------------------------
	// computedWidthList
	//---------------------------------------------
	private var _computedWidthList:Vector.<Number>;

	/** computedWidthList */
	public function get computedWidthList():Vector.<Number> {
		return _computedWidthList;
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

	//---------------------------------------------
	// rowSeparatorSize
	//---------------------------------------------
	private var _rowSeparatorSize:int=1;

	/** rowSeparatorSize */
	public function get rowSeparatorSize():int {
		return _rowSeparatorSize;
	}

	public function set rowSeparatorSize(value:int):void {
		_rowSeparatorSize=value;
		invalidateSize();
	}

	//---------------------------------------------
	// columnSeparatorSize
	//---------------------------------------------
	private var _columnSeparatorSize:int=1;

	/** columnSeparatorSize */
	public function get columnSeparatorSize():int {
		return _columnSeparatorSize;
	}

	public function set columnSeparatorSize(value:int):void {
		_columnSeparatorSize=value;
		invalidateSize();
	}

	//---------------------------------------------
	// rowHeight
	//---------------------------------------------
	private var _rowHeight:int=24;

	/** rowHeight */
	public function get rowHeight():int {
		return _rowHeight;
	}

	public function set rowHeight(value:int):void {
		_rowHeight=value;
		invalidateSize();
	}

	//---------------------------------------------
	// lockedColumnCount
	//---------------------------------------------
	private var _lockedColumnCount:int=0;

	/** lockedColumnCount */
	public function get lockedColumnCount():int {
		return _lockedColumnCount;
	}

	public function set lockedColumnCount(value:int):void {
		_lockedColumnCount=value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// columnMode
	//---------------------------------------------
	private var _columnMode:String="ratio";

	/** columnMode */
	[Inspectable(type="Array", enumeration="ratio,fixed", defaultValue="ratio")]
	public function get columnMode():String {
		return _columnMode;
	}

	public function set columnMode(value:String):void {
		_columnMode=value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// columns
	//---------------------------------------------
	private var _columns:Vector.<IGridHeaderColumn>;

	/** columns */
	public function get columns():Vector.<IGridHeaderColumn> {
		return _columns;
	}

	public function set columns(value:Vector.<IGridHeaderColumn>):void {
		if (_columns === value) {
			return;
		}

		_columns=value;
		computeColumnsAndRows();
		invalidateDisplayList();
	}

	//==========================================================================================
	// life cycle
	//==========================================================================================
	override protected function measure():void {
		super.measure();

		var oldMeasuredWidth:Number=measuredWidth;
		var oldMeasuredHeight:Number=measuredHeight;
		var newMeasuredHeight:Number=(_rowHeight * _numRows) + (_rowSeparatorSize * (_numRows - 1));

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

		_computedWidthList=computeColumnWidth(unscaledWidth - (_columnSeparatorSize * (_numColumns - 1)));

		trace("GridHeader.updateDisplayList(", unscaledWidth, unscaledHeight, ")");
		trace("GridHeader.updateDisplayList(", _computedWidthList, ")");

		//		var g:Graphics=graphics;
		//		g.beginFill(0, 0.1);
		//		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		//		g.endFill();

		var f:int=-1;
		var fmax:int=_columns.length;
		var column:IGridHeaderColumn;
		var columnIndex:int=0;

		while (++f < fmax) {
			column=_columns[f];
			//			trace("GridHeader.updateDisplayList(", column.headerText, columnIndex, ")");
			columnIndex=column.draw(this, 0, columnIndex);
		}

		dispatchEvent(new GridHeaderEvent(GridHeaderEvent.COMPUTED_WIDTH_LIST));
	}

	//==========================================================================================
	// column width control
	//==========================================================================================
	private function computeColumnsAndRows():void {
		// count columns and rows
		var rowsAndColumns:Vector.<int>=GridHeaderUtils.count(_columns);
		_numRows=rowsAndColumns[0];
		_numColumns=rowsAndColumns[1];

		injectHeaderToColumns(_columns);
	}

	private function injectHeaderToColumns(list:Vector.<IGridHeaderColumn>):void {
		var column:IGridHeaderColumn;
		var f:int=-1;
		var fmax:int=list.length;

		while (++f < fmax) {
			column=list[f];

			// set header
			column.header=this;

			if (column is IGridHeaderColumnGroup) {
				injectHeaderToColumns(IGridHeaderColumnGroup(column).columns);
			}
		}
	}

	private function computeColumnWidth(w:Number):Vector.<Number> {
		var f:int;
		var fmax:int;
		var widthList:Vector.<Number>=new Vector.<Number>;
		var computed:Vector.<Number>;

		readColumnWidth(_columns, widthList);

		if (_columnMode === "ratio") {
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
		} else {
			computed=widthList;
		}

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
				nx+=fw + _columnSeparatorSize;
			}
		}

		return floored;
	}

	private function readColumnWidth(list:Vector.<IGridHeaderColumn>, widthList:Vector.<Number>):void {
		var column:IGridHeaderColumn;
		var f:int=-1;
		var fmax:int=list.length;
		var width:Number;

		while (++f < fmax) {
			column=list[f];

			if (column is IGridHeaderColumnLeaf) {
				widthList.push(IGridHeaderColumnLeaf(column).columnWidth);
			}

			if (column is IGridHeaderColumnGroup) {
				readColumnWidth(IGridHeaderColumnGroup(column).columns, widthList);
			}
		}
	}
}
}
