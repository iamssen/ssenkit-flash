package ssen.components.ds.tables {
public interface ITableCellObject {
	function get table():ITableObject;

	function get row():ITableRowObject;

	function get column():ITableColumnObject;
}
}
