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
}
}
