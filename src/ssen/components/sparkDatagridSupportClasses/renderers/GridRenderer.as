package ssen.components.sparkDatagridSupportClasses.renderers {

import flashx.textLayout.formats.VerticalAlign;

import spark.components.gridClasses.GridColumn;

import ssen.components.sparkDatagridSupportClasses.columns.BasicGridColumn;

public class GridRenderer extends GraphicsLabelGridRenderer {
	public function GridRenderer() {
		setStyle("paddingTop", 8);
		setStyle("paddingRight", 8);
		setStyle("paddingBottom", 6);
		setStyle("paddingLeft", 9);
		setStyle("verticalAlign", VerticalAlign.MIDDLE);
	}

	override public function set column(value:GridColumn):void {
		super.column = value;

		var column:BasicGridColumn = value as BasicGridColumn;
		setStyle("textAlign", column.textAlign);
	}
}
}
