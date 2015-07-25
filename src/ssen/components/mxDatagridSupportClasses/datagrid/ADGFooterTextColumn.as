package ssen.components.mxDatagridSupportClasses.datagrid {
import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;

/** ADG Footer Column : Text를 보여준다 */ 
public class ADGFooterTextColumn extends ADGFooterColumn {
	private var renderer:IListItemRenderer;

	/** 출력할 문자 */
	public var text:String;

	/** @inheritDoc */
	override public function render(grid:AdvancedDataGrid, index:int):IListItemRenderer {
		if (!grid || !grid.dataProvider) {
			return null;
		}

		var column:AdvancedDataGridColumn=grid.columns[index];

		if (!renderer) {
			renderer=new GridCenterRenderer;
		}

		var dataField:String=column.dataField;

		if (renderer is IDropInListItemRenderer) {
			var listData:AdvancedDataGridListData=new AdvancedDataGridListData(text, column.dataField, index, null, grid, -1);

			var drenderer:IDropInListItemRenderer=renderer as IDropInListItemRenderer;
			drenderer.listData=listData;
		}
		renderer.data=text;

		return renderer;
	}
}
}
