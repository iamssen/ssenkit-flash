package ssen.components.ds.tables {
public interface ITableColumnObject {
	function get prev():ITableColumnObject;

	function get next():ITableColumnObject;

	function get isFirst():Boolean;

	function get isLast():Boolean;

	function get cells():Vector.<ITableCellObject>;

	function get index():int;
}
}
