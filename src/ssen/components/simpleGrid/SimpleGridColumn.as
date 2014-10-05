package ssen.components.simpleGrid {
import mx.core.IFactory;

import ssen.ssen_internal;

public class SimpleGridColumn {
	// data
	public var dataField:String;
	public var headerText:String;

	// if require datagrid have explicitWidth
	public var explicitWidth:Number;
	public var elasticWidthRatio:Number;

	public var headerCellRenderer:IFactory /* of ISimpleGridRenderer */;
	public var contentCellRenderer:IFactory /* of ISimpleGridRenderer */;

	/** `(data:Object, column:SimpleGridColumn):ISimpleGridRenderer` */
	public var headerCellRendererFunction:Function;

	/** `(data:Object, column:SimpleGridColumn):ISimpleGridRenderer` */
	public var contentCellRendererFunction:Function;

	ssen_internal var widthRatio:Number;
}
}
