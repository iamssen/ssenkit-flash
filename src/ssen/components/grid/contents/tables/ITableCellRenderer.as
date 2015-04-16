package ssen.components.grid.contents.tables {
import mx.core.IVisualElement;

import ssen.common.IDisposable;

public interface ITableCellRenderer extends IVisualElement, IDisposable {
	//---------------------------------------------
	// table
	//---------------------------------------------
	/** table */
	function get table():Table;
	function set table(value:Table):void;

	//---------------------------------------------
	// row
	//---------------------------------------------
	/** row */
	function get row() : Row;
	function set row(value : Row):void;

	//---------------------------------------------
	// column
	//---------------------------------------------
	/** column */
	function get column() : TableColumn;
	function set column(value : TableColumn):void;

	//---------------------------------------------
	// columnIndex
	//---------------------------------------------
	/** columnIndex */
	function get columnIndex() : int;
	function set columnIndex(value : int):void;

	function render():void;
}
}
