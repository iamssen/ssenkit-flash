package ssen.flexkit.components.grid.columns {
import mx.core.ClassFactory;

import ssen.flexkit.components.grid.editors.CheckBoxGridRenderer;

public class ToggleGridColumn extends BasicGridColumn {

	public function ToggleGridColumn(columnName:String=null) {
		super(columnName);
		itemRenderer=new ClassFactory(CheckBoxGridRenderer);
		rendererIsEditable=true;
	}
}
}
