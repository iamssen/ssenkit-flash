package ssen.components.chart.pola.samples {
import flash.display.Graphics;

import mx.core.UIComponent;

import ssen.components.chart.pola.IPolaElement2;

public class SamplePolaElement extends UIComponent implements IPolaElement2 {
	private var centerX:Number;
	private var centerY:Number;
	private var contentRadius:Number;

	public function resizeDisplayList(centerX:Number, centerY:Number, contentRadius:Number):void {
		this.centerX = centerX;
		this.centerY = centerY;
		this.contentRadius = contentRadius;

		invalidateDisplayList();
	}

	override protected function commitProperties():void {
		super.commitProperties();
	}

	override protected function canSkipMeasurement():Boolean {
		return true;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (!centerX || !centerY || !contentRadius) return;

		var g:Graphics = graphics;
		g.clear();
		g.beginFill(Math.random() * 0xffffff);
		g.drawCircle(centerX, centerY, contentRadius);
		g.endFill();
	}
}
}
