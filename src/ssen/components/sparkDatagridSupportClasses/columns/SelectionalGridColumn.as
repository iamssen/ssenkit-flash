package ssen.components.sparkDatagridSupportClasses.columns {

import mx.core.ClassFactory;

import ssen.components.sparkDatagridSupportClasses.editors.DropDownGridEditor;
import ssen.components.sparkDatagridSupportClasses.renderers.SelectionalGridRenderer;

public class SelectionalGridColumn extends BasicGridColumn {
	public var dataProviderField:String;
	public var labelField:String;

	public function SelectionalGridColumn(columnName:String = null) {
		super(columnName);
		itemRenderer = new ClassFactory(SelectionalGridRenderer);
		itemEditor = new ClassFactory(DropDownGridEditor);
	}
}
}
