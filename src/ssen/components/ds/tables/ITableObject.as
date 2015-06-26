package ssen.components.ds.tables {
public interface ITableObject {
	function get dataProvider():Object;

	function set dataProvider(value:Object):void;

	function get rows():Vector.<ITableRowObject>;

	function get columns():Vector.<ITableColumnObject>;
}
}
