package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.IAxis;
import mx.charts.series.ColumnSeries;
import mx.collections.IList;
import mx.events.PropertyChangeEvent;
import mx.graphics.IFill;

public class ColumnSeriesRenderBaseElement extends CartesianChartElement {
	//---------------------------------------------
	// targetColumnSeries
	//---------------------------------------------
	private var _targetColumnSeries:ColumnSeries;

	/** targetColumnSeries */
	[Bindable]
	public function get targetColumnSeries():ColumnSeries {
		return _targetColumnSeries;
	}

	public function set targetColumnSeries(value:ColumnSeries):void {
		var oldValue:ColumnSeries = _targetColumnSeries;
		_targetColumnSeries = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "targetColumnSeries", oldValue, _targetColumnSeries));
		}
		
		invalidateDisplayList();
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		graphics.clear();
		//		clearDottedLines();

		if (!targetColumnSeries || !chart || !chart["horizontalAxis"] || !(chart["horizontalAxis"] is IAxis)) {
			return;
		}

		var haxis:IAxis = chart["horizontalAxis"] as IAxis;

		var labelSet:AxisLabelSet = haxis.getLabelEstimate();
		var ticks:Array = labelSet.ticks;
		var columnSeries:ColumnSeries = targetColumnSeries;
		var dataProvider:IList = chart.dataProvider as IList;

		var p:Point = new Point;

		var columnData:Object;
		var columnData1:Object;
		var columnData2:Object;

		var v:Number;
		var v1:Number = 0;
		var v2:Number = 0;

		var fill:IFill;
		var tick:Number;

		var columnRects:Vector.<Rectangle> = getColumnRects(dataProvider, columnSeries, unscaledWidth, unscaledHeight);
		var columnRect:Rectangle;
		var columnRect1:Rectangle;
		var columnRect2:Rectangle;

		//		var dottedLine:DottedLine;

		// loop ticks
		var f:int = 0;
		var fmax:int = ticks.length - 1;

		begin();

		while (++f < fmax) {
			tick = ticks[f];

			columnData1 = dataProvider.getItemAt(f - 1);
			columnData2 = dataProvider.getItemAt(f);
			v1 = 0;
			v2 = 0;

			// draw wire x position
			p.x = tick * unscaledWidth;
			p.y = getVerticalPosition((v1 + (columnData1[columnSeries.yField] / 2) + v2 + (columnData2[columnSeries.yField] / 2)) / 2);

			drawCenterOfColumns(p.x, columnData1, columnData2);

			fill = columnSeries.getStyle("fill");

			drawWireOfColumns(p.x, p.y, columnData1, columnData2, columnSeries.yField, fill);
		}

		f = -1;
		fmax = dataProvider.length;

		while (++f < fmax) {
			columnRect = columnRects[f].clone();
			columnData = dataProvider.getItemAt(f);

			columnRect.y = getVerticalPosition(columnData[columnSeries.yField]);
			columnRect.height = unscaledHeight - columnRect.y;


			drawColumnOverHead(columnRect, columnData);
		}

		end();
	}

	private function getColumnRects(dataProvider:IList, columnSeries:ColumnSeries, w:Number, h:Number):Vector.<Rectangle> {

		// var columnMaxWidth:Number=columnSet.maxColumnWidth;   maxColumnWidth의 2배로 보인다... 왜지?
		var columnMaxWidth:Number = columnSeries.maxColumnWidth * 2;
		var columnWidthRatio:Number = columnSeries.columnWidthRatio;

		var columnSpaceWidth:Number = w / dataProvider.length;
		var columnWidth:Number = columnSpaceWidth * columnWidthRatio;

		if (!isNaN(columnMaxWidth) && columnWidth > columnMaxWidth) {
			columnWidth = columnMaxWidth;
		}

		var columnLeft:Number = (columnSpaceWidth - columnWidth) / 2;

		var f:int = -1;
		var fmax:int = dataProvider.length;
		var rect:Rectangle;

		var rects:Vector.<Rectangle> = new Vector.<Rectangle>;

		while (++f < fmax) {
			rect = new Rectangle;
			rect.x = (columnSpaceWidth * f) + columnLeft;
			rect.y = 0;
			rect.width = columnWidth;
			rect.height = h;

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

	protected function drawWireOfColumns(x:int, y:int, data1:Object, data2:Object, dataField:String, fill:IFill):void {
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
