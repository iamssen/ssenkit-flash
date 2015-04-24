package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.IAxis;
import mx.charts.series.ColumnSeries;
import mx.charts.series.ColumnSet;
import mx.collections.IList;
import mx.core.mx_internal;
import mx.graphics.IFill;

use namespace mx_internal;

public class StackedColumnSeriesRenderBaseElement extends CartesianChartElement {

	//	private var dottedLines:Vector.<DottedLine>=new Vector.<DottedLine>;

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		graphics.clear();
		//		clearDottedLines();

		var dataProvider:IList=chart.dataProvider as IList;

		if (!chart || !chart["horizontalAxis"] || !(chart["horizontalAxis"] is IAxis) || !dataProvider) {
			callLater(invalidateDisplayList);
			return;
		}

		var haxis:IAxis=chart["horizontalAxis"] as IAxis;

		var labelSet:AxisLabelSet=haxis.getLabelEstimate();
		var ticks:Array=labelSet.ticks;
		var columnSet:ColumnSet=chart.series[0];
		var dataProvider:IList=chart.dataProvider as IList;

		var p:Point=new Point;

		var columnData:Object;
		var columnData1:Object;
		var columnData2:Object;

		var v:Number;
		var v1:Number=0;
		var v2:Number=0;

		var series:ColumnSeries;
		var fill:IFill;
		var tick:Number;

		var columnSetSeries:Array=columnSet.series;
		var columnRects:Vector.<Rectangle>=getColumnRects(dataProvider, columnSet, unscaledWidth, unscaledHeight);
		var columnRect:Rectangle;
		var columnRect1:Rectangle;
		var columnRect2:Rectangle;

		//		var dottedLine:DottedLine;

		// loop ticks
		var f:int=0;
		var fmax:int=ticks.length - 1;

		var s:int;
		var smax:int;

		begin();

		while (++f < fmax) {
			tick=ticks[f];

			// loop column series
			s=-1;
			smax=columnSetSeries.length;

			columnData1=dataProvider.getItemAt(f - 1);
			columnData2=dataProvider.getItemAt(f);
			v1=0;
			v2=0;

			// draw wire x position
			p.x=tick * unscaledWidth;
			p.y=10;

			drawCenterOfColumns(p.x, columnData1, columnData2);

			while (++s < smax) {
				series=columnSetSeries[s];

				// darw column wire y position
				p.y=getVerticalPosition((v1 + (columnData1[series.yField] / 2) + v2 + (columnData2[series.yField] / 2)) / 2);

				fill=series.getStyle("fill");

//				drawWireOfColumnStacks(p.x, p.y, columnData1, columnData2, series.yField, fill);

				// increase vertical values
				v1+=Number(columnData1[series.yField]);
				v2+=Number(columnData2[series.yField]);

				columnRect1=columnRects[f - 1];
				columnRect2=columnRects[f];

				drawWireOfColumnStacks(p.x, p.y, columnData1, columnData2, v1, v2, columnRect1, columnRect2, series.yField, fill);
			}
		}

		f=-1;
		fmax=dataProvider.length;

		while (++f < fmax) {
			columnRect=columnRects[f].clone();
			columnData=dataProvider.getItemAt(f);

			s=-1;
			smax=columnSetSeries.length;

			v=0;

			while (++s < smax) {
				series=columnSetSeries[s];
				v+=Number(columnData[series.yField]);
			}

			columnRect.y=getVerticalPosition(v);
			columnRect.height=unscaledHeight - columnRect.y;


			drawColumnOverHead(columnRect, columnData);
		}

		end();

		//		var rect:Rectangle;
		//
		//		f=-1;
		//		fmax=columnRects.length;
		//		while (++f < fmax) {
		//			rect=columnRects[f];
		//
		//			graphics.beginFill(0, 0.1);
		//			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		//			graphics.endFill();
		//		}
	}

	private function getColumnRects(dataProvider:IList, columnSet:ColumnSet, w:Number, h:Number):Vector.<Rectangle> {

		// var columnMaxWidth:Number=columnSet.maxColumnWidth;   maxColumnWidth의 2배로 보인다... 왜지?
		var columnMaxWidth:Number=columnSet.maxColumnWidth * 2;
		var columnWidthRatio:Number=columnSet.columnWidthRatio;

		var columnSpaceWidth:Number=w / dataProvider.length;
		var columnWidth:Number=columnSpaceWidth * columnWidthRatio;

		if (!isNaN(columnMaxWidth) && columnWidth > columnMaxWidth) {
			columnWidth=columnMaxWidth;
		}

		var columnLeft:Number=(columnSpaceWidth - columnWidth) / 2;

		var f:int=-1;
		var fmax:int=dataProvider.length;
		var rect:Rectangle;

		var rects:Vector.<Rectangle>=new Vector.<Rectangle>;

		while (++f < fmax) {
			rect=new Rectangle;
			rect.x=(columnSpaceWidth * f) + columnLeft;
			rect.y=0;
			rect.width=columnWidth;
			rect.height=h;

			rects.push(rect);
		}

		return rects;
	}

	protected function begin():void {

	}

	protected function end():void {

	}

	protected function drawCenterOfColumns(x:int, data1:Object, data2:Object):void {
		graphics.beginFill(0x000000, 0.6);
		graphics.drawCircle(x, 10, 3);
		graphics.endFill();
	}

	protected function drawWireOfColumnStacks(x:int, y:int, data1:Object, data2:Object, v1:Number, v2:Number, columnRect1:Rectangle, columnRect2:Rectangle, dataField:String,
											  fill:IFill):void {
		fill.begin(graphics, null, null);
		graphics.drawCircle(x, y, 5);
		fill.end(graphics);
	}

	protected function drawColumnOverHead(rect:Rectangle, data:Object):void {
		graphics.beginFill(0x000000, 0.6);
		graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		graphics.endFill();
	}
}
}
