package ssen.components.grid.contents.tables {
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import mx.core.ClassFactory;
import mx.core.IFactory;

import ssen.components.grid.base.TextItemRenderer;
import ssen.drawing.RGB;
import ssen.text.LabelComponentUtils;

public class TableCellRenderer extends TextItemRenderer implements ITableCellRenderer {

	internal static const defaultRenderer:IFactory = new ClassFactory(TableCellRenderer);

	//==========================================================================================
	// Style
	//==========================================================================================
	//---------------------------------------------
	// contentSpace
	//---------------------------------------------
	private var _contentSpace:String = "fit";

	/** contentSpace */
	public function get contentSpace():String {
		return _contentSpace;
	}

	[Inspectable(type="Array", enumeration="wide,fit", defaultValue="fit")]
	public function set contentSpace(value:String):void {
		_contentSpace = value;
		invalidateDisplayList();
	}

	//==========================================================================================
	// ITableCellRenderer
	//==========================================================================================
	//---------------------------------------------
	// table
	//---------------------------------------------
	private var _table:Table;

	/** table */
	public function get table():Table {
		return _table;
	}

	public function set table(value:Table):void {
		_table = value;
	}

	//---------------------------------------------
	// row
	//---------------------------------------------
	private var _row:Row;

	/** row */
	public function get row():Row {
		return _row;
	}

	public function set row(value:Row):void {
		_row = value;
	}

	//---------------------------------------------
	// column
	//---------------------------------------------
	private var _column:TableColumn;

	/** column */
	public function get column():TableColumn {
		return _column;
	}

	public function set column(value:TableColumn):void {
		_column = value;
	}

	//---------------------------------------------
	// columnIndex
	//---------------------------------------------
	private var _columnIndex:int;

	/** columnIndex */
	public function get columnIndex():int {
		return _columnIndex;
	}

	public function set columnIndex(value:int):void {
		_columnIndex = value;
	}

	//==========================================================================================
	// render
	//==========================================================================================
	public function render():void {
		invalidateDisplayList();
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var indent:int = 0;
		var width:Number = this.width;
		var height:Number = this.height;
		var contentBound:Rectangle = new Rectangle;

		clear();

		//----------------------------------------------------------------
		// draw background fill
		//----------------------------------------------------------------
		var backgroundColor:RGB = getBackgroundColor();

		graphics.beginFill(backgroundColor.toHex());

		if (columnIndex === 0 && column is TableFlagColumn) {
			if (row.indent > 0) {
				indent = row.indent * (table.mergeIndentSize + table.header.columnSeparatorSize);
			}

			if (row.hasChildren) {
				var startRow:Row = row.getStartRow();
				var endRow:Row = row.getEndRow();

				var rect:Rectangle = new Rectangle;
				rect.y = startRow.y - row.y;
				rect.height = endRow.y + endRow.height - startRow.y;

				graphics.drawRect(indent, rect.y, table.mergeIndentSize, rect.height);
				graphics.drawRect(indent + table.mergeIndentSize, 0, width - indent - table.mergeIndentSize, height);

				if (_contentSpace === "wide") {
					contentBound.x = indent;
					contentBound.width = width - indent;
				} else {
					contentBound.x = indent + table.mergeIndentSize;
					contentBound.width = width - contentBound.x;
				}
			} else {
				graphics.drawRect(indent, 0, width - indent, height);

				contentBound.x = indent;
				contentBound.width = width - indent;
			}
		} else {
			graphics.drawRect(0, 0, width, height);

			contentBound.x = 0;
			contentBound.width = width;
		}

		contentBound.y = 0;
		contentBound.height = height;

		graphics.endFill();

		//----------------------------------------------------------------
		// draw content
		//----------------------------------------------------------------
		if (row && row.data && column && column.dataField) {
			renderContent(contentBound);
		}

		//----------------------------------------------------------------
		// event
		//----------------------------------------------------------------
		if (column.click !== null) {
			addEventListener(MouseEvent.CLICK, mouseEventHandler, false, 0, true);
		} else if (hasEventListener(MouseEvent.CLICK)) {
			removeEventListener(MouseEvent.CLICK, mouseEventHandler);
		}
	}

	private function mouseEventHandler(event:MouseEvent):void {
		if (column.click !== null) column.click(column, row);
	}

	override protected function getLabelText():String {
		return LabelComponentUtils.getLabel(row.data, column.dataField, formatter, labelFunction, this);
	}

	private function getBackgroundColor():RGB {
		var back:RGB = new RGB(row.backgroundColor);
		var fore:RGB = new RGB(column.columnBackgroundColor);

		var result:RGB;

		switch (column.columnBackgroundBlendMode) {
			case ColumnBlendMode.OVERWRITE:
				result = fore;
				break;
			default:
				result = back.multiply(fore);
				break;
		}
		
		return result;
	}
}
}
