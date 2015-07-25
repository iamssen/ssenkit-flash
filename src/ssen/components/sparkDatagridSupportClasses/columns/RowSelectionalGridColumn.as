package ssen.components.sparkDatagridSupportClasses.columns {

import mx.core.ClassFactory;

import ssen.components.sparkDatagridSupportClasses.editors.GridRowSelector;

public class RowSelectionalGridColumn extends BasicGridColumn {
	public function RowSelectionalGridColumn(columnName:String = null) {
		super(columnName);
		rendererIsEditable = true;
		itemRenderer = new ClassFactory(GridRowSelector);
	}
}
}
