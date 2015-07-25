package ssen.components.mxDatagridSupportClasses.datagrid {
import mx.collections.IList;
import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.IFactory;

/** ADG Footer Column : 분모 Column, 분자 Column의 합계를 Percentage로 보여준다 */
public class ADGFooterPercentageColumn extends ADGFooterColumn {
	
	private var itemRenderer:IFactory;
	private var renderer:IListItemRenderer;

	/** 분자 Column Field */
	public var numeratorField:String;
	
	/** 분모 Column Field */
	public var denominatorField:String;

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
		var sum1:Number=0;
		var sum2:Number=0;
		var n:Number;

		var f:int=-1;
		var fmax:int=list.length;
		while (++f < fmax) {
			row=list.getItemAt(f);

			n=Number(row[numeratorField]);
			if (!isNaN(n)) {
				sum1+=n;
			}

			n=Number(row[denominatorField]);
			if (!isNaN(n)) {
				sum2+=n;
			}
		}

		var avg:Number=Math.round(sum1 / sum2 * 100);

		if (renderer is IDropInListItemRenderer) {
			var text:String=(column.labelFunction !== null) ? column.labelFunction(column) : avg.toString();
			var listData:AdvancedDataGridListData=new AdvancedDataGridListData(text, column.dataField, index, null, grid, -1);

			var drenderer:IDropInListItemRenderer=renderer as IDropInListItemRenderer;
			drenderer.listData=listData;
		}
		renderer.data=avg;

		return renderer;
	}
}
}
