package ssen.components.chart.pola.radarAxis {
import com.greensock.easing.Back;

import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.collections.IList;
import mx.core.UIComponent;
import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;

import ssen.components.animate.AnimationTrack;
import ssen.components.chart.pola.*;
import ssen.ssen_internal;

use namespace ssen_internal;

[DefaultProperty("stroke")]

public class RadarCrossLines implements IRadarElement {
	//==========================================================================================
	// properties
	//==========================================================================================
	/** stroke */
	public var stroke:IStroke = new SolidColorStroke(0, 2, 0.3, true);

	/** strokeFunction `function(radarItem:RadarItem):IStroke` */
	public var strokeFunction:Function;

	public var animationTrack:AnimationTrack = new AnimationTrack(0, 0.4, Back.easeOut);
	private var lastAnimationTime:Number;

	//==========================================================================================
	// compute
	//==========================================================================================
	public function computeMaximumValue(dataProvider:IList):Number {
		return NaN;
	}

	//==========================================================================================
	// init
	//==========================================================================================
	private var display:Shape;

	public function RadarCrossLines() {
		display = new Shape();
	}

	//==========================================================================================
	// render
	//==========================================================================================
	public function render(radarItems:Vector.<RadarItem>, axis:RadarAxis, chart:PolaChart, targetContainer:UIComponent, animationTime:Number):void {
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

		//----------------------------------------------------------------
		// init display
		//----------------------------------------------------------------
		if (display.parent !== targetContainer) targetContainer.addChild(display);

		var g:Graphics = display.graphics;
		g.clear();

		//----------------------------------------------------------------
		// coordinate info
		//----------------------------------------------------------------
		var centerX:Number = chart.computedCenterX;
		var centerY:Number = chart.computedCenterY;
		var radius:Number = chart.computedContentRadius * axis.drawRadiusRatio * animationTime;

		display.alpha = animationTime;

		//----------------------------------------------------------------
		// draw properties
		//----------------------------------------------------------------
		var bound:Rectangle = new Rectangle();
		var point:Point = new Point();
		var radarItem:RadarItem;
		var x:Number;
		var y:Number;
		var st:IStroke;

		//----------------------------------------------------------------
		// stroke setting
		//----------------------------------------------------------------
		bound.x = centerX - radius;
		bound.y = centerY - radius;
		bound.width = radius * 2;
		bound.height = radius * 2;
		point.x = centerX - radius;
		point.y = centerY - radius;

		var f:int = -1;
		var fmax:int = radarItems.length;

		while (++f < fmax) {
			radarItem = radarItems[f];

			//---------------------------------------------
			// stroke setting
			//---------------------------------------------
			if (strokeFunction !== null) {
				st = strokeFunction(radarItem);
			}

			if (!st) {
				st = stroke;
			}

			st.apply(g, bound, point);
			g.beginFill(0, 0);

			//---------------------------------------------
			// draw point
			//---------------------------------------------
			x = (Math.cos(radarItem.radian) * radius) + centerX;
			y = (Math.sin(radarItem.radian) * radius) + centerY;

			g.moveTo(centerX, centerY);
			g.lineTo(x, y);

			g.endFill();
			g.lineStyle();
		}

	}
}
}
