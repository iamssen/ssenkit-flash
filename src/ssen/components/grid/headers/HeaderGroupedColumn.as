package ssen.components.grid.headers {
import flash.display.Graphics;
import flash.geom.Point;

import ssen.common.StringUtils;
import ssen.weave.IWeaver;

[DefaultProperty("columns")]

public class HeaderGroupedColumn implements IHeaderBrancheColumn {
	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// weaver
	//---------------------------------------------
	private var _weaver:IWeaver;

	/** weaver */
	public function get weaver():IWeaver {
		return _weaver;
	}

	public function set weaver(value:IWeaver):void {
		_weaver=value;
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
	// header
	//---------------------------------------------
	private var _header:Header;

	/** header */
	public function get header():Header {
		return _header;
	}

	public function set header(value:Header):void {
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

		if (_weaver) {
			_weaver.fire(HeaderEvents.COLUMN_CONTENT_CHANGED);
		}
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
		_columns=value;

		var rowsAndColumns:Vector.<int>=HeaderUtils.count(value);
		_numRows=rowsAndColumns[0];
		_numColumns=rowsAndColumns[1];

		if (_weaver) {
			_weaver.fire(HeaderEvents.COLUMN_CHANGED);
		}
	}

	//==========================================================================================
	// draw
	//==========================================================================================
	public function draw(container:IHeaderContainer, rowIndex:int, columnIndex:int):int {
		// draw children
		var f:int=-1;
		var fmax:int=_columns.length;
		var column:IHeaderColumn;
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
		var tl:Point=HeaderUtils.getPoint(container, rowIndex, columnIndex);
		var tr:Point=HeaderUtils.getPoint(container, rowIndex, nextColumnIndex);
		tr.x-=container.columnSeparatorSize;
		//		trace("GridHeaderColumnGroup.draw x(", tl.x, tr.x, ")");
		var g:Graphics=container.graphics;
		g.beginFill(0, 0.2);
		g.drawRect(tl.x, tl.y, tr.x - tl.x, container.rowHeight);
		g.endFill();

		return nextColumnIndex;
	}

	public function toString():String {
		return StringUtils.formatToString("[GridHeaderColumnGroup headerText={0}]", _headerText);
	}
}
}
