package ssen.components.fills {

import flash.display.Graphics;

import mx.events.PropertyChangeEvent;

public class Dotted extends DottedBase {
	//---------------------------------------------
	// dotSize
	//---------------------------------------------
	private var _dotSize:int = 10;

	/** dotSize */
	[Bindable]
	public function get dotSize():int {
		return _dotSize;
	}

	public function set dotSize(value:int):void {
		var oldValue:int = _dotSize;
		_dotSize = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dotSize", oldValue, _dotSize));
		}

		invalidate_source();
	}

	//---------------------------------------------
	// dotGap
	//---------------------------------------------
	private var _dotGap:int = 10;

	/** dotGap */
	[Bindable]
	public function get dotGap():int {
		return _dotGap;
	}

	public function set dotGap(value:int):void {
		var oldValue:int = _dotGap;
		_dotGap = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dotGap", oldValue, _dotGap));
		}

		invalidate_source();
	}

	//---------------------------------------------
	// subDotSize
	//---------------------------------------------
	private var _subDotSize:int = -1;

	/** subDotSize */
	[Bindable]
	public function get subDotSize():int {
		return _subDotSize;
	}

	public function set subDotSize(value:int):void {
		var oldValue:int = _subDotSize;
		_subDotSize = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "subDotSize", oldValue, _subDotSize));
		}

		invalidate_source();
	}

	//---------------------------------------------
	// dotColor
	//---------------------------------------------
	private var _dotColor:uint = 0x000000;

	/** dotColor */
	[Bindable]
	public function get dotColor():uint {
		return _dotColor;
	}

	[Inspectable(format="Color")]
	public function set dotColor(value:uint):void {
		var oldValue:uint = _dotColor;
		_dotColor = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dotColor", oldValue, _dotColor));
		}

		invalidate_source();
	}

	//---------------------------------------------
	// dotAlpha
	//---------------------------------------------
	private var _dotAlpha:Number = 1;

	/** dotAlpha */
	[Bindable]
	[Inspectable(type="Number", minValue="0.0", maxValue="1.0")]
	public function get dotAlpha():Number {
		return _dotAlpha;
	}

	public function set dotAlpha(value:Number):void {
		var oldValue:Number = _dotAlpha;
		_dotAlpha = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dotAlpha", oldValue, _dotAlpha));
		}

		invalidate_source();
	}

	//---------------------------------------------
	// subDotColor
	//---------------------------------------------
	private var _subDotColor:uint = 0x000000;

	/** subDotColor */
	[Bindable]
	[Inspectable(format="Color")]
	public function get subDotColor():uint {
		return _subDotColor;
	}

	public function set subDotColor(value:uint):void {
		var oldValue:uint = _subDotColor;
		_subDotColor = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "subDotColor", oldValue, _subDotColor));
		}

		invalidate_source();
	}

	//---------------------------------------------
	// subDotAlpha
	//---------------------------------------------
	private var _subDotAlpha:Number = 1;

	/** subDotAlpha */
	[Bindable]
	[Inspectable(type="Number", minValue="0.0", maxValue="1.0")]
	public function get subDotAlpha():Number {
		return _subDotAlpha;
	}

	public function set subDotAlpha(value:Number):void {
		var oldValue:Number = _subDotAlpha;
		_subDotAlpha = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "subDotAlpha", oldValue, _subDotAlpha));
		}

		invalidate_source();
	}

	//==========================================================================================
	// implements
	//==========================================================================================
	override protected function drawDot(styleIndex:int, g:Graphics, x:Number, y:Number):void {
		if (_subDotSize > -1 && styleIndex === 1) {
			g.beginFill(_subDotColor, _subDotAlpha);
			g.drawCircle(x, y, _subDotSize / 2);
			g.endFill();
		} else {
			g.beginFill(_dotColor, _dotAlpha);
			g.drawCircle(x, y, _dotSize / 2);
			g.endFill();
		}
	}

	override protected function getGapSize():int {
		return _dotGap;
	}

	override protected function getDotSize():int {
		return _dotSize;
	}
}
}
