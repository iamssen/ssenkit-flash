package ssen.components.sparkDatagridSupportClasses.columns {

import mx.core.ClassFactory;

import spark.components.gridClasses.GridColumn;

import ssen.components.sparkDatagridSupportClasses.editors.TextGridEditor;
import ssen.components.sparkDatagridSupportClasses.renderers.GridRenderer;

public class BasicGridColumn extends GridColumn {
	[Inspectable(type="Array", enumeration="start,end,left,right,center,justify", defaultValue="left")]
	public var textAlign:String = "left";

	public function BasicGridColumn(columnName:String = null) {
		super(columnName);
		itemRenderer = new ClassFactory(GridRenderer);
		itemEditor = new ClassFactory(TextGridEditor);
	}
}
}
