package ssen.components.grid.headers {

import flash.events.Event;

import ssen.common.StringUtils;

public class HeaderEvent extends Event {
	public static const COLUMN_LAYOUT_CHANGED:String = "columnLayoutChanged";
	public static const COLUMN_CHANGED:String = "columnChanged";
	public static const SCROLL_CHANGED:String = "scrollChanged";
	public static const RENDER_COMPLETE:String = "renderComplete";

	public function HeaderEvent(type:String) {
		super(type);
	}

	override public function clone():Event {
		var evt:HeaderEvent = new HeaderEvent(type);
		return evt;
	}

	override public function toString():String {
		return StringUtils.formatToString("[HeaderEvent type={0}]", type);
	}
}
}
