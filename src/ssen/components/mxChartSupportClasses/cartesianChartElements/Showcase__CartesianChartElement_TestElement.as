package ssen.components.mxChartSupportClasses.cartesianChartElements {

import ssen.common.MathUtils;

public class Showcase__CartesianChartElement_TestElement extends CartesianChartElement {

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var axis:Object = cartesianChart.verticalAxis;
		var v:Number = MathUtils.rand(axis.minimum, axis.maximum);
		//		var v:Number = 10;
		var y:Number = getVerticalPosition(v);
		trace("TestChartElement.updateDisplayList()", v, y, getVerticalValue(y), axis.minimum, axis.maximum);

		graphics.clear();
		graphics.beginFill(0, 0.1);
		graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		graphics.endFill();
		graphics.beginFill(0xff0000);
		graphics.drawRect(0, y, unscaledWidth, 1);
		graphics.endFill();
	}
}
}
