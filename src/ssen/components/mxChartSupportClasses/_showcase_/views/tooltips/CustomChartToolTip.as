package ssen.components.mxChartSupportClasses._showcase_.views.tooltips {
import flash.display.Graphics;

import mx.charts.HitData;
import mx.charts.chartClasses.DataTip;
import mx.charts.series.LineSeries;

/** 
 * 현재 좀 둥그렇게 나오는 Chart ToolTip 처리 
 *
 * @includeExample CustomChartToolTip.txt 
 */
public class CustomChartToolTip extends DataTip {
	/** @private */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		setStyle("paddingLeft", 10);

		var g:Graphics=graphics;
		var left:int=getStyle("paddingLeft") || 0;
		var top:int=getStyle("paddingTop") || 0;

		g.clear();

		var strokeColor:uint;

		if (HitData(data).element is LineSeries) {
			strokeColor=HitData(data).element["getStyle"]("lineStroke")["color"];
		} else {
			strokeColor=data["contextColor"];
		}

		g.beginFill(0xffffff, 0.9);
		g.lineStyle(2, strokeColor, 1, true);
		g.drawRoundRect(left - 7, top - 5, unscaledWidth + 10, unscaledHeight + 10, 16, 16);
		g.endFill();
	}
}
}
