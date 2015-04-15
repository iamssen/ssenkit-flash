package ssen.components.grid.contents.tables {
import mx.core.IFactory;

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
	// columnBackgroundAlpha
	//---------------------------------------------
	private var _columnBackgroundAlpha:Number = 0;

	/** columnBackgroundAlpha */
	public function get columnBackgroundAlpha():Number {
		return _columnBackgroundAlpha;
	}

	[Inspectable(format="Number")]
	public function set columnBackgroundAlpha(value:Number):void {
		_columnBackgroundAlpha = value;
		if (table) table.refreshCellStyles(this);
	}

	//---------------------------------------------
	// columnBackgroundBlendMode
	//---------------------------------------------
	private var _columnBackgroundBlendMode:String = "normal";

	/** columnBackgroundBlendMode */
	public function get columnBackgroundBlendMode():String {
		return _columnBackgroundBlendMode;
	}

	[Inspectable(type="Array", enumeration="normal,multiply", defaultValue="normal")]
	public function set columnBackgroundBlendMode(value:String):void {
		_columnBackgroundBlendMode = value;
		if (table) table.refreshCellStyles(this);
	}

}
}
