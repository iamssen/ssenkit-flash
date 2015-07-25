package ssen.components.mxChartSupportClasses.axisRenderers {
import flash.geom.Rectangle;

import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.IAxisRenderer;
import mx.core.UIComponent;

public class InvisibleHorizontalAxisRenderer extends UIComponent implements IAxisRenderer {
	public function InvisibleHorizontalAxisRenderer() {
		visible = false;
	}

	//==========================================================================================
	// implements IAxisRenderer
	//==========================================================================================
	private var _axis:IAxis;
	private var _gutters:Rectangle;
	private var _heightLimit:Number;
	private var _horizontal:Boolean;
	private var _placement:String;

	//----------------------------------------------------------------
	//
	//----------------------------------------------------------------
	public function get minorTicks():Array {
		return [0, 0.5, 1];
	}

	public function set otherAxes(value:Array):void {
		//		trace("HorizontalCategoryAxisRenderer.otherAxes(", value, ")");
	}

	public function get ticks():Array {
		return [0.25, 0.75];
	}

	public function adjustGutters(workingGutters:Rectangle, adjustable:Object):Rectangle {
		var gutters:Rectangle = workingGutters.clone();
		gutters.bottom = 0;
		this.gutters = gutters;
		return gutters;
	}

	public function chartStateChanged(oldState:uint, v:uint):void {
		//		trace("HorizontalCategoryAxisRenderer.chartStateChanged(", oldState, v, ")");
	}

	//----------------------------------------------------------------
	// simple getter / setters
	//----------------------------------------------------------------
	public function get axis():IAxis {
		return _axis;
	}

	public function set axis(value:IAxis):void {
		//		trace("HorizontalCategoryAxisRenderer.axis(", value, ")");
		_axis = value;
		//		invalidateDisplayList();
	}

	public function get gutters():Rectangle {
		return _gutters;
	}

	public function set gutters(value:Rectangle):void {
		_gutters = value;
		invalidateDisplayList();
	}

	public function set heightLimit(value:Number):void {
		_heightLimit = value;
		//		invalidateDisplayList();
	}

	public function get heightLimit():Number {
		return _heightLimit;
	}

	public function get horizontal():Boolean {
		return _horizontal;
	}

	public function set horizontal(value:Boolean):void {
		_horizontal = value;
		//		invalidateDisplayList();
	}

	public function get placement():String {
		return _placement;
	}

	public function set placement(value:String):void {
		_placement = value;
		//		invalidateDisplayList();
	}


	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
	}
}
}
