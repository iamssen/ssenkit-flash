package ssen.components.chart.pola.radarAxis {
import com.greensock.easing.Quad;

import flash.display.DisplayObject;
import flash.events.EventDispatcher;

import mx.collections.IList;
import mx.core.IFactory;
import mx.core.UIComponent;

import ssen.common.DisposableUtils;
import ssen.components.animate.AnimationTrack;
import ssen.components.chart.pola.*;
import ssen.components.chart.pola.renderers.IPolaPointRenderer;

[Event(name="itemClick", type="ssen.components.chart.pola.PolaChartEvent")]

public class RadarCategoryPoints extends EventDispatcher implements IRadarElement {
	//==========================================================================================
	// properties
	//==========================================================================================
	public var pointRenderer:IFactory;

	public var animationTrack:AnimationTrack = new AnimationTrack(0.7, 1, Quad.easeOut);
	private var lastAnimationRatio:Number;

	/** @private */
	public function computeMaximumValue(dataProvider:IList):Number {
		return NaN;
	}

	//==========================================================================================
	// init
	//==========================================================================================
	private var display:UIComponent;


	public function RadarCategoryPoints() {
		display = new UIComponent();
	}

	//==========================================================================================
	// render
	//==========================================================================================
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

		//----------------------------------------------------------------
		// coordinate info
		//----------------------------------------------------------------
		var centerX:Number = chart.computedCenterX;
		var centerY:Number = chart.computedCenterY;
		var radius:Number = (chart.computedContentRadius * axis.drawRadiusRatio) + (10 * animationRatio);

		display.alpha = animationRatio;

		//----------------------------------------------------------------
		// draw properties
		//----------------------------------------------------------------
		var radarItem:RadarItem;
		var x:Number;
		var y:Number;
		var renderer:IPolaPointRenderer;

		var f:int = -1;
		var fmax:int = radarItems.length;

		while (++f < fmax) {
			radarItem = radarItems[f];
			renderer = pointRenderer.newInstance();

			//---------------------------------------------
			// get point
			//---------------------------------------------
			x = (Math.cos(radarItem.radian) * radius) + centerX;
			y = (Math.sin(radarItem.radian) * radius) + centerY;

			renderer.data = radarItem.data;
			renderer.render(centerX, centerY, x, y);
			renderer.item = this;

			display.addChild(renderer as DisplayObject);
		}
	}
}
}
