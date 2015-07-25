package ssen.components.grid.headers {

public interface IHeaderBrancheColumn extends IHeaderColumn {

	/** columns */
	[Bindable(event="propertyChange")]
	function get columns():Vector.<IHeaderColumn>;
	function set columns(value:Vector.<IHeaderColumn>):void;

	/** numColumns */
	[Bindable(event="propertyChange")]
	function get numColumns():int;

	/** numRows */
	[Bindable(event="propertyChange")]
	function get numRows():int;
}
}
