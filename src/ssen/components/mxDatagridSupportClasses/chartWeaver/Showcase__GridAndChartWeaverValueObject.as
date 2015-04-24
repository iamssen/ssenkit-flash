package ssen.components.mxDatagridSupportClasses.chartWeaver {
import flash.events.EventDispatcher;

import mx.events.PropertyChangeEvent;

public class Showcase__GridAndChartWeaverValueObject extends EventDispatcher implements IGridAndChartWeaverChartValueObject {
	//---------------------------------------------
	// horizontalPosition
	//---------------------------------------------
	private var _horizontalPosition:Number=0;

	/** horizontalPosition */
	[Bindable]
	public function get horizontalPosition():Number {
		return _horizontalPosition;
	}

	public function set horizontalPosition(value:Number):void {
		var oldValue:Number=_horizontalPosition;
		_horizontalPosition=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalPosition", oldValue, _horizontalPosition));
		}
	}

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

	//==========================================================================================
	// values
	//==========================================================================================
	[Bindable]
	public var value1:Number;

	[Bindable]
	public var value2:Number;

	[Bindable]
	public var value3:Number;

	[Bindable]
	public var label:String;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function Showcase__GridAndChartWeaverValueObject(hpos:Number, l:String, v1:Number, v2:Number=0, v3:Number=0) {
		horizontalPosition=hpos;
		value1=v1;
		value2=v2;
		value3=v3;
		label=l;
	}
}
}
