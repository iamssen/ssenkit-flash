package ssen.flexkit.components.chart {
import mx.charts.LinearAxis;
import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.ChartElement;

/** CartesianChart의 ChartElement 구현을 위한 Base Class */

// TODO LogAxis, CategoryAxis 를 위한 구현들을 한다.
// Axis 내에 뭔가 위치값 계산을 위한 기능들이 있지 않을까?
public class CartesianChartElement extends ChartElement {
	protected function getCartesianChart():CartesianChart {
		return chart as CartesianChart;
	}

	/** 시각적 Y좌표에 해당하는 값을 가져온다 */
	protected function getVerticalValue(y:Number):Number {
		var vaxis:LinearAxis=getVerticalAxis();
		return vaxis.maximum - ((vaxis.maximum - vaxis.minimum) * (y / unscaledHeight));
	}

	/** 시각적 X좌표에 해당하는 값을 가져온다 */
	protected function getHorizontalValue(x:Number):Number {
		var haxis:LinearAxis=getHorizontalAxis();
		return ((haxis.maximum - haxis.minimum) * (x / unscaledWidth)) + haxis.minimum;
	}

	/** Bubble Chart의 가로Axis를 가져온다 */
	protected function getHorizontalAxis():LinearAxis {
		return getCartesianChart().horizontalAxis as LinearAxis;
	}

	/** Bubble Chart의 세로Axis를 가져온다 */
	protected function getVerticalAxis():LinearAxis {
		return getCartesianChart().verticalAxis as LinearAxis;
	}

	/** 논리적 가로축 값에 해당하는 X 위치를 가져온다 */
	protected function getHorizontalPosition(h:Number):Number {
		var haxis:LinearAxis=getHorizontalAxis();
		return ((h - haxis.minimum) / (haxis.maximum - haxis.minimum)) * unscaledWidth;
	}

	/** 논리적 세로축 값에 해당하는 Y 위치를 가져온다 */
	protected function getVerticalPosition(v:Number):Number {
		var vaxis:LinearAxis=getVerticalAxis();
		return unscaledHeight - (((v - vaxis.minimum) / (vaxis.maximum - vaxis.minimum)) * unscaledHeight);
	}
}
}
