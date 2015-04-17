package ssen.components.chart.pola.pieAxis {
import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.events.EventDispatcher;

import mx.collections.IList;
import mx.core.UIComponent;

import ssen.common.MathUtils;

import ssen.common.MathUtils;

import ssen.common.MathUtils;

import ssen.common.MathUtils;
import ssen.common.NullUtils;
import ssen.components.chart.pola.IPolaAxis;
import ssen.components.chart.pola.IPolaPointRenderer;
import ssen.components.chart.pola.PolaChart;
import ssen.drawing.PathMaker;

public class PieSeries extends EventDispatcher implements IPieElement {
	//==========================================================================================
	// properties
	//==========================================================================================
	public var dataField:String;
	public var fillField:String;
	public var strokeField:String;

	public var outerRadiusRatio:Number = 1;
	public var innerRadiusRatio:Number = 0;
	public var axis:IPolaAxis;

	//---------------------------------------------
	// maximum
	//---------------------------------------------
	private var _maximum:Number;

	/** maximum */
	public function get maximum():Number {
		return _maximum;
	}

	private function set_maximum(value:Number):void {
		_maximum = value;
	}

	//==========================================================================================
	// compute
	//==========================================================================================
	public function computeMaximumValue(dataProvider:IList):Number {
		return NaN;
	}

	//==========================================================================================
	// render
	//==========================================================================================
	private var display:UIComponent;

	public function PieSeries() {
		display = new UIComponent;
	}

	public function render(axis:PieAxis, chart:PolaChart, targetContainer:UIComponent):void {
		//----------------------------------------------------------------
		// init display
		//----------------------------------------------------------------
		targetContainer.addChild(display);
		clearContainer(display);

		var g:Graphics = display.graphics;

		//----------------------------------------------------------------
		// compute
		//----------------------------------------------------------------
		var pies:Pies = compute(axis, chart);

		//----------------------------------------------------------------
		// coordinate info
		//----------------------------------------------------------------
		var isDonut:Boolean = innerRadiusRatio > 0;
		var outerRadius:Number = chart.computedContentRadius * axis.drawRadiusRatio * outerRadiusRatio;
		var innerRadius:Number = chart.computedContentRadius * axis.drawRadiusRatio * innerRadiusRatio;
		//		var radiusRatio:Number = (isNaN(outerRadiusRatio)) ? axis.drawRadiusRatio : outerRadiusRatio;
		//		var radius:Number = chart.computedContentRadius * radiusRatio;

		//----------------------------------------------------------------
		// test
		//----------------------------------------------------------------
		g.clear();

		g.beginFill(0x000000, 0.01);
		g.drawCircle(chart.computedCenterX, chart.computedCenterY, outerRadius);
		if (isDonut) g.drawCircle(chart.computedCenterX, chart.computedCenterY, innerRadius);
		g.endFill();

		var f:int = -1;
		var fmax:int = pies.list.length;
		var pie:Pie;
		var path:GraphicsPath;
		var startDeg:Number;
		var endDeg:Number;
		while (++f < fmax) {
			pie = pies.list[f];
			startDeg = pie.startDeg;
			endDeg = pie.endDeg;
			path = PathMaker.donut(chart.computedCenterX, chart.computedCenterY, outerRadius, innerRadius, startDeg, endDeg);

			g.beginFill(MathUtils.rand(0, 0xffffff), 0.7);
			g.drawPath(path.commands, path.data, path.winding);
			g.endFill();
		}
	}

	private function compute(axis:PieAxis, chart:PolaChart):Pies {
		var pies:Pies = new Pies;
		var pie:Pie;

		var f:int = -1;
		var fmax:int = axis.dataProvider.length;

		var source:Object;
		var value:Number;

		while (++f < fmax) {
			source = axis.dataProvider.getItemAt(f);
			value = NullUtils.nanTo(source[dataField], 0);

			if (value > 0) {
				pie = new Pie;
				pie.value = value;

				pies.list.push(pie);
				pies.total += value;
			}
		}

		var startDeg:Number = MathUtils.rotate(axis.drawStartAngle);
		var endDeg:Number = MathUtils.rotate(axis.drawEndAngle);
		if (startDeg > endDeg) {
			var cacheDeg:Number = endDeg;
			endDeg = startDeg;
			startDeg = cacheDeg;
		}
		var totalDeg:Number = endDeg - startDeg;

		var nextRatio:Number = 0;
		var nextDeg:Number = startDeg;

		f = -1;
		fmax = pies.list.length;
		while (++f < fmax) {
			pie = pies.list[f];
			pie.ratioValue = pie.value / pies.total;

			pie.startRatio = nextRatio;
			nextRatio += pie.ratioValue;
			pie.endRatio = nextRatio;

			pie.startDeg = MathUtils.rotate(nextDeg, -90);
			nextDeg += pie.ratioValue * totalDeg;
			pie.endDeg = MathUtils.rotate(nextDeg, -90);

			//			pie.startDeg = nextDeg;
			//			nextDeg += pie.ratioValue * totalDeg;
			//			pie.endDeg = nextDeg;
		}

		return pies;
	}

	private static function clearContainer(display:UIComponent):void {
		display.graphics.clear();

		var f:int = display.numChildren;
		while (--f >= 0) {
			display.removeChild(display.getChildAt(f));

			if (display is IPolaPointRenderer) {
				IPolaPointRenderer(display).dispose();
			}
		}
	}
}
}

class Pies {
	public var list:Vector.<Pie> = new Vector.<Pie>;
	public var total:Number = 0;
}

class Pie {
	public var value:Number;
	public var ratioValue:Number;
	public var startRatio:Number;
	public var endRatio:Number;
	public var startDeg:Number;
	public var endDeg:Number;
}