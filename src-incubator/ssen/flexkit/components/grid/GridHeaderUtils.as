package ssen.flexkit.components.grid {
import flash.geom.Point;

import ssen.drawingkit.XY;

public class GridHeaderUtils {
	public static function count(columns:Vector.<IGridHeaderColumn>):Vector.<int> {
		var numRows:int=0;
		var numColumns:int=0;

		function computeColumns(list:Vector.<IGridHeaderColumn>, depth:int):void {
			if (depth > numRows) {
				numRows=depth;
			}

			var column:IGridHeaderColumn;
			var f:int=-1;
			var fmax:int=list.length;
			var width:Number;

			while (++f < fmax) {
				column=list[f];

				// increase column count
				if (column is IGridHeaderColumnLeaf) {
					numColumns++;
				}

				// 
				if (column is IGridHeaderColumnGroup) {
					computeColumns(IGridHeaderColumnGroup(column).columns, depth + 1);
				}
			}
		}

		computeColumns(columns, 1);

		return new <int>[numRows, numColumns];
	}

	public static function getPoint(container:GridHeader, rowIndex:int, columnIndex:int):Point {
		var rowHeight:Number=container.rowHeight;
		var rowSeparatorSize:Number=container.rowSeparatorSize;
		var columnSeparatorSize:Number=container.columnSeparatorSize;
		var x:Number=0;
		var y:Number=(rowIndex * rowHeight) + (rowIndex * rowSeparatorSize);
		var columnWidthList:Vector.<Number>=container.computedWidthList;

		var f:int=-1;
		var fmax:int=columnIndex;
		while (++f < fmax) {
			x+=columnWidthList[f] + columnSeparatorSize;
		}

		x-=columnSeparatorSize;

		return new Point(x, y);
	}
}
}
