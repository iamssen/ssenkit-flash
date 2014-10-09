package ssen.components.mxDatagridSupportClasses.datagrid {
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;

/** 숫자형 정렬 오류를 해결해주는 AdvancedDataGridColumn */
public class ADGNumbericColumn extends AdvancedDataGridColumn {
	private function compareFunction(a:Object, b:Object):int {
		var result:Number=Number(a[dataField]) - Number(b[dataField]);
		if (result > 0) {
			return 1;
		} else if (result < 0) {
			return -1;
		}

		return 0;
	}

	public function ADGNumbericColumn(columnName:String=null) {
		super(columnName);

		sortCompareFunction=compareFunction;
	}
}
}
