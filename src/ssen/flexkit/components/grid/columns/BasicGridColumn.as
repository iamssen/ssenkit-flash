package ssen.flexkit.components.grid.columns {
import mx.core.ClassFactory;

import spark.components.gridClasses.GridColumn;

import ssen.flexkit.components.grid.editors.TextGridEditor;
import ssen.flexkit.components.grid.renderers.GridRenderer;

public class BasicGridColumn extends spark.components.gridClasses.GridColumn {
	[Inspectable(type="Array", enumeration="start,end,left,right,center,justify", defaultValue="left")]
	public var textAlign:String="left";

	public function BasicGridColumn(columnName:String=null) {
		super(columnName);
		itemRenderer=new ClassFactory(GridRenderer);
		itemEditor=new ClassFactory(TextGridEditor);
	}
}
}
