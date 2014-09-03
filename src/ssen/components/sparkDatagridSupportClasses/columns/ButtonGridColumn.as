package ssen.flexkit.components.grid.columns {
import mx.core.ClassFactory;

import flashx.textLayout.formats.TextAlign;

import ssen.flexkit.components.grid.editors.LabelButtonGridRenderer;

public class ButtonGridColumn extends BasicGridColumn {
	public var label:String="BUTTON";
	public var callback:Function;

	public function ButtonGridColumn(columnName:String=null) {
		super(columnName);
		rendererIsEditable=true;
		textAlign=TextAlign.CENTER;
		itemRenderer=new ClassFactory(LabelButtonGridRenderer);
	}
}
}
