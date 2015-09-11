package ssen.components.sparkDatagridSupportClasses {

import mx.core.ClassFactory;

import spark.components.DataGrid;

import ssen.components.base.setDefaultSkin;
import ssen.components.sparkDatagridSupportClasses.editors.TextGridEditor;
import ssen.components.sparkDatagridSupportClasses.elements.IDataGridRowElement;
import ssen.components.sparkDatagridSupportClasses.renderers.GridRenderer;
import ssen.components.sparkDatagridSupportClasses.skins.LinedDataGridSkin;

public class LinedDataGrid extends DataGrid {
	[SkinPart(required="false")]
	public var columnFooterElement:IDataGridRowElement;

	public function LinedDataGrid() {
		setDefaultSkin(styleManager, LinedDataGrid, LinedDataGridSkin);

		itemRenderer = new ClassFactory(GridRenderer);
		itemEditor = new ClassFactory(TextGridEditor);

		rowHeight = 34;
	}

	override protected function attachSkin():void {
		if (!getStyle("skinClass") && !getStyle("skinFactory")) setStyle("skinClass", LinedDataGridSkin);
		super.attachSkin();
	}

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);

		if (instance === columnFooterElement || instance === grid) {
			if (columnFooterElement && grid) {
				columnFooterElement.dataGrid = this;
			}
		}
	}
}
}
