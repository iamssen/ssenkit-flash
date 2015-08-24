package ssen.components.chart.pola.pieAxis {
import com.greensock.easing.Quad;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.collections.IList;
import mx.core.UIComponent;
import mx.graphics.IFill;
import mx.graphics.IStroke;

import ssen.common.NullUtils;

import ssen.components.animate.AnimationTrack;
import ssen.components.chart.pola.PolaChart;

[Deprecated(message="Remove when end of project")]
public class PieSolidBackground extends EventDispatcher implements IPieElement {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// style
	//----------------------------------------------------------------
	public var radiusRatio:Number = 1;

	//----------------------------------------------------------------
	// animate
	//----------------------------------------------------------------
	public var animationTrack:AnimationTrack = new AnimationTrack(0, 1, Quad.easeOut);
	private var lastAnimationRatio:Number;

	//----------------------------------------------------------------
	// fill
	//----------------------------------------------------------------
	public var fill:IFill;
	public var stroke:IStroke;

	//==========================================================================================
	// compute
	//==========================================================================================
	public function computeMaximumValue(dataProvider:IList):Number {
		return NaN;
	}

	//==========================================================================================
	// render
	//==========================================================================================
	private var display:Sprite;

	public function PieSolidBackground() {
		display = new Sprite;
	}

	public function render(axis:PieAxis, chart:PolaChart, targetContainer:UIComponent, animationRatio:Number):void {
		//----------------------------------------------------------------
		// time tracking
		//----------------------------------------------------------------
		//		var oldRatio:Number = animationRatio;
		animationRatio = animationTrack.getTime(animationRatio);
		//		trace("PieSolidBackground.render()", oldRatio.toFixed(2), animationRatio);

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
		targetContainer.addChild(display);

		//----------------------------------------------------------------
		// coordinate info
		//----------------------------------------------------------------
		var radius:Number = chart.computedContentRadius * axis.drawRadiusRatio * this.radiusRatio * animationRatio;
		//		trace("PieSolidBackground.render() ===>",
		//				"chart.computedContentRadius", chart.computedContentRadius,
		//				"axis.drawRadiusRatio", axis.drawRadiusRatio,
		//				"radiusRatio", this.radiusRatio,
		//				"animationRatio", animationRatio,
		//				"originRatio", oldRatio,
		//				"radius", radius);

		//----------------------------------------------------------------
		// draw
		//----------------------------------------------------------------
		//		display.alpha = animationRatio;
		display.alpha = 1;
		display.x = chart.computedCenterX;
		display.y = chart.computedCenterY;

		var bound:Rectangle = new Rectangle(-radius, -radius, radius * 2, radius * 2);
		var point:Point = new Point(-radius, -radius);
		var g:Graphics = display.graphics;
		g.clear();

		if (stroke) stroke.apply(g, bound, point);
		if (fill) fill.begin(g, bound, point);
		g.drawCircle(0, 0, radius);
		if (fill) fill.end(g);
		g.lineStyle();

		//		trace("PieSolidBackground.render()",
		//				radius.toFixed(2),
		//				chart.computedContentRadius.toFixed(2),
		//				axis.drawRadiusRatio.toFixed(2),
		//				this.radiusRatio.toFixed(2),
		//				display.alpha.toFixed(2),
		//				animationRatio.toFixed(2),
		//				oldRatio.toFixed(2),
		//				NullUtils.isNull(fill),
		//				NullUtils.isNull(stroke),
		//				display.alpha.toFixed(2),
		//				display.x.toFixed(2),
		//				display.y.toFixed(2)
		//		);
	}
}
}
