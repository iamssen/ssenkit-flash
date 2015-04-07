package ssen.components.mxChartSupportClasses._showcase_.viewmodels {
import flash.events.EventDispatcher;

import mx.events.PropertyChangeEvent;

import ssen.common.MathUtils;
import ssen.components.mxChartSupportClasses._showcase_.views.charts.IAdvancedBubbleData;
import ssen.datakit.ds.RandomDataCollection;

public class ChartVO extends EventDispatcher implements IAdvancedBubbleData {
	public var company:String="";
	public var product:String="";
	public var price:Number=0;
	public var sales:Number=0;
	public var stock:Number=0;

	public function setRandom():void {
		switch (MathUtils.rand(0, 3)) {
			case 0:
				company="Apple";
				product=new RandomDataCollection(["iPhone", "iPad"]).get() + MathUtils.rand(2, 5) + new RandomDataCollection(["s", ""]).get();
				break;
			case 1:
				company="Samsung";
				product=new RandomDataCollection(["Galaxy", "Galaxy Note", "Galaxy Tab"]).get() + MathUtils.rand(2, 6) + new RandomDataCollection([" Active", " Mini", ""]);
				break;
			case 2:
				company="Amazon";
				product=new RandomDataCollection(["Fire", "Kindle"]).get() + MathUtils.rand(1, 10);
				break;
			default:
				company="Microsoft";
				product=new RandomDataCollection(["Surface", "Surface Pro", "Windows Phone"]).get() + MathUtils.rand(1, 5);
				break;
		}

		price=MathUtils.rand(100, 10000);
		sales=MathUtils.rand(10000, 100000);
		stock=MathUtils.rand(1, 100);
	}


	//---------------------------------------------
	// selected
	//---------------------------------------------
	private var _selected:Boolean;

	/** selected */
	[Bindable]
	public function get selected():Boolean {
		return _selected;
	}

	public function set selected(value:Boolean):void {
		var oldValue:Boolean=_selected;
		_selected=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "selected", oldValue, _selected));
		}
	}

}
}
