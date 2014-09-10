package ssen.components.fills {
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.events.PropertyChangeEvent;
import mx.graphics.IFill;

import ssen.common.MathUtils;

[DefaultProperty("entry")]

public class Stripe extends EventDispatcher implements IFill {
	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// entry
	//---------------------------------------------
	private var _entry:Vector.<StripeEntry>;

	/** entry */
	[Bindable]
	public function get entry():Vector.<StripeEntry> {
		return _entry;
	}

	public function set entry(value:Vector.<StripeEntry>):void {
		var oldValue:Vector.<StripeEntry> = _entry;
		_entry = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "entry", oldValue, _entry));
		}

		invalidate_source();
	}

	//---------------------------------------------
	// angle
	//---------------------------------------------
	private var _angle:int = 45;

	/** angle */
	[Bindable]
	public function get angle():int {
		return _angle;
	}

	public function set angle(value:int):void {
		var oldValue:int = _angle;
		_angle = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "angle", oldValue, _angle));
		}
	}

	//---------------------------------------------
	// translate
	//---------------------------------------------
	private var _translate:Number = 0;

	/** translate */
	[Bindable]
	public function get translate():Number {
		return _translate;
	}

	public function set translate(value:Number):void {
		var oldValue:Number = _translate;
		_translate = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "translate", oldValue, _translate));
		}
	}

	//----------------------------------------------------------------
	// variables
	//----------------------------------------------------------------
	private var source:BitmapData;

	//==========================================================================================
	// create bitmap source
	// SOMEDAY : DPI multi scale
	//==========================================================================================
	//---------------------------------------------
	// inavalidate source
	//---------------------------------------------
	private var sourceChanged:Boolean;

	final protected function invalidate_source():void {
		sourceChanged = true;
	}

	//---------------------------------------------
	// commit source
	//---------------------------------------------
	protected function commit_source():void {
		// remove bitmap source
		if (source) {
			source.dispose();
			source = null;
		}

		// create bitmap source
		var totalSize:int = getTotalSize(entry);
		var bitmap:BitmapData = new BitmapData(1, totalSize);
		var rect:Rectangle = new Rectangle(0, 0, 1, 0);
		var e:StripeEntry;

		bitmap.lock();

		var f:int = -1;
		var fmax:int = entry.length;

		while (++f < fmax) {
			e = entry[f];
			rect.height = e.size;
			bitmap.fillRect(rect, e.getARGB());
			rect.y += e.size;
		}

		bitmap.unlock();

		source = bitmap;
	}

	private function getTotalSize(entry:Vector.<StripeEntry>):int {
		var f:int = entry.length;
		var total:int = 0;
		while (--f >= 0) {
			total += entry[f].size;
		}

		return total;
	}

	//==========================================================================================
	// draw
	//==========================================================================================
	private static var mat:Matrix = new Matrix;

	public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void {
		if (sourceChanged) {
			commit_source();
			sourceChanged = false;
		}

		if (!_entry || !source) {
			return;
		}

		mat.identity();
		mat.ty = source.height * -_translate;
		mat.rotate(MathUtils.deg2rad(_angle));

		target.beginBitmapFill(source, mat, true, true);
	}

	public function end(target:Graphics):void {
		target.endFill();
	}

	//==========================================================================================
	// method
	//==========================================================================================
	public function dispose():void {
		if (source) {
			source.dispose();
			source = null;
		}
	}
}
}
