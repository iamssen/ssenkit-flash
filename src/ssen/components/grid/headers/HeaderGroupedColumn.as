package ssen.components.grid.headers {

import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;

import mx.events.PropertyChangeEvent;

import spark.components.Group;

import ssen.common.StringUtils;
import ssen.components.grid.GridUtils;

[DefaultProperty("columns")]

public class HeaderGroupedColumn extends EventDispatcher implements IHeaderBrancheColumn {
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
	private var _header:IHeaderElement;

	/** header */
	public function get header():IHeaderElement {
		return _header;
	}

	public function set header(value:IHeaderElement):void {
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
		if (_header) _header.invalidateColumnContent();
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

		var rowsAndColumns:Vector.<int> = GridUtils.countColumnsAndRows(value);
		_numRows = rowsAndColumns[0];
		_numColumns = rowsAndColumns[1];

		if (_header) _header.invalidateColumns();
	}

	//---------------------------------------------
	// renderer
	//---------------------------------------------
	private var _renderer:IHeaderColumnRenderer;

	/** renderer */
	public function get renderer():IHeaderColumnRenderer {
		return _renderer;
	}

	public function set renderer(value:IHeaderColumnRenderer):void {
		_renderer = value;
		if (_header) _header.invalidateColumnContent();
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
	// render
	//==========================================================================================
	private static var bound:Rectangle = new Rectangle;

	public function render():void {
		var f:int, fmax:int;

		var container:Group;
		var g:Graphics;

		if (header.columnLayoutMode == HeaderLayoutMode.RATIO) {
			var containerId:int = GridUtils.getContainerId(header, columnIndex);
			container = header.getBlock(containerId);
			g = container.graphics;

			bound.x = GridUtils.columnDrawX(header.computedColumnPositionList, columnIndex, containerId, header.columnLayoutMode, header.frontLockedColumnCount, header.backLockedColumnCount);
			bound.y = (rowIndex > 0) ? (header.rowHeight + header.rowSeparatorSize) * rowIndex : 0;
			bound.width = computedColumnWidth;
			bound.height = header.rowHeight;

			g.beginFill(0, 0.2);
			g.drawRect(bound.x, bound.y, bound.width, bound.height);
			g.endFill();
		} else {
			var commands:Vector.<HeaderBrancheDrawCommand> = GridUtils.countBrancheColumns(header.numColumns, header.frontLockedColumnCount, header.backLockedColumnCount, columnIndex, numColumns);
			var command:HeaderBrancheDrawCommand;

			f = -1;
			fmax = commands.length;

			while (++f < fmax) {
				command = commands[f];
				container = header.getBlock(command.block);
				g = container.graphics;

				bound.x = GridUtils.columnDrawX(header.computedColumnPositionList, command.start, command.block, header.columnLayoutMode, header.frontLockedColumnCount, header.backLockedColumnCount);
				bound.y = (rowIndex > 0) ? (header.rowHeight + header.rowSeparatorSize) * rowIndex : 0;
				bound.width = GridUtils.sumValues(header.computedColumnWidthList, command.start, command.end, header.columnSeparatorSize);
				bound.height = header.rowHeight;

				g.beginFill(0, 0.2);
				g.drawRect(bound.x, bound.y, bound.width, bound.height);
				g.endFill();
			}
		}

		trace(StringUtils.multiply("+", rowIndex + 1), rowIndex, columnIndex, "HeaderGroupedColumn.render()", toString());

		f = -1;
		fmax = _columns.length;
		while (++f < fmax) {
			_columns[f].render();
		}
	}

	override public function toString():String {
		return StringUtils.formatToString("[GridHeaderColumnGroup headerText={0} columnIndex={1} rowIndex={2} computedColumnWidth={3}]", headerText, columnIndex, rowIndex, computedColumnWidth);
	}
}
}
