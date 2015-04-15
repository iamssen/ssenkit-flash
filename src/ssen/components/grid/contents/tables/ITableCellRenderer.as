package ssen.components.grid.contents.tables {
import mx.core.IVisualElement;

import spark.components.Group;

public interface ITableCellRenderer extends IVisualElement {
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

	//---------------------------------------------
	// data
	//---------------------------------------------
	/** data */
	function get data() : Object;
	function set data(value : Object):void;

	function render():void;
}
}
