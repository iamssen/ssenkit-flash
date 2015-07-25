package ssen.components.mxDatagridSupportClasses.chartWeaver {
import flash.events.Event;

public class GridAndChartWeaverEvent extends Event {
	public static const COLUMN_HIGHLIGHTED:String="columnHighlighted";

	public var columnIndex:int;
	public var column:String;

	public function GridAndChartWeaverEvent(type:String) {
		super(type);
	}

	override public function clone():Event {
		var evt:GridAndChartWeaverEvent=new GridAndChartWeaverEvent(type);
		evt.column=column;
		evt.columnIndex=columnIndex;
		return evt;
	}


}
}
