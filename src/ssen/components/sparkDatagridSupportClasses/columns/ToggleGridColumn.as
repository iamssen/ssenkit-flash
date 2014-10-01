package ssen.components.sparkDatagridSupportClasses.columns {

import mx.core.ClassFactory;

import ssen.components.sparkDatagridSupportClasses.editors.CheckBoxGridRenderer;

public class ToggleGridColumn extends BasicGridColumn {

	public function ToggleGridColumn(columnName:String = null) {
		super(columnName);
		itemRenderer = new ClassFactory(CheckBoxGridRenderer);
		rendererIsEditable = true;
	}
}
}
