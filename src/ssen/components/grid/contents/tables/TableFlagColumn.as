package ssen.components.grid.contents.tables {
public class TableFlagColumn extends TableColumn {
	//---------------------------------------------
	// mergeDirectionField
	//---------------------------------------------
	private var _mergeDirectionField:String;

	/** mergeDirectionField */
	public function get mergeDirectionField():String {
		return _mergeDirectionField;
	}

	public function set mergeDirectionField(value:String):void {
		_mergeDirectionField = value;
		if (table) table.refreshRows();
	}

	//---------------------------------------------
	// rowHeightField
	//---------------------------------------------
	private var _rowHeightField:String;

	/** rowHeightField */
	public function get rowHeightField():String {
		return _rowHeightField;
	}

	public function set rowHeightField(value:String):void {
		_rowHeightField = value;
		if (table) table.refreshRows();
	}

	//---------------------------------------------
	// rowBackgroundColorField
	//---------------------------------------------
	private var _rowBackgroundColorField:String;

	/** rowBackgroundColorField */
	public function get rowBackgroundColorField():String {
		return _rowBackgroundColorField;
	}

	public function set rowBackgroundColorField(value:String):void {
		_rowBackgroundColorField = value;
		if (table) table.refreshCellStyles(this);
	}

	//---------------------------------------------
	// rowBackgroundAlphaField
	//---------------------------------------------
	private var _rowBackgroundAlphaField:String;

	/** rowBackgroundAlphaField */
	public function get rowBackgroundAlphaField():String {
		return _rowBackgroundAlphaField;
	}

	public function set rowBackgroundAlphaField(value:String):void {
		_rowBackgroundAlphaField = value;
		if (table) table.refreshCellStyles(this);
	}
}
}
