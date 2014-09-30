package ssen.components.graphics {

import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.events.PropertyChangeEvent;
import mx.graphics.IFill;

import spark.primitives.supportClasses.GraphicElement;

public class LineBox extends GraphicElement {
	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// fill
	//---------------------------------------------
	private var _fill:IFill;

	/** fill */
	[Bindable]
	public function get fill():IFill {
		return _fill;
	}

	public function set fill(value:IFill):void {
		var oldValue:IFill = _fill;
		_fill = value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "fill", oldValue, _fill));
		}
		invalidateDisplayList();
	}

	//---------------------------------------------
	// lineWeightLeft
	//---------------------------------------------
	private var _lineWeightLeft:int = 10;

	/** lineWeightLeft */
	[Bindable]
	public function get lineWeightLeft():int {
		return _lineWeightLeft;
	}

	public function set lineWeightLeft(value:int):void {
		var oldValue:int = _lineWeightLeft;
		_lineWeightLeft = value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineWeightLeft", oldValue, _lineWeightLeft));
		}
		invalidateDisplayList();
	}

	//---------------------------------------------
	// lineWeightRight
	//---------------------------------------------
	private var _lineWeightRight:int = 10;

	/** lineWeightRight */
	[Bindable]
	public function get lineWeightRight():int {
		return _lineWeightRight;
	}

	public function set lineWeightRight(value:int):void {
		var oldValue:int = _lineWeightRight;
		_lineWeightRight = value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineWeightRight", oldValue, _lineWeightRight));
		}
		invalidateDisplayList();
	}

	//---------------------------------------------
	// lineWeightTop
	//---------------------------------------------
	private var _lineWeightTop:int = 10;

	/** lineWeightTop */
	[Bindable]
	public function get lineWeightTop():int {
		return _lineWeightTop;
	}

	public function set lineWeightTop(value:int):void {
		var oldValue:int = _lineWeightTop;
		_lineWeightTop = value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineWeightTop", oldValue, _lineWeightTop));
		}
		invalidateDisplayList();
	}

	//---------------------------------------------
	// lineWeightBottom
	//---------------------------------------------
	private var _lineWeightBottom:int = 10;

	/** lineWeightBottom */
	[Bindable]
	public function get lineWeightBottom():int {
		return _lineWeightBottom;
	}

	public function set lineWeightBottom(value:int):void {
		var oldValue:int = _lineWeightBottom;
		_lineWeightBottom = value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineWeightBottom", oldValue, _lineWeightBottom));
		}
		invalidateDisplayList();
	}

	//==========================================================================================
	// draw
	//==========================================================================================
	/** @inheritDoc */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		if (!drawnDisplayObject || !(drawnDisplayObject is Sprite)) {
			return;
		}

		var dx:Number = drawX;
		var dy:Number = drawY;

		var g:Graphics = (drawnDisplayObject as Sprite).graphics;
		var outerRect:Rectangle = new Rectangle(dx, dy, unscaledWidth, unscaledHeight);
		var outerPoint:Point = new Point(dx, dy);
		var innerRect:Rectangle = new Rectangle(dx + _lineWeightLeft,
						dy + _lineWeightTop,
						unscaledWidth - _lineWeightLeft - _lineWeightRight,
						unscaledHeight - _lineWeightTop - _lineWeightBottom);

		g.lineStyle(0, 0, 0);

		_fill.begin(g, outerRect, outerPoint);
		g.drawRect(outerRect.x, outerRect.y, outerRect.width, outerRect.height);
		g.drawRect(innerRect.x, innerRect.y, innerRect.width, innerRect.height);
		_fill.end(g);
	}

}
}
