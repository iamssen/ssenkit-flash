package ssen.flexkit.components.grid.editors {
import spark.components.gridClasses.GridColumn;

public class GridEditorHelper {
	/** ← 방향의 cell 로 이동 */
	public static function moveToPrevColumnCell(column:GridColumn, rowIndex:int):Boolean {
		var c:int=column.columnIndex;
		var r:int=rowIndex;
		var to:GridColumn;

		while (--c >= 0) {
			to=column.grid.columns.getItemAt(c) as GridColumn;
			if (isEditableColumn(to)) {
				moveToCell(column, to, r, c);
				return true;
			}
		}

		return false;
	}

	/** → 방향의 cell 로 이동 */
	public static function moveToNextColumnCell(column:GridColumn, rowIndex:int):Boolean {
		var c:int=column.columnIndex;
		var r:int=rowIndex;
		var cmax:int=column.grid.columns.length;
		var to:GridColumn;

		while (++c < cmax) {
			to=column.grid.columns.getItemAt(c) as GridColumn;
			if (isEditableColumn(to)) {
				moveToCell(column, to, r, c);
				return true;
			}
		}

		return false;
	}

	/** ↑ 방향의 cell 로 이동 */ 
	public static function moveToPrevRowCell(column:GridColumn, rowIndex:int):Boolean {
		var c:int=column.columnIndex;
		var r:int=rowIndex;
		var to:GridColumn;

		if (r > 0) {
			moveToCell(column, column, r - 1, c);
			return true;
		}

		return false;
	}

	/** ↓ 방향의 cell 로 이동 */
	public static function moveToNextRowCell(column:GridColumn, rowIndex:int):Boolean {
		var c:int=column.columnIndex;
		var r:int=rowIndex;
		var rmax:int=column.grid.dataProvider.length;

		if (r < rmax - 1) {
			moveToCell(column, column, r + 1, c);
			return true;
		}

		return false;
	}

	/** edit 가능한 column 인지 확인 */ 
	public static function isEditableColumn(column:GridColumn):Boolean {
		return column.visible || (column.editable || column.rendererIsEditable);
	}

	/** cell 로 이동 */
	public static function moveToCell(column:GridColumn, toColumn:GridColumn, rowIndex:int, columnIndex:int):void {
		column.grid.selectedIndex=rowIndex;
		column.grid.caretRowIndex=rowIndex;
		column.grid.dataGrid.startItemEditorSession(rowIndex, columnIndex);
	}
}
}
