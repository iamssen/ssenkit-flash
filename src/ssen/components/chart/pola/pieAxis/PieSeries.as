package ssen.components.chart.pola.pieAxis {
import com.greensock.easing.Quad;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import mx.collections.IList;
import mx.core.IFactory;
import mx.core.UIComponent;
import mx.graphics.IFill;
import mx.graphics.SolidColor;

import ssen.common.DisposableUtils;
import ssen.common.MathUtils;
import ssen.common.NullUtils;
import ssen.components.animate.AnimationTrack;
import ssen.components.chart.pola.IPolaAxis;
import ssen.components.chart.pola.PolaChart;
import ssen.components.tooltips.ToolTipProvider;

[DefaultProperty("wedgeRenderer")]

[Event(type="ssen.components.chart.pola.pieAxis.PieSeriesEvent", name="wedgeClick")]

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
	public var fillFunction:Function;
	//	public var fillField:String;
	//	public var showDataTip:Boolean;
	public var buttonMode:Boolean;

	public var toolTipProvider:ToolTipProvider;

	//---------------------------------------------
	// wedgeRenderer
	//---------------------------------------------
	private var _wedgeRenderer:IFactory; // of IWedgeRenderer

	/** wedgeRenderer */
	public function get wedgeRenderer():IFactory {
		return _wedgeRenderer || PieSeriesWedgeRenderer.factory;
	}

	public function set wedgeRenderer(value:IFactory):void {
		_wedgeRenderer = value;
	}

	//----------------------------------------------------------------
	// animate
	//----------------------------------------------------------------
	public var animationTrack:AnimationTrack = new AnimationTrack(0, 1, Quad.easeOut);
	private var lastAnimationRatio:Number;

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

	public function render(axis:PieAxis, chart:PolaChart, targetContainer:UIComponent, animationRatio:Number):void {
		//----------------------------------------------------------------
		// time tracking
		//----------------------------------------------------------------
		animationRatio = animationTrack.getTime(animationRatio);

		if (isNaN(animationRatio)) {
			display.alpha = 0;
			return;
		} else if (animationRatio === lastAnimationRatio) {
			return;
		}

		lastAnimationRatio = animationRatio;

		//		trace("PieSeries.render()", animationTime);

		//----------------------------------------------------------------
		// init display
		//----------------------------------------------------------------
		targetContainer.addChild(display);
		DisposableUtils.disposeDisplayContainer(display);

		var g:Graphics = display.graphics;

		if (!axis || !axis.dataProvider) return;

		//----------------------------------------------------------------
		// compute
		//----------------------------------------------------------------
		var pies:Pies = compute(axis, chart);

		//----------------------------------------------------------------
		// coordinate info
		//----------------------------------------------------------------
		var outerRadiusRatio:Number = this.outerRadiusRatio - (this.outerRadiusRatio * (1 - animationRatio));
		var innerRadiusRatio:Number = this.innerRadiusRatio * animationRatio;
		var isDonut:Boolean = innerRadiusRatio > 0;
		var outerRadius:Number = chart.computedContentRadius * axis.drawRadiusRatio * outerRadiusRatio;
		var innerRadius:Number = chart.computedContentRadius * axis.drawRadiusRatio * innerRadiusRatio;
		//		var radiusRatio:Number = (isNaN(outerRadiusRatio)) ? axis.drawRadiusRatio : outerRadiusRatio;
		//		var radius:Number = chart.computedContentRadius * radiusRatio;

		//----------------------------------------------------------------
		// draw
		//----------------------------------------------------------------
		display.alpha = animationRatio;

		g.clear();

		g.beginFill(0x000000, 0.01);
		g.drawCircle(chart.computedCenterX, chart.computedCenterY, outerRadius);
		if (isDonut) g.drawCircle(chart.computedCenterX, chart.computedCenterY, innerRadius);
		g.endFill();

		var f:int = -1;
		var fmax:int = pies.list.length;
		var pie:PieSeriesWedge;
		var renderer:IPieSeriesWedgeRenderer;
		var fill:IFill;

		while (++f < fmax) {
			pie = pies.list[f];

			fill = (fillFunction !== null) ? fillFunction(pie) : fills[f % fills.length];

			renderer = wedgeRenderer.newInstance();
			renderer.outerRadius = outerRadius;
			renderer.innerRadius = innerRadius;
			renderer.pie = pie;
			renderer.fill = fill;
			renderer.order = f / fmax;
			renderer.animate = animationRatio;

			renderer.x = chart.computedCenterX;
			renderer.y = chart.computedCenterY;

			renderer.addEventListener(MouseEvent.ROLL_OVER, toolTipCreate);
			renderer.addEventListener(MouseEvent.ROLL_OUT, toolTipRemove);
			renderer.addEventListener(MouseEvent.CLICK, clickHandler);

			display.addChild(renderer as DisplayObject);
		}
	}

	private function clickHandler(event:MouseEvent):void {
		var wedge:IPieSeriesWedgeRenderer = event.target as IPieSeriesWedgeRenderer;
		dispatchEvent(new PieSeriesEvent(PieSeriesEvent.WEDGE_CLICK, wedge.pie, wedge));
	}

	private function toolTipCreate(event:MouseEvent):void {
		if (toolTipProvider) {
			var wedge:IPieSeriesWedgeRenderer = event.target as IPieSeriesWedgeRenderer;
			var display:DisplayObject = wedge as DisplayObject;
			var radius:Number = wedge.innerRadius + ((wedge.outerRadius - wedge.innerRadius) / 2);
			var center:Point = display.parent.localToGlobal(new Point(display.x, display.y));
			var contentX:Number = radius * Math.cos(MathUtils.deg2rad(wedge.pie.labelDeg));
			var contentY:Number = radius * Math.sin(MathUtils.deg2rad(wedge.pie.labelDeg));

			toolTipProvider.show(center.x, center.y, center.x + contentX, center.y + contentY, {
				pie  : wedge.pie,
				wedge: wedge
			});
		}

		if (buttonMode) Mouse.cursor = MouseCursor.BUTTON;
	}

	private function toolTipRemove(event:MouseEvent):void {
		if (toolTipProvider) {
			toolTipProvider.hide();
		}

		if (buttonMode) Mouse.cursor = MouseCursor.AUTO;
	}

	private function compute(axis:PieAxis, chart:PolaChart):Pies {
		var pies:Pies = new Pies;
		var pie:PieSeriesWedge;

		var f:int = -1;
		var fmax:int = axis.dataProvider.length;

		var source:Object;
		var value:Number;

		while (++f < fmax) {
			source = axis.dataProvider.getItemAt(f);
			value = NullUtils.nanTo(source[dataField], 0);

			if (value > 0) {
				pie = new PieSeriesWedge;
				pie.row = source;
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
			pie.labelDeg = MathUtils.rotate(nextDeg + ((pie.ratioValue * totalDeg) / 2), -90);
			nextDeg += pie.ratioValue * totalDeg;
			pie.endDeg = MathUtils.rotate(nextDeg, -90);
		}

		return pies;
	}
}
}

import ssen.components.chart.pola.pieAxis.PieSeriesWedge;

class Pies {
	public var list:Vector.<PieSeriesWedge> = new Vector.<PieSeriesWedge>;
	public var total:Number = 0;
}