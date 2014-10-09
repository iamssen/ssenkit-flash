package ssen.components.grid.headers {
import flash.display.Graphics;
import flash.geom.Point;

import ssen.common.StringUtils;
import ssen.weave.IWeaver;

[DefaultProperty("columns")]

public class HeaderSubTopicColumn implements IHeaderLeafColumn, IHeaderBrancheColumn {
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
	// columnWidth
	//---------------------------------------------
	private var _columnWidth:Number;

	/** columnWidth */
	public function get columnWidth():Number {
		return _columnWidth;
	}

	public function set columnWidth(value:Number):void {
		_columnWidth=value;

		if (_weaver) {
			_weaver.fire(HeaderEvents.COLUMN_CHANGED);
		}
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
		var nextColumnIndex:int=columnIndex + 1;

		while (++f < fmax) {
			column=_columns[f];
			nextColumnIndex=column.draw(container, rowIndex + 1, nextColumnIndex);
		}

		// draw
		var tl:Point=HeaderUtils.getPoint(container, rowIndex, columnIndex);
		var tr:Point=HeaderUtils.getPoint(container, rowIndex, nextColumnIndex);
		tr.x-=container.columnSeparatorSize;
		var c:Point=HeaderUtils.getPoint(container, rowIndex + 1, columnIndex + 1);
		c.x-=container.columnSeparatorSize;
		c.y-=container.rowSeparatorSize;
		var br:Point=new Point(tr.x, container.height);

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

	public function toString():String {
		return StringUtils.formatToString("[GridHeaderInclusionColumn headerText={0} columnWidth={1}]", _headerText, _columnWidth);
	}
}
}
