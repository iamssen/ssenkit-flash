package ssen.components.chart.pola.pieAxis {
import flash.events.Event;

import mx.utils.StringUtil;

public class PieSeriesEvent extends Event {
	public static const WEDGE_CLICK:String = "wedgeClick";

	public var pie:PieSeriesWedge;
	public var renderer:IPieSeriesWedgeRenderer;

	public function PieSeriesEvent(eventType:String, pie:PieSeriesWedge, renderer:IPieSeriesWedgeRenderer = null) {
		super(eventType);

		this.pie = pie;
		this.renderer = renderer;
	}

	override public function clone():Event {
		return new PieSeriesEvent(type, pie, renderer);
	}

	override public function toString():String {
		return StringUtil.substitute("[PieSeriesEvent pie={0}]", pie);
	}
}
}
