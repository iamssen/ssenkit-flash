package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.geom.Rectangle;

import mx.events.PropertyChangeEvent;
import mx.graphics.IFill;

public class StackedColumnSetLine extends StackedColumnSeriesRenderBaseElement {
	//---------------------------------------------
	// lineColor
	//---------------------------------------------
	private var _lineColor:uint = 0;

	/** lineColor */
	[Bindable]
	public function get lineColor():uint {
		return _lineColor;
	}

	public function set lineColor(value:uint):void {
		var oldValue:uint = _lineColor;
		_lineColor = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineColor", oldValue, _lineColor));
		}

		invalidateDisplayList();
	}

	//---------------------------------------------
	// lineAlpha
	//---------------------------------------------
	private var _lineAlpha:Number = 1;

	/** lineAlpha */
	[Bindable]
	public function get lineAlpha():Number {
		return _lineAlpha;
	}

	public function set lineAlpha(value:Number):void {
		var oldValue:Number = _lineAlpha;
		_lineAlpha = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "lineAlpha", oldValue, _lineAlpha));
		}
	}

	//==========================================================================================
	// implements abstract methods
	//==========================================================================================
	/** @private */
	override protected function drawCenterOfColumns(x:int, data1:Object, data2:Object):void {
	}

	/** @private */
	override protected function drawColumnOverHead(rect:Rectangle, data:Object):void {
	}

	/** @private */
	override protected function drawWireOfColumnStacks(x:int, y:int, data1:Object, data2:Object, v1:Number, v2:Number, columnRect1:Rectangle, columnRect2:Rectangle,
													   dataField:String, fill:IFill):void {
		graphics.lineStyle(1, _lineColor, _lineAlpha, true);
		graphics.beginFill(0, 0);
		graphics.moveTo(columnRect1.x + columnRect1.width, getVerticalPosition(v1));
		graphics.lineTo(columnRect2.x, getVerticalPosition(v2));
		graphics.endFill();
		graphics.lineStyle(0, 0, 0);
	}

	/** @private */
	override protected function begin():void {
		graphics.clear();
	}
}
}
