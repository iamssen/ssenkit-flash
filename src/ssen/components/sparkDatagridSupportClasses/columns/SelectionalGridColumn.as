package ssen.flexkit.components.grid.columns {
import mx.core.ClassFactory;

import ssen.flexkit.components.grid.editors.DropDownGridEditor;
import ssen.flexkit.components.grid.renderers.SelectionalGridRenderer;

public class SelectionalGridColumn extends BasicGridColumn {
	public var dataProviderField:String;
	public var labelField:String;

	public function SelectionalGridColumn(columnName:String=null) {
		super(columnName);
		itemRenderer=new ClassFactory(SelectionalGridRenderer);
		itemEditor=new ClassFactory(DropDownGridEditor);
	}
}
}
