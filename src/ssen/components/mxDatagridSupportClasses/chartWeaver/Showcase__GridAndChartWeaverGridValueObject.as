package ssen.components.mxDatagridSupportClasses.chartWeaver {
import flash.events.EventDispatcher;

import mx.events.PropertyChangeEvent;

public dynamic class Showcase__GridAndChartWeaverGridValueObject extends EventDispatcher implements IGridAndChartWeaverGridValueObject {
	//---------------------------------------------
	// highlighted
	//---------------------------------------------
	private var _highlighted:Boolean;

	/** highlighted */
	[Bindable]
	public function get highlighted():Boolean {
		return _highlighted;
	}

	public function set highlighted(value:Boolean):void {
		var oldValue:Boolean=_highlighted;
		_highlighted=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "highlighted", oldValue, _highlighted));
		}
	}

	//---------------------------------------------
	// highlightedField
	//---------------------------------------------
	private var _highlightedField:String;

	/** highlightedField */
	[Bindable]
	public function get highlightedField():String {
		return _highlightedField;
	}

	public function set highlightedField(value:String):void {
		var oldValue:String=_highlightedField;
		_highlightedField=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "highlightedField", oldValue, _highlightedField));
		}
	}

	[Bindable]
	public var A:Number;
	[Bindable]
	public var B:Number;
	[Bindable]
	public var C:Number;
	[Bindable]
	public var D:Number;
	[Bindable]
	public var E:Number;
	[Bindable]
	public var F:Number;
	[Bindable]
	public var G:Number;
}
}
