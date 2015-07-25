package ssen.components.grid {

import ssen.common.MathUtils;
import ssen.components.grid.headers.*;

public class GridUtils {
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

	public static function getColumnWidthList(columns:Vector.<IHeaderLeafColumn>):Vector.<Number> {
		var list:Vector.<Number> = new Vector.<Number>(columns.length, true);
		var f:int = columns.length;
		while (--f >= 0) {
			list[f] = columns[f].columnWidth;
		}
		return list;
	}

	public static function sumValues(values:Vector.<Number>, startIndex:int, endIndex:int, gap:int):Number {
		if (startIndex < 0 || endIndex < 0) {
			return 0;
		}

		var length:int = (endIndex - startIndex) + 1;

		if (length < 0) {
			return 0;
		}

		if (length === 0) {
			return values[startIndex];
		}

		var total:Number = 0;

		var f:int = startIndex - 1;
		var fmax:int = endIndex + 1;
		while (++f < fmax) {
			total += values[f];
		}

		return total + ((length - 1) * gap);
	}

	public static function columnDrawX(positionList:Vector.<Number>, columnIndex:int, containerId:int, columnLayoutMode:String, frontLockedColumnCount:int, backLockedColumnCount:int):Number {
		if (columnLayoutMode === HeaderLayoutMode.RATIO) {
			return positionList[columnIndex];
		}

		switch (containerId) {
			case GridBlock.FRONT_LOCK:
				return positionList[columnIndex];
			case GridBlock.UNLOCK:
				if (frontLockedColumnCount > 0) {
					return positionList[columnIndex] - positionList[frontLockedColumnCount];
				} else {
					return positionList[columnIndex];
				}
			case GridBlock.BACK_LOCK:
				return positionList[columnIndex] - positionList[positionList.length - backLockedColumnCount];
		}

		return NaN;
	}

	public static function countBrancheColumns(numColumns:int, frontLock:int, backLock:int, columnIndex:int, brancheColumns:int):Vector.<HeaderBrancheDrawCommand> {
		var minmax:Vector.<int> = new <int>[int.MAX_VALUE, int.MIN_VALUE, int.MAX_VALUE, int.MIN_VALUE, int.MAX_VALUE, int.MIN_VALUE];

		var frontLockIndex:int = frontLock;
		var backLockIndex:int = numColumns - backLock;

		var f:int = columnIndex - 1;
		var fmax:int = columnIndex + brancheColumns;

		while (++f < fmax) {
			if (f < frontLockIndex) {
				if (f < minmax[0]) {
					minmax[0] = f;
				}
				if (f > minmax[1]) {
					minmax[1] = f;
				}
			} else if (f < backLockIndex) {
				if (f < minmax[2]) {
					minmax[2] = f;
				}
				if (f > minmax[3]) {
					minmax[3] = f;
				}
			} else {
				if (f < minmax[4]) {
					minmax[4] = f;
				}
				if (f > minmax[5]) {
					minmax[5] = f;
				}
			}
		}

		var commands:Vector.<HeaderBrancheDrawCommand> = new Vector.<HeaderBrancheDrawCommand>;
		var command:HeaderBrancheDrawCommand;
		var drawFirstContainer:Boolean = true;

		if (MathUtils.rangeOf(minmax[0], 0, numColumns - 1) && MathUtils.rangeOf(minmax[1], 0, numColumns - 1)) {
			command = new HeaderBrancheDrawCommand;
			command.block = 0;
			command.start = minmax[0];
			command.end = minmax[1];
			command.begin = drawFirstContainer;
			drawFirstContainer = false;
			commands.push(command);
		}

		if (MathUtils.rangeOf(minmax[2], 0, numColumns - 1) && MathUtils.rangeOf(minmax[3], 0, numColumns - 1)) {
			command = new HeaderBrancheDrawCommand;
			command.block = 1;
			command.start = minmax[2];
			command.end = minmax[3];
			command.begin = drawFirstContainer;
			drawFirstContainer = false;
			commands.push(command);
		}

		if (MathUtils.rangeOf(minmax[4], 0, numColumns - 1) && MathUtils.rangeOf(minmax[5], 0, numColumns - 1)) {
			command = new HeaderBrancheDrawCommand;
			command.block = 2;
			command.start = minmax[4];
			command.end = minmax[5];
			command.begin = drawFirstContainer;
			commands.push(command);
		}

		return commands;
	}

	public static function getContainerId(header:IHeader, columnIndex:int):int {
		if (header.columnLayoutMode === HeaderLayoutMode.RATIO) {
			return GridBlock.UNLOCK;
		} else if (columnIndex < header.frontLockedColumnCount) {
			return GridBlock.FRONT_LOCK;
		} else if (columnIndex >= header.numColumns - header.backLockedColumnCount) {
			return GridBlock.BACK_LOCK;
		} else {
			return GridBlock.UNLOCK;
		}
	}

	//	public static function drawStartX(columnLayoutMode:String, positionList:Vector.<Number>, columnIndex:int, lockedColumnCount:int):Number {
	//		if (columnLayoutMode === HeaderLayoutMode.RATIO || columnIndex < lockedColumnCount) {
	//			return positionList[columnIndex];
	//		}
	//
	//		return positionList[columnIndex] - positionList[lockedColumnCount];
	//	}
}
}
