package ssen.components.chart.pola.radarAxis {
import ssen.components.chart.pola.*;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.EventDispatcher;

import mx.collections.IList;
import mx.core.IFactory;
import mx.core.UIComponent;

[Event(name="itemClick", type="ssen.components.chart.pola.PolaChartEvent")]

public class RadarCategoryPoints extends EventDispatcher implements IRadarElement {
	//==========================================================================================
	// properties
	//==========================================================================================
	public var pointRenderer:IFactory;

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
	public function render(radarItems:Vector.<RadarItem>, axis:RadarAxis, chart:PolaChart, targetContainer:UIComponent):void {
		//----------------------------------------------------------------
		// init display
		//----------------------------------------------------------------
		targetContainer.addChild(display);

		clearContainer(display);

		//----------------------------------------------------------------
		// coordinate info
		//----------------------------------------------------------------
		var centerX:Number = chart.computedCenterX;
		var centerY:Number = chart.computedCenterY;
		var radius:Number = (chart.computedContentRadius * axis.drawRadiusRatio) + 10;

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

			renderer.item = radarItem.data;
			renderer.setPoint(centerX, centerY, x, y);
			renderer.dispatchTarget = this;

			display.addChild(renderer as DisplayObject);
		}
	}

	private function clearContainer(display:DisplayObjectContainer):void {
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
