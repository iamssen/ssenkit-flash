package ssen.components.grid.headers {

import flash.display.GraphicsPath;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import mx.core.IFactory;
import mx.events.PropertyChangeEvent;

import spark.components.Group;

import ssen.common.StringUtils;
import ssen.components.grid.GridBlock;
import ssen.components.grid.GridUtils;
import ssen.drawing.PathMaker;

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
		_numRows = rowsAndColumns[0] + 1;
		_numColumns = rowsAndColumns[1] + 1;

		if (_header) _header.invalidateColumns();
	}

	//---------------------------------------------
	// renderer
	//---------------------------------------------
	private var _renderer:IFactory;

	/** renderer */
	public function get renderer():IFactory {
		return _renderer || HeaderColumnRenderer.factory;
	}

	public function set renderer(value:IFactory):void {
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
	// columnWidth
	//---------------------------------------------
	private var _columnWidth:Number = 100;

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
	// render
	//==========================================================================================
	private static var bound:Rectangle = new Rectangle;

	public function render():void {
		var header:IHeaderElement = this.header;

		var f:int, fmax:int;

		var containerId:int;
		var container:Group;

		var surplusRows:int;
		var dig:Point

		var path:GraphicsPath;
		var contentSpaces:Dictionary;
		var renderer:IHeaderColumnRenderer;

		if (header.columnLayoutMode == HeaderLayoutMode.RATIO) {
			//---------------------------------------------
			// calculate
			//---------------------------------------------
			containerId = GridUtils.getContainerId(header, columnIndex);
			container = header.getBlock(containerId);

			surplusRows = (header.numRows - rowIndex);
			bound.x = GridUtils.columnDrawX(header.computedColumnPositionList, columnIndex, containerId, header.columnLayoutMode, header.frontLockedColumnCount, header.backLockedColumnCount);
			bound.y = (rowIndex > 0) ? (header.rowHeight + header.rowSeparatorSize) * rowIndex : 0;
			bound.width = computedColumnWidth;
			bound.height = (header.rowHeight * surplusRows) + (header.rowSeparatorSize * (surplusRows - 1));

			dig = new Point;
			dig.x = header.computedColumnWidthList[columnIndex];
			dig.y = header.rowHeight;

			//---------------------------------------------
			// export
			//---------------------------------------------
			path = PathMaker.diggedRect(0, 0, bound.width, bound.height, dig.x, dig.y, false, false);
			contentSpaces = new Dictionary;
			contentSpaces["default"] = new Rectangle(0, 0, bound.width, dig.y);
			contentSpaces["subTopicSide"] = new Rectangle(0, 0, dig.x, bound.height);
			contentSpaces["subTopicCut"] = new Rectangle(dig.x, 0, bound.width - dig.x, dig.y);

			renderer = this.renderer.newInstance();
			renderer.draw(this, container, bound.clone(), path, contentSpaces, true);
			renderer.x = bound.x;
			renderer.y = bound.y;
			container.addElement(renderer);
		} else {
			var commands:Vector.<HeaderBrancheDrawCommand> = GridUtils.countBrancheColumns(header.numColumns, header.frontLockedColumnCount, header.backLockedColumnCount, columnIndex, numColumns);
			var command:HeaderBrancheDrawCommand;

			f = -1;
			fmax = commands.length;

			while (++f < fmax) {
				command = commands[f];
				container = header.getBlock(command.block);

				if (command.begin) {
					//---------------------------------------------
					// calculate
					//---------------------------------------------
					surplusRows = (header.numRows - rowIndex);
					bound.x = GridUtils.columnDrawX(header.computedColumnPositionList, command.start, command.block, header.columnLayoutMode, header.frontLockedColumnCount, header.backLockedColumnCount);
					bound.y = (rowIndex > 0) ? (header.rowHeight + header.rowSeparatorSize) * rowIndex : 0;
					bound.width = GridUtils.sumValues(header.computedColumnWidthList, command.start, command.end, header.columnSeparatorSize);
					bound.height = (header.rowHeight * surplusRows) + (header.rowSeparatorSize * (surplusRows - 1));

					dig = new Point;
					dig.x = header.computedColumnWidthList[columnIndex];
					dig.y = header.rowHeight;

					//---------------------------------------------
					// export
					//---------------------------------------------
					path = PathMaker.diggedRect(0, 0, bound.width, bound.height, dig.x, dig.y, false, false);
					contentSpaces = new Dictionary;
					contentSpaces["default"] = new Rectangle(0, 0, bound.width, dig.y);
					contentSpaces["subTopicSide"] = new Rectangle(0, 0, dig.x, bound.height);
					contentSpaces["subTopicCut"] = new Rectangle(dig.x, 0, bound.width - dig.x, dig.y);

					renderer = this.renderer.newInstance();
					renderer.draw(this, container, bound.clone(), path, contentSpaces, command.block == GridBlock.UNLOCK);
					renderer.x = bound.x;
					renderer.y = bound.y;
					container.addElement(renderer);
				} else {
					//---------------------------------------------
					// calculate
					//---------------------------------------------
					bound.x = GridUtils.columnDrawX(header.computedColumnPositionList, command.start, command.block, header.columnLayoutMode, header.frontLockedColumnCount, header.backLockedColumnCount);
					bound.y = (rowIndex > 0) ? (header.rowHeight + header.rowSeparatorSize) * rowIndex : 0;
					bound.width = GridUtils.sumValues(header.computedColumnWidthList, command.start, command.end, header.columnSeparatorSize);
					bound.height = header.rowHeight;

					//---------------------------------------------
					// export
					//---------------------------------------------
					path = PathMaker.rect(0, 0, bound.width, bound.height);
					contentSpaces = new Dictionary;
					contentSpaces["default"] = new Rectangle(0, 0, bound.width, bound.height);

					renderer = this.renderer.newInstance();
					renderer.draw(this, container, bound.clone(), path, contentSpaces, command.block == GridBlock.UNLOCK);
					renderer.x = bound.x;
					renderer.y = bound.y;
					container.addElement(renderer);
				}
			}
		}

//		trace(StringUtils.multiply("+", rowIndex + 1), rowIndex, columnIndex, "HeaderSubTopicColumn.render()", toString());

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
