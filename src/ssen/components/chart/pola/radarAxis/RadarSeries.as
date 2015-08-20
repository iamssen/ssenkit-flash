package ssen.components.chart.pola.radarAxis {
import com.greensock.easing.Elastic;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.collections.IList;
import mx.core.IFactory;
import mx.core.UIComponent;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;

import ssen.common.DisposableUtils;
import ssen.common.MathUtils;
import ssen.components.animate.AnimationTrack;
import ssen.components.chart.pola.*;
import ssen.components.chart.pola.renderers.IPolaPointRenderer;
import ssen.ssen_internal;

use namespace ssen_internal;

[Event(name="itemClick", type="ssen.components.chart.pola.PolaChartEvent")]

public class RadarSeries extends EventDispatcher implements IRadarElement {
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
	public var drawRadiusRatio:Number;
	public var stroke:IStroke;
	public var fill:IFill;
	//----------------------------------------------------------------
	// renderer
	//----------------------------------------------------------------
	public var pointRenderer:IFactory;
	//----------------------------------------------------------------
	// animate
	//----------------------------------------------------------------
	public var animationTrack:AnimationTrack = new AnimationTrack(0.5, 1, Elastic.easeOut);
	private var lastAnimationRatio:Number;

	//==========================================================================================
	// compute
	//==========================================================================================
	public function computeMaximumValue(dataProvider:IList):Number {
		if (!dataField) {
			return 0;
		}

		var f:int = dataProvider.length;
		var data:Object;
		var max:Number = Number.MIN_VALUE;
		var n:Number;

		while (--f >= 0) {
			data = dataProvider.getItemAt(f);
			n = data[dataField];

			if (n > max) {
				max = n;
			}
		}

		return max;
	}

	//==========================================================================================
	// render
	//==========================================================================================
	private var display:UIComponent;

	public function RadarSeries() {
		display = new UIComponent();
	}

	public function render(radarItems:Vector.<RadarItem>, axis:RadarAxis, chart:PolaChart, targetContainer:UIComponent, animationRatio:Number):void {
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

		//----------------------------------------------------------------
		// init display
		//----------------------------------------------------------------
		if (display.parent !== targetContainer) targetContainer.addChild(display);
		DisposableUtils.disposeDisplayContainer(display);

		var g:Graphics = display.graphics;

		//----------------------------------------------------------------
		// coordinate info
		//----------------------------------------------------------------
		var radiusRatio:Number = (isNaN(drawRadiusRatio)) ? axis.drawRadiusRatio : drawRadiusRatio;
		var maximum:Number = axis.computedMaximum;
		var centerX:Number = chart.computedCenterX;
		var centerY:Number = chart.computedCenterY;
		var radius:Number = chart.computedContentRadius * radiusRatio * animationRatio;

		display.alpha = animationRatio;

		//----------------------------------------------------------------
		// draw properties
		//----------------------------------------------------------------
		var pts:Vector.<Pt> = new Vector.<Pt>(radarItems.length, true);
		var pt:Pt;

		var radarItem:RadarItem;

		var n:Number; // number value
		var x:Number; // x position
		var y:Number; // y position
		var r:Number; // radius

		var f:int = -1;
		var fmax:int = radarItems.length;

		//----------------------------------------------------------------
		// stroke and fill setting
		//----------------------------------------------------------------
		var bound:Rectangle = new Rectangle();
		var point:Point = new Point();
		bound.x = centerX - radius;
		bound.y = centerY - radius;
		bound.width = radius * 2;
		bound.height = radius * 2;
		point.x = centerX - radius;
		point.y = centerY - radius;

		//----------------------------------------------------------------
		// compute draw points
		//----------------------------------------------------------------
		while (++f < fmax) {
			radarItem = radarItems[f];

			// 표시할 value
			n = radarItem.data[dataField];
			// 그려질 실제 radius
			r = radius * (n / maximum);
			x = (Math.cos(radarItem.radian) * r) + centerX;
			y = (Math.sin(radarItem.radian) * r) + centerY;

			pt = new Pt;
			pt.angle = radarItem.angle;
			pt.data = radarItem.data;
			pt.x = x;
			pt.y = y;
			pt.rad = radarItem.radian;
			pts[f] = pt;
		}

		//----------------------------------------------------------------
		// draw stroke and fill
		//----------------------------------------------------------------
		if (!fill && !stroke) {
			var color:uint = MathUtils.rand(0x000000, 0xffffff);
			stroke = new SolidColorStroke(color);
			fill = new SolidColor(color, 0.4);
		}

		if (stroke) stroke.apply(g, bound, point);
		if (fill) fill.begin(g, bound, point);

		f = -1;
		fmax = pts.length;
		while (++f < fmax) {
			pt = pts[f];

			if (f === 0) {
				g.moveTo(pt.x, pt.y);
			} else {
				g.lineTo(pt.x, pt.y);
			}
		}

		if (fill) fill.end(g);
		g.lineStyle();

		//----------------------------------------------------------------
		// draw point
		//----------------------------------------------------------------
		if (pointRenderer !== null) {
			var renderer:IPolaPointRenderer;

			f = -1;
			fmax = pts.length;

			while (++f < fmax) {
				pt = pts[f];

				renderer = pointRenderer.newInstance();
				renderer.data = pt.data;
				renderer.item = this;
				renderer.render(centerX, centerY, pt.x, pt.y);

				display.addChild(renderer as DisplayObject);
			}
		}
	}
}
}

class Pt {
	public var x:Number;
	public var y:Number;
	public var angle:Number;
	public var data:Object;
	public var rad:Number;
}