package ssen.components.grid.contents.tables {
import flash.geom.Rectangle;

import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.core.UIComponent;

import ssen.common.MathUtils;

public class TableCellRenderer extends UIComponent implements ITableCellRenderer {
	internal static const defaultRenderer:IFactory = new ClassFactory(TableCellRenderer);

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

	//---------------------------------------------
	// data
	//---------------------------------------------
	private var _data:Object;

	/** data */
	public function get data():Object {
		return _data;
	}

	public function set data(value:Object):void {
		_data = value;
	}

	//==========================================================================================
	// render
	//==========================================================================================
	public function render():void {
		var indent:int = 0;
		var width:Number = this.width;
		var height:Number = this.height;

		var backgroundColor:uint = MathUtils.rand(0, 0xffffff);

		graphics.clear();

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

				graphics.beginFill(backgroundColor);
				graphics.drawRect(indent, rect.y, table.mergeIndentSize, rect.height);
				graphics.drawRect(indent + table.mergeIndentSize, 0, width - indent - table.mergeIndentSize, height);
				graphics.endFill();
			} else {
				graphics.beginFill(backgroundColor);
				graphics.drawRect(indent, 0, width - indent, height);
				graphics.endFill();
			}
		} else {
			graphics.beginFill(backgroundColor);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}
}
