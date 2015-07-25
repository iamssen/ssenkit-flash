//<mx:LineChart dataProvider="{data}"
//				  bottom="10"
//				  left="10"
//				  right="10"
//				  top="10"
//				  showDataTips="true">
//
//		<mx:seriesFilters>
//			<fx:Array/>
//		</mx:seriesFilters>
//
//		<mx:horizontalAxis>
//			<mx:CategoryAxis categoryField="label"/>
//		</mx:horizontalAxis>
//
//		<mx:series>
//			<mx:LineSeries displayName="LINE" xField="label" yField="value">
//				<mx:lineSegmentRenderer>
//					<fx:Component>
//						<chart:DashedLineSeriesItemRenderer dashedField="dash"/>
//					</fx:Component>
//				</mx:lineSegmentRenderer>
//			</mx:LineSeries>
//		</mx:series>
//	</mx:LineChart>


package ssen.components.mxChartSupportClasses.seriesItemRenderers {
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.series.items.LineSeriesSegment;
import mx.collections.IList;
import mx.core.IDataRenderer;
import mx.graphics.IStroke;
import mx.skins.ProgrammaticSkin;

import ssen.components.mxChartSupportClasses.axisLabelRenderers.AxisLabelRenderer;

public class LineSeriesDashedSegmentItemRenderer extends ProgrammaticSkin implements IDataRenderer {
	//---------------------------------------------
	// dashedLineFunction
	//---------------------------------------------
	private var _dashedLineFunction:Function;

	/** dashedLineFunction */
	public function get dashedLineFunction():Function {
		var l:AxisLabelRenderer = new AxisLabelRenderer();

		return _dashedLineFunction;
	}

	public function set dashedLineFunction(value:Function):void {
		_dashedLineFunction = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// strokeFunction
	//---------------------------------------------
	private var _strokeFunction:Function;

	/** strokeFunction */
	public function get strokeFunction():Function {
		return _strokeFunction;
	}

	public function set strokeFunction(value:Function):void {
		_strokeFunction = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// data
	//---------------------------------------------
	private var _data:Object;

	/** data */
	public function get data():Object {
		return _data;
	}

	public function set data(value:Object):void {
		_data = value;
		invalidateDisplayList();
	}

	//==========================================================================================
	// draw
	//==========================================================================================
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		graphics.clear();

		var lineSeriesSegment:LineSeriesSegment = data as LineSeriesSegment;
		var form:String = getStyle("form") as String;

		if (!lineSeriesSegment || _dashedLineFunction == null) {
			return;
		}

		var dataProvider:IList = lineSeriesSegment.element.dataProvider as IList;

		if (!dataProvider || dataProvider.length === 0) {
			return;
		}

		var stroke:IStroke = getStyle("lineStroke") as IStroke;
		var data:Object;

		var f:int = -1;
		var fmax:int = dataProvider.length;

		var dash:Boolean;

		while (++f < fmax) {
			data = dataProvider.getItemAt(f);
			dash = _dashedLineFunction(data);


			if (f < fmax - 1) {
				if (_strokeFunction !== null) {
					stroke = _strokeFunction(data);
				}

				if (dash) {
					drawDashedPolyLine(graphics, stroke, lineSeriesSegment.items.slice(f, f + 2));
				} else {
					GraphicsUtilities.drawPolyLine(graphics, lineSeriesSegment.items, f, f + 2, "x", "y", stroke, form);
				}
			}
		}
	}
}
}

import flash.display.Graphics;
import flash.geom.Point;

import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;

function drawDashedPolyLine(graphics:Graphics, stroke:IStroke, points:Array):void {
	var color:uint;
	var alpha:uint;
	var thickness:uint = stroke.weight;

	if (stroke is Stroke) {
		color = Stroke(stroke).color;
		alpha = Stroke(stroke).alpha;
	} else if (stroke is SolidColorStroke) {
		color = SolidColorStroke(stroke).color;
		alpha = SolidColorStroke(stroke).alpha;
	} else {
		return;
	}

	var pointsArr:Array = getPoints(points);
	for (var i:int = 0; i < pointsArr.length - 1; i++) {
		if (i <= pointsArr.length - 1) {
			drawDashedLine(graphics, pointsArr[i], pointsArr[i + 1], color, thickness, alpha);
		}
	}
}

function getPoints(value:Array):Array {
	var result:Array = new Array();
	for (var i:int = 0; i < value.length; i++) {
		var point:Point = new Point(value[i].x, value[i].y);
		result.push(point);
	}
	return result;
}

/**
 *
 * 대상 객체의  graphics 속성등을 입력받아 점선을 긋는 메소드
 *
 * @param g  점선을 그릴 대상 객체의 grapihcs 객체
 * @param startPoint   점선의 시작점
 * @param endPoint 점선의 끝저
 * @param lineColor 라인의 색상
 * @param thickness 선의 두께
 * @param alpha 선의 알파값
 *
 *
 **/
function drawDashedLine(g:Graphics, startPoint:Point, endPoint:Point, lineColor:uint = 0x000000, thickness:uint = 1, alpha:uint = 1):void {
	var g:Graphics = g;
	g.lineStyle(thickness, lineColor, alpha);
	var pt:Point = new Point(startPoint.x, startPoint.y);
	var pt2:Point = new Point(endPoint.x, endPoint.y);
	var dx:Number = pt2.x - pt.x;
	var dy:Number = pt2.y - pt.y;
	var dist:Number = Math.sqrt(dx * dx + dy * dy);
	var len:Number = Math.round(dist / 10);
	var theta:Number = Math.atan2(dy, dx);
	for (var i:int = 0; i < len; i++) {
		g.moveTo(pt.x, pt.y);
		var targetPoint:Point;
		if (i == len - 1) {
			targetPoint = new Point(pt2.x - Math.cos(theta) * 5, pt2.y - Math.sin(theta) * 5);
		} else {
			targetPoint = new Point(pt.x + Math.cos(theta) * 5, pt.y + Math.sin(theta) * 5);
		}
		g.lineTo(targetPoint.x, targetPoint.y);
		pt = new Point(targetPoint.x + Math.cos(theta) * 5, targetPoint.y + Math.sin(theta) * 5);
	}
}