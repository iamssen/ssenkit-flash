package ssen.flexkit.components.grid {
import flash.events.Event;

public class GridHeaderEvent extends Event {
	public static const COMPUTED_WIDTH_LIST:String="computedWidthList";
	public static const CHANGED_COLUMN:String="changedColumn";

	public function GridHeaderEvent(type:String) {
		super(type);
	}
}
}
