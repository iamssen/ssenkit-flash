package ssen.components.ds.tables {
public interface ITableRowObject {
	function get prev():ITableRowObject;

	function get next():ITableRowObject;

	function get isFirst():Boolean;

	function get isLast():Boolean;

	function get cells():Vector.<ITableCellObject>;

	function get index():int;
}
}
