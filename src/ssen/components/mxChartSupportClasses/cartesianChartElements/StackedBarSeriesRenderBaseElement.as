package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.IAxis;
import mx.charts.series.BarSeries;
import mx.charts.series.BarSet;
import mx.collections.IList;
import mx.graphics.IFill;

public class StackedBarSeriesRenderBaseElement extends CartesianChartElement {

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		graphics.clear();

		var dataProvider:IList = chart.dataProvider as IList;

		if (!chart || !chart["verticalAxis"] || !(chart["verticalAxis"] is IAxis) || !dataProvider) {
			callLater(invalidateDisplayList);
			return;
		}

		var barSet:BarSet = chart.series[0];

		if (!(barSet is BarSet)) {
			callLater(invalidateDisplayList);
			return;
		}

		var vaxis:IAxis = chart["verticalAxis"] as IAxis;

		var labelSet:AxisLabelSet = vaxis.getLabelEstimate();
		var ticks:Array = labelSet.ticks;

		var p:Point = new Point;

		var barData:Object;
		var barData1:Object;
		var barData2:Object;

		var v:Number;
		var v1:Number = 0;
		var v2:Number = 0;

		var series:BarSeries;
		var fill:IFill;
		var tick:Number;

		var barSetSeries:Array = barSet.series;
		var barRects:Vector.<Rectangle> = getBarRects(dataProvider, barSet, unscaledWidth, unscaledHeight);
		var barRect:Rectangle;
		var barRect1:Rectangle;
		var barRect2:Rectangle;

		var f:int = 0;
		var fmax:int = ticks.length - 1;

		var s:int;
		var smax:int;

		begin();

		while (++f < fmax) {
			tick = ticks[f];

			s = -1;
			smax = barSetSeries.length;

			barData1 = dataProvider.getItemAt(f - 1);
			barData2 = dataProvider.getItemAt(f);
			v1 = 0;
			v2 = 0;

			p.x = 10;
			p.y = tick * unscaledHeight;

			drawCenterOfBars(p.y, barData1, barData2);

			while (++s < smax) {
				series = barSetSeries[s];

				p.x = getHorizontalPosition((v1 + (barData1[series.xField] / 2) + v2 + (barData2[series.xField] / 2)) / 2);

				fill = series.getStyle("fill");

				v1 += Number(barData1[series.xField]);
				v2 += Number(barData2[series.xField]);

				barRect1 = barRects[f - 1];
				barRect2 = barRects[f];

				drawWireOfBarStacks(p.x, p.y, barData1, barData2, v1, v2, barRect1, barRect2, series.xField, fill);
			}
		}

		f = -1;
		fmax = dataProvider.length;

		while (++f < fmax) {
			barRect = barRects[f].clone();
			barData = dataProvider.getItemAt(f);

			s = -1;
			smax = barSetSeries.length;

			v = 0;

			while (++s < smax) {
				series = barSetSeries[s];
				v += Number(barData[series.xField]);
			}

			barRect.x = 0;
			barRect.width = getHorizontalPosition(v);
			//			barRect.width = unscaledWidth - barRect.x;


			drawBarOverHead(barRect, barData);
		}

		end();
	}


	private static function getBarRects(dataProvider:IList, barSet:BarSet, w:Number, h:Number):Vector.<Rectangle> {
		// TODO column, columnSet, chart 로 maxWidth를 찾아야 한다
		var barMaxHeight:Number = barSet.maxBarWidth * 2;
		var barHeightRatio:Number = barSet.barWidthRatio;

		var barSpaceHeight:Number = h / dataProvider.length;
		var barHeight:Number = barSpaceHeight * barHeightRatio;

		if (!isNaN(barMaxHeight) && barHeight > barMaxHeight) {
			barHeight = barMaxHeight;
		}

		var barTop:Number = (barSpaceHeight - barHeight) / 2;

		var f:int = -1;
		var fmax:int = dataProvider.length;
		var rect:Rectangle;

		var rects:Vector.<Rectangle> = new Vector.<Rectangle>;

		while (++f < fmax) {
			rect = new Rectangle;
			rect.x = 0;
			rect.y = h - (barSpaceHeight * (f + 1)) + barTop;
			rect.width = w;
			rect.height = barHeight;

			rects.push(rect);
		}

		return rects;
	}

	protected function begin():void {

	}

	protected function end():void {

	}

	protected function drawCenterOfBars(y:int, data1:Object, data2:Object):void {
		graphics.beginFill(0, 0.6);
		graphics.drawCircle(10, y, 3);
		graphics.endFill();
	}

	protected function drawWireOfBarStacks(x:int,
										   y:int,
										   data1:Object,
										   data2:Object,
										   v1:Number,
										   v2:Number,
										   barRect1:Rectangle,
										   barRect2:Rectangle,
										   dataField:String,
										   fill:IFill):void {
		fill.begin(graphics, null, null);
		graphics.drawCircle(x, y, 5);
		fill.end(graphics);
	}

	protected function drawBarOverHead(rect:Rectangle, data:Object):void {
		var border:int = 5;
		graphics.beginFill(0, 0.6);
		//		graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		graphics.drawRect(rect.x + rect.width, rect.y, 50, rect.height);
		graphics.drawRect(rect.x + rect.width + border, rect.y + border, 50 - (border * 2), rect.height - (border * 2));
		graphics.endFill();
	}
}
}




























