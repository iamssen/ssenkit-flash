package ssen.components.mxDatagridSupportClasses.chartWeaver {
import flash.utils.getQualifiedClassName;

import mx.controls.AdvancedDataGrid;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;

public class DataGridUtils {
	public static function getGridColumns(grid:AdvancedDataGrid):Array {
		if (grid.columns) {
			return grid.columns;
		}

		var arr:Array=[];
		collectChildrenColumns(grid.groupedColumns, arr);

		return arr;
	}

	private static function collectChildrenColumns(columns:Array, arr:Array):void {
		var column:Object;

		var f:int=-1;
		var fmax:int=columns.length;

		while (++f < fmax) {
			column=columns[f];

			if (column is AdvancedDataGridColumn) {
				arr.push(column);
			} else if (column is AdvancedDataGridColumnGroup) {
				collectChildrenColumns(AdvancedDataGridColumnGroup(column).children, arr);
			} else {
				throw new Error("Column도 아니고 ColumnGroup도 아니고... " + getQualifiedClassName(column));
			}
		}
	}
}
}
