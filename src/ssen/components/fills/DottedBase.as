package ssen.components.fills {

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.EventDispatcher;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.events.PropertyChangeEvent;
import mx.graphics.IFill;

public class DottedBase extends EventDispatcher implements IFill {
	//---------------------------------------------
	// backgroundColor
	//---------------------------------------------
	private var _backgroundColor:uint = 0xffffff;

	/** backgroundColor */
	[Bindable]
	[Inspectable(format="Color")]
	public function get backgroundColor():uint {
		return _backgroundColor;
	}

	public function set backgroundColor(value:uint):void {
		var oldValue:uint = _backgroundColor;
		_backgroundColor = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "backgroundColor", oldValue, _backgroundColor));
		}

		invalidate_source();
	}

	//---------------------------------------------
	// backgroundAlpha
	//---------------------------------------------
	private var _backgroundAlpha:Number = 1;

	/** backgroundAlpha */
	[Bindable]
	[Inspectable(type="Number", minValue="0.0", maxValue="1.0")]
	public function get backgroundAlpha():Number {
		return _backgroundAlpha;
	}

	public function set backgroundAlpha(value:Number):void {
		var oldValue:Number = _backgroundAlpha;
		_backgroundAlpha = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "backgroundAlpha", oldValue, _backgroundAlpha));
		}

		invalidate_source();
	}

	//==========================================================================================
	// create bitmap source
	// TODO DPI multiple scale
	//==========================================================================================
	//----------------------------------------------------------------
	// variables
	//----------------------------------------------------------------
	private var source:BitmapData;

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
		var dot:int = getDotSize();
		var gap:int = getGapSize();
		var size:int = dot + gap;

		var canvas:Shape = new Shape;
		var graphics:Graphics = canvas.graphics;

		graphics.beginFill(_backgroundColor, _backgroundAlpha);
		graphics.drawRect(-size, -size, size * 3, size * 3);
		graphics.endFill();

		drawDot(0, graphics, 0, 0);
		drawDot(0, graphics, size, 0);
		drawDot(0, graphics, 0, size);
		drawDot(0, graphics, size, size);
		drawDot(1, graphics, size / 2, size / 2);

		//---------------------------------------------
		// rasterize
		//---------------------------------------------
		var bitmap:BitmapData = new BitmapData(size, size);
		bitmap.lock();
		bitmap.draw(canvas);
		bitmap.unlock();

		source = bitmap;
	}

	//==========================================================================================
	// draw abstract
	//==========================================================================================
	protected function drawDot(styleIndex:int, g:Graphics, x:Number, y:Number):void {
		throw new Error("not implemented");
	}

	protected function getGapSize():int {
		throw new Error("not implemented");
	}

	protected function getDotSize():int {
		throw new Error("not implemented");
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

		if (!source) {
			return;
		}

		mat.identity();
		mat.tx = targetBounds.x;
		mat.ty = targetBounds.y;

		target.beginBitmapFill(source, mat);
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
