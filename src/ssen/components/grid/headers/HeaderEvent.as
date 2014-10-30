package ssen.components.grid.headers {

import flash.events.Event;

import ssen.common.StringUtils;

public class HeaderEvent extends Event {
	/*
	column 재배치
	COLUMN_LAYOUT_CHANGED		-----> invalidateColumnLayout

	scroll 다시 읽기
	SCROLL						-----> invalidateScroll
	 */

	// to contents
	public static const COLUMN_LAYOUT_CHANGED:String = "columnLayoutChanged";
	public static const SCROLL:String = "scrollChanged";
	public static const COLUMN_CHANGED:String = "columnChanged";
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
