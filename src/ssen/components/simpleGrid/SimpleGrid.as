package ssen.components.simpleGrid {
import de.polygonal.ds.Array2;

import mx.collections.IList;
import mx.core.IVisualElementContainer;
import mx.core.mx_internal;
import mx.styles.IStyleClient;

import spark.components.supportClasses.SkinnableComponent;

import ssen.common.NullUtils;
import ssen.components.simpleGrid.snippets.SimpleGridSkin;
import ssen.ssen_internal;

use namespace mx_internal;
use namespace ssen_internal;

[Style(name="headerRowHeight", inherit="no", type="int")]
[Style(name="rowHeight", inherit="no", type="int")]
[Style(name="columnBorder", inherit="no", type="int")]
[Style(name="rowBorder", inherit="no", type="int")]

[Exclude(name="height", kind="style")]

[SkinState("blank")]
[SkinState("normal")]

public class SimpleGrid extends SkinnableComponent {
	private static const HEADER_ROW_HEIGHT:int = 30;
	private static const ROW_HEIGHT:int = 24;
	private static const COLUMN_BORDER:int = 1;
	private static const ROW_BORDER:int = 1;

	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart(required="true")]
	public var cellContainer:IVisualElementContainer;

	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// dataProvider
	//---------------------------------------------
	private var _dataProvider:IList;

	/** dataProvider */
	public function get dataProvider():IList {
		return _dataProvider;
	}

	public function set dataProvider(value:IList):void {
		_dataProvider = value;
		invalidate_data();
	}

	//---------------------------------------------
	// columns
	//---------------------------------------------
	private var _columns:Vector.<SimpleGridColumn>;

	/** columns */
	public function get columns():Vector.<SimpleGridColumn> {
		return _columns;
	}

	public function set columns(value:Vector.<SimpleGridColumn>):void {
		_columns = value;
		invalidate_data();
	}

	//==========================================================================================
	// exclude setters
	//==========================================================================================
	override public function set height(value:Number):void {
	}

	override public function set scaleX(value:Number):void {
	}

	override public function set scaleY(value:Number):void {
	}

	override public function set scaleZ(value:Number):void {
	}

	//==========================================================================================
	// invalidate
	//==========================================================================================
	private var cells:Vector.<ISimpleGridRenderer>;
	private var cellGrid:Array2;

	//---------------------------------------------
	// inavalidate data
	//---------------------------------------------
	private var dataChanged:Boolean;

	final protected function invalidate_data():void {
		dataChanged = true;
		invalidateProperties();
	}

	override protected function commitProperties():void {
		super.commitProperties();

		if (dataChanged) {
			clearCells();

			if (_dataProvider && _dataProvider.length > 0 && _columns && _columns.length > 0) {
				commit_data();

				invalidateSkinState();
				invalidateSize();
				invalidateDisplayList();
			}

			dataChanged = false;
		}
	}

	ssen_internal var useExplicitSize:Boolean;

	override protected function measure():void {
		if (!cellGrid) {
			measuredWidth = 0;
			measuredHeight = 0;
			return;
		}

		useExplicitSize = !isNaN(explicitWidth);

		if (!useExplicitSize) {
			return;
		}

		var widthMap:Vector.<Number> = new Vector.<Number>;
		var x:int;
		var xmax:int = cellGrid.getW();
		var y:int;
		var ymax:int = cellGrid.getH();
		var columnWidth:Number;
		var column:SimpleGridColumn;
		var cell:ISimpleGridRenderer;
		var headerRowHeight:Number = NullUtils.nanTo(getStyle("headerRowHeight"), HEADER_ROW_HEIGHT);
		var rowHeight:Number = NullUtils.nanTo(getStyle("rowHeight"), ROW_HEIGHT);
		var columnBorder:Number = NullUtils.nanTo(getStyle("columnBorder"), COLUMN_BORDER);
		var rowBorder:Number = NullUtils.nanTo(getStyle("rowBorder"), ROW_BORDER);
		var nx:Number = 0;
		var ny:Number = 0;

		x = -1;
		while (++x < xmax) {
			columnWidth = Number.MIN_VALUE;
			column = _columns[x];

			ny = 0;

			if (isNaN(column.explicitWidth)) {
				y = -1;
				while (++y < ymax) {
					cell = cellGrid.get(x, y) as ISimpleGridRenderer;

					cell.x = nx;
					cell.y = ny;
					cell.height = (x === 0) ? headerRowHeight : rowHeight;

					cell.validateNow();

					ny += cell.width + rowBorder;

					if (cell.width > columnWidth) {
						columnWidth = cell.width;
					}
				}

				y = -1;
				while (++y < ymax) {
					cell = cellGrid.get(x, y) as ISimpleGridRenderer;
					cell.width = columnWidth;
				}
			} else {
				columnWidth = column.explicitWidth;

				y = -1;
				while (++y < ymax) {
					cell = cellGrid.get(x, y) as ISimpleGridRenderer;

					cell.x = nx;
					cell.y = ny;
					cell.width = columnWidth;
					cell.height = (x === 0) ? headerRowHeight : rowHeight;

					ny += cell.width + rowBorder;
				}
			}

			widthMap.push(columnWidth);

			nx += columnWidth + columnBorder;
		}

		var container:IStyleClient = cellContainer as IStyleClient;
		var left:Number = 0, right:Number = 0, top:Number = 0, bottom:Number = 0;
		var columnsBorderTotal:Number = NullUtils.nanTo(getStyle("columnBorder"), COLUMN_BORDER) * (xmax - 1);
		var rowBorderTotal:Number = NullUtils.nanTo(getStyle("rowBorder"), ROW_BORDER) * (ymax - 1);
		var headerRowsHeightTotal:Number = NullUtils.nanTo(getStyle("headerRowHeight"), HEADER_ROW_HEIGHT);
		var rowsHeightTotal:Number = NullUtils.nanTo(getStyle("rowHeight"), ROW_HEIGHT) * (ymax - 1);

		if (container) {
			left = NullUtils.nanTo(container.getStyle("left"), 0);
			right = NullUtils.nanTo(container.getStyle("right"), 0);
			top = NullUtils.nanTo(container.getStyle("top"), 0);
			bottom = NullUtils.nanTo(container.getStyle("bottom"), 0);
		}

		var columnsWidthTotal:Number = 0;
		var f:int = widthMap.length;
		while (--f >= 0) {
			columnsWidthTotal += widthMap[f];
		}

		measuredWidth = left + columnsBorderTotal + columnsWidthTotal + right;
		measuredHeight = top + rowBorderTotal + headerRowsHeightTotal + rowsHeightTotal + bottom;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (useExplicitSize) {
			return;
		}


	}

	/*
	width, height 가 명시적으로 지정되어 explicit size 가 활성화 되기 시작했으면
	비율치대로 움직이기 시작한다.

	그렇지 않으면 상대적인 사이즈가 지정되기 시작한다. (문제는 validate 가 되어야 한다는 것 이겠지...)
	 */

	public function SimpleGrid() {
		setStyle("skinClass", SimpleGridSkin);
	}

	//---------------------------------------------
	// commit data
	//---------------------------------------------
	protected function commit_data():void {
		createCells();
	}

	private function createCells():void {
		var datas:Array = _dataProvider.toArray();
		var data:Object;
		var columns:Vector.<SimpleGridColumn> = _columns;
		var column:SimpleGridColumn;
		var cell:ISimpleGridRenderer;

		var cells:Vector.<ISimpleGridRenderer> = new Vector.<ISimpleGridRenderer>;
		var cellGrid:Array2 = new Array2(columns.length, datas.length + 1);

		//		var skipMeasure:Boolean = canSkipMeasurement();
		//
		//		var columnWidth:Number;
		//		var headerRowHeight:int = NullUtils.nanTo(getStyle("headerRowHeight"), 30);
		//		var rowHeight:int = NullUtils.nanTo(getStyle("rowHeight"), 24);
		//		var columnBorder:int = NullUtils.nanTo(getStyle("columnBorder"), 1);
		//		var rowBorder:int = NullUtils.nanTo(getStyle("rowBorder"), 1);

		//		var nx:int = 0;
		//		var ny:int;

		var f:int = -1;
		var fmax:int = columns.length;
		var s:int;
		var smax:int;

		while (++f < fmax) {
			column = columns[f];

			cell = (column.headerCellRendererFunction !== null) ? column.headerCellRendererFunction(column) : column.headerCellRenderer.newInstance();
			cell.column = column;

			cellGrid.set(f, 0, cell);
			cells.push(cell);
			cellContainer.addElement(cell);

			s = -1;
			smax = datas.length;
			while (++s < smax) {
				data = datas[s];

				cell = (column.contentCellRendererFunction !== null) ? column.contentCellRendererFunction(column, data) : column.contentCellRenderer.newInstance();
				cell.column = column;
				cell.data = data;

				cellGrid.set(f, s + 1, cell);
				cells.push(cell);
				cellContainer.addElement(cell);
			}
		}

		this.cells = cells;
		this.cellGrid = cellGrid;
	}

	private function clearCells():void {
		if (cellContainer) {
			cellContainer.removeAllElements();
		}

		if (cells) {
			var f:int = cells.length;
			var cell:ISimpleGridRenderer;
			while (--f >= 0) {
				cell = cells[f];
				cell.dispose();
			}
			cells = null;
		}

		if (cellGrid) {
			cellGrid = null;
		}
	}
}
}
