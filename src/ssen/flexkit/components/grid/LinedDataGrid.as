package ssen.flexkit.components.grid {
import mx.core.ClassFactory;

import spark.components.DataGrid;

import ssen.flexkit.components.grid.editors.TextGridEditor;
import ssen.flexkit.components.grid.elements.IDataGridRowElement;
import ssen.flexkit.components.grid.renderers.GridRenderer;
import ssen.flexkit.components.grid.skins.LinedDataGridSkin;

public class LinedDataGrid extends DataGrid {
	[SkinPart(required="false")]
	public var columnFooterElement:IDataGridRowElement;

	public function LinedDataGrid() {
		itemRenderer=new ClassFactory(GridRenderer);
		itemEditor=new ClassFactory(TextGridEditor);

		setStyle("skinClass", LinedDataGridSkin);

		rowHeight=34;
	}

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === columnFooterElement || instance === grid) {
			if (columnFooterElement && grid) {
				columnFooterElement.dataGrid=this;
			}
		}
	}
}
}
