package ssen.components.grid.contents.tables {
import ssen.common.StringUtils;

public class Row {
	// data
	public var data:Object;

	// chain
	public var prev:Row;
	public var next:Row;

	// grid logical positions
	public var indent:int;
	public var rowIndex:int;
	public var startRowIndex:int;
	public var endRowIndex:int;

	public function getStartRow():Row {
		var r:Row = this;
		while(r.rowIndex !== startRowIndex) {
			r = r.prev;
		}
		return r;
	}

	public function getEndRow():Row {
		var r:Row = this;
		while(r.rowIndex !== endRowIndex) {
			r = r.next;
		}
		return r;
	}

	public var hasChildren:Boolean;

	// row physical position
	public var y:Number;
	public var height:int;

	// row style
	public var backgroundColor:uint;

	public function toString():String {
		return StringUtils.formatToString("{0}{1} ({2}/{3}/{4})", StringUtils.multiply("+", indent), data["category"], rowIndex, startRowIndex, endRowIndex);
		//		return StringUtils.formatToString("[Row]");
	}
}
}
