package ssen.components.grid.headers {

import flash.events.Event;

public class HeaderEvent extends Event {
	public static const COLUMN_LAYOUT_CHANGED:String = "columnLayoutChanged";
	public static const COLUMN_CHANGED:String = "columnChanged";

	public function HeaderEvent(type:String) {
		super(type);
	}

	override public function clone():Event {
		var evt:HeaderEvent=new HeaderEvent(type);
		return evt;
	}
}
}
