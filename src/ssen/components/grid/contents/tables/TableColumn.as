package ssen.components.grid.contents.tables {
import mx.core.IFactory;

[DefaultProperty("itemRenderer")]

public class TableColumn {
	//==========================================================================================
	// internal
	//==========================================================================================
	internal var table:Table;

	//==========================================================================================
	// fields
	//==========================================================================================
	//---------------------------------------------
	// dataField
	//---------------------------------------------
	private var _dataField:String;

	/** dataField */
	public function get dataField():String {
		return _dataField;
	}

	public function set dataField(value:String):void {
		_dataField = value;
		if (table) table.refreshCellContents(this);
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
	// itemRenderer
	//---------------------------------------------
	private var _itemRenderer:IFactory;

	/** itemRenderer */
	public function get itemRenderer():IFactory {
		return _itemRenderer;
	}

	public function set itemRenderer(value:IFactory):void {
		_itemRenderer = value;
		if (table) table.refreshCellContents(this);
	}


	//---------------------------------------------
	// columnBackgroundColor
	//---------------------------------------------
	private var _columnBackgroundColor:uint = 0xffffff;

	/** columnBackgroundColor */
	public function get columnBackgroundColor():uint {
		return _columnBackgroundColor;
	}

	[Inspectable(format="Color")]
	public function set columnBackgroundColor(value:uint):void {
		_columnBackgroundColor = value;
		if (table) table.refreshCellStyles(this);
	}

	//---------------------------------------------
	// columnBackgroundBlendMode
	//---------------------------------------------
	private var _columnBackgroundBlendMode:String = "multiply";

	/** columnBackgroundBlendMode */
	public function get columnBackgroundBlendMode():String {
		return _columnBackgroundBlendMode;
	}

	[Inspectable(type="Array", enumeration="overwrite,multiply", defaultValue="overwrite")]
	public function set columnBackgroundBlendMode(value:String):void {
		_columnBackgroundBlendMode = value;
		if (table) table.refreshCellStyles(this);
	}

}
}
