package ssen.components.grid.headers {
import flash.events.Event;

public class HeaderEvents extends Event {
	public static const COMPUTED_WIDTH_LIST:String = "computedWidthList";

	public function HeaderEvents(type:String) {
		super(type);
	}
}
}
