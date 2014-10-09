package ssen.components.grid.headers {

public interface IHeaderLeafColumn extends IHeaderColumn {
	/** columnWidth */
	[Bindable(event="propertyChange")]
	function get columnWidth():Number;
	function set columnWidth(value:Number):void;

	/** computedColumnWidth */
	[Bindable(event="propertyChange")]
	function get computedColumnWidth():Number;
}
}
