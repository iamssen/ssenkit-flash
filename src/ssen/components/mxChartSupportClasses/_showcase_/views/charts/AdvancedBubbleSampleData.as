package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import flash.events.EventDispatcher;

import mx.events.PropertyChangeEvent;

/** @private 샘플 데이터 */
public class AdvancedBubbleSampleData extends EventDispatcher implements IAdvancedBubbleData {
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

	//==========================================================================================
	// data
	//==========================================================================================
	[Bindable]
	public var xv:Number;

	[Bindable]
	public var yv:Number;

	[Bindable]
	public var rv:Number;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function AdvancedBubbleSampleData(xv:Number, yv:Number, rv:Number, selected:Boolean=false) {
		this.xv=xv;
		this.yv=yv;
		this.rv=rv;
		this.selected=selected;
	}
}
}
