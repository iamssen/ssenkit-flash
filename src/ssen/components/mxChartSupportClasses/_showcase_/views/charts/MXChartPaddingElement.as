package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Rectangle;

import mx.charts.chartClasses.CartesianChart;

import ssen.components.mxChartSupportClasses.cartesianChartElements.CartesianChartElement;

public class MXChartPaddingElement extends CartesianChartElement {
	private var label:Sprite;

	public function MXChartPaddingElement() {
		label = new Sprite;
		var g:Graphics = label.graphics;
		g.beginFill(0, 0.5);
		g.drawRect(0, 0, 100, 100);
		g.endFill();
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		trace("MXChartPaddingElement.updateDisplayList()", parent);

		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0, 0.3);
		g.drawRect(0, 100, unscaledWidth + 100, 30);
		g.endFill();

		if (parent.parent) {
			var chart:CartesianChart = parent.parent as CartesianChart;
			var gutters:Rectangle = chart.computedGutters;
			trace("MXChartPaddingElement.updateDisplayList()", chart.computedGutters);

			label.x = unscaledWidth + gutters.x;
			label.y = 100 + gutters.y;
			parent.parent.addChild(label);
			trace("MXChartPaddingElement.updateDisplayList()", parent.mask);
		}
	}
}
}
