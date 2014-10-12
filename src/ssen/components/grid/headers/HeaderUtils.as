package ssen.components.grid.headers {

public class HeaderUtils {
	public static function countColumnsAndRows(columns:Vector.<IHeaderColumn>):Vector.<int> {
		var numRows:int = 0;
		var numColumns:int = 0;

		function computeColumns(list:Vector.<IHeaderColumn>, depth:int):void {
			if (depth > numRows) {
				numRows = depth;
			}

			var column:IHeaderColumn;
			var f:int = -1;
			var fmax:int = list.length;

			while (++f < fmax) {
				column = list[f];

				// increase column count
				if (column is IHeaderLeafColumn) {
					numColumns++;
				}

				if (column is IHeaderBrancheColumn) {
					computeColumns(IHeaderBrancheColumn(column).columns, depth + 1);
				}
			}
		}

		computeColumns(columns, 1);

		return new <int>[numRows, numColumns];
	}

	//==========================================================================================
	// calculate points
	//==========================================================================================
	// size 배열을 position 배열로 전환한다
	public static function sizeToPosition(size:Vector.<Number>, columnSeparatorSize:int):Vector.<Number> {
		var pos:Vector.<Number> = new Vector.<Number>(size.length, true);
		var nx:Number = 0;

		var f:int = -1;
		var fmax:int = size.length;
		while (++f < fmax) {
			pos[f] = nx;
			nx += size[f] + columnSeparatorSize;
		}

		return pos;
	}

	//----------------------------------------------------------------
	// column들의 width 들을 계산한다
	// - ratio (no scroll)
	// - real (scroll)
	//----------------------------------------------------------------
	public static function computeColumnRatios(columns:Vector.<IHeaderColumn>):Vector.<Number> {
		var widthList:Vector.<Number> = new Vector.<Number>;
		// source가 되는 widthList를 읽어온다
		readColumnWidth(columns, widthList);
		return valuesToRatios(widthList);
	}

	// Pixel 단위 사이즈들을 int 단위로 깔끔하게 정리한다
	// int 단위로 정리를 한다음에 여분은 마지막 사이즈에 몰아서 준다
	public static function cleanPixels(w:Number, gap:int, values:Vector.<Number>):Vector.<Number> {
		var cleaned:Vector.<Number> = new Vector.<Number>(values.length, true);
		var fw:int;
		var nx:int = 0;

		var f:int = -1;
		var fmax:int = values.length;
		while (++f < fmax) {
			if (f === fmax - 1) {
				cleaned[f] = w - nx;
			} else {
				fw = values[f];
				cleaned[f] = fw;
				nx += fw + gap;
			}
		}

		return cleaned;
	}

	// Total을 Ratio로 쪼개서 보내준다
	public static function adjustRatio(total:Number, ratios:Vector.<Number>):Vector.<Number> {
		var computed:Vector.<Number> = new Vector.<Number>(ratios.length, true);
		var f:int = -1;
		var fmax:int = ratios.length;
		while (++f < fmax) {
			computed[f] = total * ratios[f];
		}
		return computed;
	}

	// Number 수치들을 Ratio 수치들로 바꾼다
	public static function valuesToRatios(values:Vector.<Number>):Vector.<Number> {
		var total:Number = 0;
		var ratios:Vector.<Number>;

		var f:int = -1;
		var fmax:int = values.length;
		while (++f < fmax) {
			total += values[f];
		}

		if (total !== 1) {
			ratios = new Vector.<Number>(values.length, true);

			f = -1;
			fmax = values.length;
			while (++f < fmax) {
				ratios[f] = values[f] / total;
			}
		} else {
			ratios = values;
		}

		return ratios;
	}

	// Tree 형태의 Vector.<IHeaderColumn>의 재귀 반복을 통해 최종 Leaf들만을 찾아서 widthList로 저장한다.
	public static function readColumnWidth(columns:Vector.<IHeaderColumn>, widthList:Vector.<Number>):void {
		var column:IHeaderColumn;
		var f:int = -1;
		var fmax:int = columns.length;

		while (++f < fmax) {
			column = columns[f];

			// branche 일 경우에는 재귀로 하위를 검색한다
			if (column is IHeaderBrancheColumn) {
				readColumnWidth(IHeaderBrancheColumn(column).columns, widthList);
			}

			if (column is IHeaderLeafColumn) {
				widthList.push(IHeaderLeafColumn(column).columnWidth);
			}
		}
	}
}
}
