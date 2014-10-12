package ssen.components.grid.headers {

public class HeaderUtils {
	public static function count(columns:Vector.<IHeaderColumn>):Vector.<int> {
		var numRows:int = 0;
		var numColumns:int = 0;

		function computeColumns(list:Vector.<IHeaderColumn>, depth:int):void {
			if (depth > numRows) {
				numRows = depth;
			}

			var column:IHeaderColumn;
			var f:int = -1;
			var fmax:int = list.length;
			var width:Number;

			while (++f < fmax) {
				column = list[f];

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

	//	public static function getBrancheWidth(widthList:Vector.<Number>, columnSeparatorSize:int, columnIndex:int, numColumns:int):Number {
	//		var separatorSize:int = (numColumns - 1) * columnSeparatorSize;
	//		var widthTotal:Number = 0;
	//
	//		var f:int = columnIndex;
	//		var fmax:int = columnIndex + numColumns;
	//		while (++f < fmax) {
	//			widthTotal += widthList[f];
	//		}
	//
	//		return widthTotal + separatorSize;
	//	}

	//	public static function getColumnBound(column:IHeaderColumn):Rectangle {
	//		var header:IHeaderContainer = column.header;
	//		var rowIndex:int = column.rowIndex;
	//		var columnIndex:int = column.columnIndex;
	//
	//		var rowHeight:Number = header.rowHeight;
	//		var rowSeparatorSize:Number = header.rowSeparatorSize;
	//		var columnSeparatorSize:Number = header.columnSeparatorSize;
	//		var columnWidthList:Vector.<Number> = header.computedColumnWidthList;
	//		var columnPositionList:Vector.<Number> = header.computedColumnPositionList;
	//
	//		var x:Number;
	//		var y:Number;
	//		var w:Number;
	//		var h:Number;
	//
	//		if (column is IHeaderBrancheColumn) {
	//			var branche:IHeaderBrancheColumn = column as IHeaderBrancheColumn;
	//
	//			x = columnPositionList[columnIndex];
	//			y = (rowIndex > 0) ? (rowHeight + rowSeparatorSize) * rowIndex : 0;
	//			w = getBrancheWidth(columnWidthList, columnSeparatorSize, column.columnIndex - 1, branche.numColumns + 1);
	//			h = (rowHeight * branche.numRows) + (rowHeight * (branche.numRows - 1));
	//		} else {
	//			var surplusRows:int = (header.numRows - rowIndex);
	//
	//			x = columnPositionList[columnIndex];
	//			y = (rowIndex > 0) ? (rowHeight + rowSeparatorSize) * rowIndex : 0;
	//			w = columnWidthList[columnIndex];
	//			h = (rowHeight * surplusRows) + (rowSeparatorSize * (surplusRows - 1));
	//		}
	//
	//		return new Rectangle(x, y, w, h);
	//	}

	public static function getSpace(rowIndex:int):String {
		var str:String = "";
		var f:int = rowIndex + 1;
		while (--f >= 0) {
			str += "+";
		}
		return str;
	}
}
}
