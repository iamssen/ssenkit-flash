package ssen.flexkit.components.grid {
import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.geom.Point;

import ssen.common.StringUtils;

[DefaultProperty("columns")]

[Event(name="changedColumn", type="ssen.flexkit.components.grid.GridHeaderEvent")]

public class GridHeaderColumnGroup extends EventDispatcher implements IGridHeaderColumnGroup {
	//==========================================================================================
	// properties
	//==========================================================================================
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
	// header
	//---------------------------------------------
	private var _header:GridHeader;

	/** header */
	public function get header():GridHeader {
		return _header;
	}

	public function set header(value:GridHeader):void {
		_header=value;
	}

	//---------------------------------------------
	// headerText
	//---------------------------------------------
	private var _headerText:String;

	/** headerText */
	public function get headerText():String {
		return _headerText;
	}

	public function set headerText(value:String):void {
		_headerText=value;
		dispatchEvent(new GridHeaderEvent(GridHeaderEvent.CHANGED_COLUMN));
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
		_columns=value;

		var rowsAndColumns:Vector.<int>=GridHeaderUtils.count(value);
		_numRows=rowsAndColumns[0];
		_numColumns=rowsAndColumns[1];

		dispatchEvent(new GridHeaderEvent(GridHeaderEvent.CHANGED_COLUMN));
	}

	//==========================================================================================
	// draw
	//==========================================================================================
	public function draw(container:GridHeader, rowIndex:int, columnIndex:int):int {
		// draw children
		var f:int=-1;
		var fmax:int=_columns.length;
		var column:IGridHeaderColumn;
		var nextColumnIndex:int=columnIndex;
		var endColumnIndex:int=columnIndex;

		while (++f < fmax) {
			column=_columns[f];
			nextColumnIndex=column.draw(container, rowIndex + 1, nextColumnIndex);
		}

		//		trace("GridHeaderColumnGroup.draw -(", headerText, ")");
		//		trace("GridHeaderColumnGroup.draw s(", rowIndex, columnIndex, ")");
		//		trace("GridHeaderColumnGroup.draw e(", rowIndex, nextColumnIndex, ")");

		// draw
		var tl:Point=GridHeaderUtils.getPoint(container, rowIndex, columnIndex);
		var tr:Point=GridHeaderUtils.getPoint(container, rowIndex, nextColumnIndex);
		tr.x-=container.columnSeparatorSize;
		//		trace("GridHeaderColumnGroup.draw x(", tl.x, tr.x, ")");
		var g:Graphics=container.graphics;
		g.beginFill(0, 0.2);
		g.drawRect(tl.x, tl.y, tr.x - tl.x, container.rowHeight);
		g.endFill();

		return nextColumnIndex;
	}

	override public function toString():String {
		return StringUtils.formatToString("[GridHeaderColumnGroup headerText={0}]", _headerText);
	}
}
}
