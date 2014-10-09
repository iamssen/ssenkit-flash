package ssen.components.grid.headers {
import flash.geom.Point;

public class HeaderUtils {
	public static function count(columns:Vector.<IHeaderColumn>):Vector.<int> {
		var numRows:int=0;
		var numColumns:int=0;

		function computeColumns(list:Vector.<IHeaderColumn>, depth:int):void {
			if (depth > numRows) {
				numRows=depth;
			}

			var column:IHeaderColumn;
			var f:int=-1;
			var fmax:int=list.length;
			var width:Number;

			while (++f < fmax) {
				column=list[f];

				// increase column count
				if (column is IHeaderLeafColumn) {
					numColumns++;
				}

				// 
				if (column is IHeaderBrancheColumn) {
					computeColumns(IHeaderBrancheColumn(column).columns, depth + 1);
				}
			}
		}

		computeColumns(columns, 1);

		return new <int>[numRows, numColumns];
	}

	public static function getPoint(container:IHeaderContainer, rowIndex:int, columnIndex:int):Point {
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
