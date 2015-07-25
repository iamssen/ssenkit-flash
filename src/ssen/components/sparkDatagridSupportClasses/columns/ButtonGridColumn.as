package ssen.components.sparkDatagridSupportClasses.columns {

import flashx.textLayout.formats.TextAlign;

import mx.core.ClassFactory;

import ssen.components.sparkDatagridSupportClasses.editors.LabelButtonGridRenderer;

public class ButtonGridColumn extends BasicGridColumn {
	public var label:String = "BUTTON";
	public var callback:Function;

	public function ButtonGridColumn(columnName:String = null) {
		super(columnName);
		rendererIsEditable = true;
		textAlign = TextAlign.CENTER;
		itemRenderer = new ClassFactory(LabelButtonGridRenderer);
	}
}
}
