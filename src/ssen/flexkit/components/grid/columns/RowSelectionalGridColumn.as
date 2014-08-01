package ssen.flexkit.components.grid.columns {
import mx.core.ClassFactory;

import ssen.flexkit.components.grid.editors.GridRowSelector;

public class RowSelectionalGridColumn extends BasicGridColumn {
	public function RowSelectionalGridColumn(columnName:String=null) {
		super(columnName);
		rendererIsEditable=true;
		itemRenderer=new ClassFactory(GridRowSelector);
	}
}
}
