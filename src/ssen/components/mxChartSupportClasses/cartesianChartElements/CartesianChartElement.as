package ssen.components.mxChartSupportClasses.cartesianChartElements {

import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.CartesianTransform;
import mx.charts.chartClasses.ChartElement;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.NumericAxis;
import mx.events.FlexEvent;

/** CartesianChart의 ChartElement 구현을 위한 Base Class */
public class CartesianChartElement extends ChartElement {
	//==========================================================================================
	// chart update handlers
	//==========================================================================================
	private var chartInitialized:Boolean;

	/** @private */
	override protected function commitProperties():void {
		super.commitProperties();

		if (!chartInitialized) {
			if (!chart) {
				callLater(invalidateProperties);
			} else {
				chart.addEventListener(FlexEvent.UPDATE_COMPLETE, updateCompleteHandler, false, 0, true);
				chartInitialized = true;
			}
		}
	}

	private function updateCompleteHandler(event:FlexEvent):void {
		invalidateDisplayList();
	}

	//==========================================================================================
	// base object
	//==========================================================================================
	protected function get cartesianChart():CartesianChart {
		return chart as CartesianChart;
	}

	/** 시각적 Y좌표에 해당하는 값을 가져온다 */
	protected function getVerticalValue(y:Number):Number {
		return abs(cartesianChart.verticalAxis, dataTransform.invertTransform(0, y)[1]);
		//return Number(NumericAxis(cartesianChart.verticalAxis).invertTransform(y));
		//		var vaxis:LinearAxis = getVerticalAxis();
		//		return vaxis.maximum - ((vaxis.maximum - vaxis.minimum) * (y / unscaledHeight));
	}

	/** 시각적 X좌표에 해당하는 값을 가져온다 */
	protected function getHorizontalValue(x:Number):Number {
		return abs(cartesianChart.horizontalAxis, dataTransform.invertTransform(x, 0)[0]);
		//		var haxis:LinearAxis = getHorizontalAxis();
		//		return ((haxis.maximum - haxis.minimum) * (x / unscaledWidth)) + haxis.minimum;
	}

	/** 논리적 가로축 값에 해당하는 X 위치를 가져온다 */
	protected function getHorizontalPosition(h:Number):Number {
		var obj:Object = {h: h};
		dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache([obj], "h", "h1");
		dataTransform.transformCache([obj], "h1", "x", null, null);
		return abs(cartesianChart.horizontalAxis, obj["x"]);
		//		var haxis:LinearAxis = getHorizontalAxis();
		//		return ((h - haxis.minimum) / (haxis.maximum - haxis.minimum)) * unscaledWidth;
	}

	/** 논리적 세로축 값에 해당하는 Y 위치를 가져온다 */
	protected function getVerticalPosition(v:Number):Number {
		var obj:Object = {v: v};
		//		// case 1
		//		dataTransform.transformCache([obj], null, null, "v", "y");
		//		// case 2
		//		NumericAxis(cartesianChart.verticalAxis).transformCache([obj], "v", "y1");
		//		obj["y11"] = (cartesianChart.verticalAxis is NumericAxis && NumericAxis(cartesianChart.verticalAxis).direction === "inverted") ? obj["y1"] - 1 : 1 - obj["y1"];
		//		obj["y11"] *= unscaledHeight;
		// case 3
		dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache([obj], "v", "v1");
		dataTransform.transformCache([obj], null, null, "v1", "y");
		return abs(cartesianChart.verticalAxis, obj["y"]);
		//		var vaxis:LinearAxis = getVerticalAxis();
		//		return unscaledHeight - (((v - vaxis.minimum) / (vaxis.maximum - vaxis.minimum)) * unscaledHeight);
	}

	private static function abs(axis:IAxis, value:Number):Number {
		return (axis is NumericAxis && NumericAxis(axis).direction === "inverted") ? value * -1 : value;
	}
}
}
