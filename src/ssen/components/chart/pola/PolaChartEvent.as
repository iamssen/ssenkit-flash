package ssen.components.chart.pola {

import flash.events.Event;

[Deprecated(message="Remove when end of project")]

public class PolaChartEvent extends Event {
	public static const ITEM_CLICK:String = "itemClick";

	public var item:Object;

	public function PolaChartEvent(type:String) {
		super(type);
	}

	override public function clone():Event {
		var evt:PolaChartEvent = new PolaChartEvent(type);
		evt.item = item;
		return evt;
	}
}
}
