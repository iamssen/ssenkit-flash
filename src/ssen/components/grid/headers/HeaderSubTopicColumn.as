package ssen.components.grid.headers {

import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.events.PropertyChangeEvent;

import ssen.common.StringUtils;

[DefaultProperty("columns")]

public class HeaderSubTopicColumn extends EventDispatcher implements IHeaderLeafColumn, IHeaderBrancheColumn {
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
	private var _header:IHeaderContainer;

	/** header */
	public function get header():IHeaderContainer {
		return _header;
	}

	public function set header(value:IHeaderContainer):void {
		_header = value;
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
		_headerText = value;
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

		var rowsAndColumns:Vector.<int> = HeaderUtils.count(value);
		_numRows = rowsAndColumns[0] + 1;
		_numColumns = rowsAndColumns[1] + 1;
	}


	public function get renderer():IHeaderColumnRenderer {
		return null;
	}

	public function set renderer(value:IHeaderColumnRenderer):void {
	}


	//---------------------------------------------
	// rowIndex
	//---------------------------------------------
	private var _rowIndex:int;

	/** rowIndex */
	[Bindable]
	public function get rowIndex():int {
		return _rowIndex;
	}

	public function set rowIndex(value:int):void {
		var oldValue:int = _rowIndex;
		_rowIndex = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "rowIndex", oldValue, _rowIndex));
		}
	}

	//---------------------------------------------
	// columnIndex
	//---------------------------------------------
	private var _columnIndex:int;

	/** columnIndex */
	[Bindable]
	public function get columnIndex():int {
		return _columnIndex;
	}

	public function set columnIndex(value:int):void {
		var oldValue:int = _columnIndex;
		_columnIndex = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "columnIndex", oldValue, _columnIndex));
		}
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
		_columnWidth = value;
	}

	//---------------------------------------------
	// computedColumnWidth
	//---------------------------------------------
	/** computedColumnWidth */
	[Bindable(event="propertyChange")]
	public function get computedColumnWidth():Number {
		var widthList:Vector.<Number> = header.computedColumnWidthList;
		var separatorSize:int = (numColumns - 1) * header.columnSeparatorSize;
		var widthTotal:Number = widthList[columnIndex];

		var f:int = columnIndex;
		var fmax:int = columnIndex + numColumns;
		while (++f < fmax) {
			widthTotal += widthList[f];
		}

		return widthTotal + separatorSize;
	}

	//==========================================================================================
	// draw
	//==========================================================================================
	public function render():void {
		trace(HeaderUtils.getSpace(rowIndex), rowIndex, columnIndex, "HeaderSubTopicColumn.render()", toString());

		var bound:Rectangle = new Rectangle;
		var surplusRows:int = (header.numRows - rowIndex);
		bound.x = header.computedColumnPositionList[columnIndex];
		bound.y = (rowIndex > 0) ? (header.rowHeight + header.rowSeparatorSize) * rowIndex : 0;
		bound.width = computedColumnWidth;
		bound.height = (header.rowHeight * surplusRows) + (header.rowSeparatorSize * (surplusRows - 1));

		var point:Point = new Point;
		point.x = bound.x + header.computedColumnWidthList[columnIndex];
		point.y = bound.y + header.rowHeight;

		var g:Graphics = header.graphics;
		g.beginFill(0, 0.4);
		g.moveTo(bound.left, bound.top);
		g.lineTo(bound.right, bound.top);
		g.lineTo(bound.right, point.y);
		g.lineTo(point.x, point.y);
		g.lineTo(point.x, bound.bottom);
		g.lineTo(bound.left, bound.bottom);
		g.lineTo(bound.left, bound.top);
		// g.drawRect(bound.x, bound.y, bound.width, bound.height);
		g.endFill();

		var f:int = -1;
		var fmax:int = _columns.length;
		while (++f < fmax) {
			_columns[f].render();
		}
	}

	//	public function draw(container:IHeaderContainer, rowIndex:int, columnIndex:int):int {
	//		// draw children
	//		var f:int = -1;
	//		var fmax:int = _columns.length;
	//		var column:IHeaderColumn;
	//		var nextColumnIndex:int = columnIndex + 1;
	//
	//		while (++f < fmax) {
	//			column = _columns[f];
	//			column.render();
	//		}
	//
	//		//		// draw
	//		//		var tl:Point = HeaderUtils.getPoint(container, rowIndex, columnIndex);
	//		//		var tr:Point = HeaderUtils.getPoint(container, rowIndex, nextColumnIndex);
	//		//		tr.x -= container.columnSeparatorSize;
	//		//		var c:Point = HeaderUtils.getPoint(container, rowIndex + 1, columnIndex + 1);
	//		//		c.x -= container.columnSeparatorSize;
	//		//		c.y -= container.rowSeparatorSize;
	//		//		var br:Point = new Point(tr.x, container.height);
	//		//
	//		//		var g:Graphics = container.graphics;
	//		//		g.beginFill(0, 0.2);
	//		//		g.moveTo(tl.x, tl.y);
	//		//		g.lineTo(tr.x, tl.y);
	//		//		g.lineTo(tr.x, c.y);
	//		//		g.lineTo(c.x, c.y);
	//		//		g.lineTo(c.x, br.y);
	//		//		g.lineTo(tl.x, br.y);
	//		//		g.lineTo(tl.x, tl.y);
	//
	//		//		g.drawRect(tl.x, tl.y, br.x - tl.x, br.y - tl.y);
	//		//		g.drawRect(c.x, c.y, br.x - c.x, br.y - c.y);
	//		//		g.moveTo(tl.x, tl.y);
	//		//		g.drawRect(tl.x, tl.y, tr.x - container.columnSeparatorSize, container.rowHeight);
	//		//		g.endFill();
	//
	//		return nextColumnIndex;
	//	}

	override public function toString():String {
		return StringUtils.formatToString("[GridHeaderColumnGroup headerText={0} columnIndex={1} rowIndex={2} computedColumnWidth={3}]", headerText, columnIndex, rowIndex, computedColumnWidth);
	}
}
}
