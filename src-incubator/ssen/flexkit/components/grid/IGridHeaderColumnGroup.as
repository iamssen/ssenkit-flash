package ssen.flexkit.components.grid {

public interface IGridHeaderColumnGroup extends IGridHeaderColumn {
	//---------------------------------------------
	// columns
	//---------------------------------------------
	/** columns */
	function get columns():Vector.<IGridHeaderColumn>;
	function set columns(value:Vector.<IGridHeaderColumn>):void;

	//---------------------------------------------
	// numColumns
	//---------------------------------------------
	/** numColumns */
	function get numColumns():int;

	//---------------------------------------------
	// numRows
	//---------------------------------------------
	/** numRows */
	function get numRows():int;
}
}
