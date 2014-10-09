package ssen.components.mxDatagridSupportClasses.datagrid {
import mx.collections.IList;
import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.dataGridClasses.DataGridListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.IFactory;

/** ADG Footer Column : Column의 평균값을 구한다 */
public class ADGFooterAverageColumn extends ADGFooterColumn {
	private var itemRenderer:IFactory;
	private var renderer:IListItemRenderer;

	/** @inheritDoc */
	override public function render(grid:AdvancedDataGrid, index:int):IListItemRenderer {
		if (!grid || !grid.dataProvider) {
			return null;
		}

		var column:AdvancedDataGridColumn=grid.columns[index];

		if (column.itemRenderer !== itemRenderer) {
			renderer=null;
			itemRenderer=column.itemRenderer;
		}

		if (!renderer) {
			renderer=itemRenderer.newInstance();
		}

		var list:IList=grid.dataProvider as IList;
		var row:Object;
		var dataField:String=column.dataField;
		var sum:Number=0;
		var n:Number;

		var f:int=-1;
		var fmax:int=list.length;
		while (++f < fmax) {
			row=list.getItemAt(f);
			n=Number(row[dataField]);

			if (!isNaN(n)) {
				sum+=n;
			}
		}

		var avg:int=sum / fmax;

		if (renderer is IDropInListItemRenderer) {
			var text:String=(column.labelFunction !== null) ? column.labelFunction(column) : avg.toString();
			var listData:DataGridListData=new DataGridListData(text, column.dataField, index, null, grid, -1);

			var drenderer:IDropInListItemRenderer=renderer as IDropInListItemRenderer;
			drenderer.listData=listData;
		}
		renderer.data=avg;

		return renderer;
	}
}
}
