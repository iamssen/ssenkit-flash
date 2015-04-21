package ssen.components.chart.pola.pieAxis {
import com.greensock.easing.Quad;

import flash.display.Graphics;
import flash.events.EventDispatcher;

import mx.collections.IList;
import mx.core.UIComponent;
import mx.graphics.IFill;
import mx.graphics.SolidColor;

import ssen.common.DisposableUtils;
import ssen.common.MathUtils;
import ssen.common.NullUtils;
import ssen.components.animate.AnimationTrack;
import ssen.components.chart.pola.IPolaAxis;
import ssen.components.chart.pola.PolaChart;

public class PieSeries extends EventDispatcher implements IPieElement {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// chart field
	//----------------------------------------------------------------
	public var dataField:String;
	public var axis:IPolaAxis;
	//----------------------------------------------------------------
	// style
	//----------------------------------------------------------------
	public var outerRadiusRatio:Number = 1;
	public var innerRadiusRatio:Number = 0;
	public var fills:Vector.<IFill> = new <IFill>[new SolidColor(0xFF9480), new SolidColor(0xE85349), new SolidColor(0xFFEFA3), new SolidColor(0x00A178), new SolidColor(0x2C656B), new SolidColor(0x225F50), new SolidColor(0xD3F7EF), new SolidColor(0x4EDEBB), new SolidColor(0x386A5E), new SolidColor(0x308872)];
	public var fillField:String;
	public var strokeField:String;
	//----------------------------------------------------------------
	// animate
	//----------------------------------------------------------------
	public var animationTrack:AnimationTrack = new AnimationTrack(0, 1, Quad.easeOut);
	private var lastAnimationTime:Number;

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

	public function render(axis:PieAxis, chart:PolaChart, targetContainer:UIComponent, animationTime:Number):void {
		//----------------------------------------------------------------
		// time tracking
		//----------------------------------------------------------------
		animationTime = animationTrack.getTime(animationTime);

		if (isNaN(animationTime)) {
			display.alpha = 0;
			return;
		} else if (animationTime === lastAnimationTime) {
			return;
		}

		lastAnimationTime = animationTime;

		//		trace("PieSeries.render()", animationTime);

		//----------------------------------------------------------------
		// init display
		//----------------------------------------------------------------
		targetContainer.addChild(display);
		DisposableUtils.disposeDisplayContainer(display);

		var g:Graphics = display.graphics;

		//----------------------------------------------------------------
		// compute
		//----------------------------------------------------------------
		var pies:Pies = compute(axis, chart);

		//----------------------------------------------------------------
		// coordinate info
		//----------------------------------------------------------------
		var outerRadiusRatio:Number = this.outerRadiusRatio - (this.outerRadiusRatio * (1 - animationTime));
		var innerRadiusRatio:Number = this.innerRadiusRatio * animationTime;
		var isDonut:Boolean = innerRadiusRatio > 0;
		var outerRadius:Number = chart.computedContentRadius * axis.drawRadiusRatio * outerRadiusRatio;
		var innerRadius:Number = chart.computedContentRadius * axis.drawRadiusRatio * innerRadiusRatio;
		//		var radiusRatio:Number = (isNaN(outerRadiusRatio)) ? axis.drawRadiusRatio : outerRadiusRatio;
		//		var radius:Number = chart.computedContentRadius * radiusRatio;

		display.alpha = animationTime;

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
		var renderer:PieSeriesWedgeRenderer;

		while (++f < fmax) {
			pie = pies.list[f];

			renderer = new PieSeriesWedgeRenderer;
			renderer.render(outerRadius, innerRadius, pie, fills[f % fills.length], f / fmax, animationTime);
			renderer.x = chart.computedCenterX;
			renderer.y = chart.computedCenterY;

			display.addChild(renderer);
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
}
}

import ssen.components.chart.pola.pieAxis.Pie;

class Pies {
	public var list:Vector.<Pie> = new Vector.<Pie>;
	public var total:Number = 0;
}