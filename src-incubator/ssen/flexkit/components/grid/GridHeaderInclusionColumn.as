package ssen.flexkit.components.grid {
import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.geom.Point;

import ssen.common.StringUtils;

[DefaultProperty("columns")]

[Event(name="changedColumn", type="ssen.flexkit.components.grid.GridHeaderEvent")]

public class GridHeaderInclusionColumn extends EventDispatcher implements IGridHeaderColumnLeaf, IGridHeaderColumnGroup {
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
	// columnWidth
	//---------------------------------------------
	private var _columnWidth:Number;

	/** columnWidth */
	public function get columnWidth():Number {
		return _columnWidth;
	}

	public function set columnWidth(value:Number):void {
		_columnWidth=value;
		dispatchEvent(new GridHeaderEvent(GridHeaderEvent.CHANGED_COLUMN));
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
		var nextColumnIndex:int=columnIndex + 1;

		while (++f < fmax) {
			column=_columns[f];
			nextColumnIndex=column.draw(container, rowIndex + 1, nextColumnIndex);
		}

		// draw
		var tl:Point=GridHeaderUtils.getPoint(container, rowIndex, columnIndex);
		var tr:Point=GridHeaderUtils.getPoint(container, rowIndex, nextColumnIndex);
		tr.x-=container.columnSeparatorSize;
		var c:Point=GridHeaderUtils.getPoint(container, rowIndex + 1, columnIndex + 1);
		c.x-=container.columnSeparatorSize;
		c.y-=container.rowSeparatorSize;
		var br:Point=new Point(tr.x, container.measuredHeight);

		var g:Graphics=container.graphics;
		g.beginFill(0, 0.2);
		g.moveTo(tl.x, tl.y);
		g.lineTo(tr.x, tl.y);
		g.lineTo(tr.x, c.y);
		g.lineTo(c.x, c.y);
		g.lineTo(c.x, br.y);
		g.lineTo(tl.x, br.y);
		g.lineTo(tl.x, tl.y);

		//		g.drawRect(tl.x, tl.y, br.x - tl.x, br.y - tl.y);
		//		g.drawRect(c.x, c.y, br.x - c.x, br.y - c.y);
		//		g.moveTo(tl.x, tl.y);
		//		g.drawRect(tl.x, tl.y, tr.x - container.columnSeparatorSize, container.rowHeight);
		g.endFill();

		return nextColumnIndex;
	}

	override public function toString():String {
		return StringUtils.formatToString("[GridHeaderInclusionColumn headerText={0} columnWidth={1}]", _headerText, _columnWidth);
	}
}
}
