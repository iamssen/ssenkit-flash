package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.IAxis;
import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;

import ssen.drawing.GraphicsUtils;

public class ColumnTrendSingleLine extends CartesianChartElement {
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

	//---------------------------------------------
	// dataField
	//---------------------------------------------
	private var _dataField:String;

	/** dataField */
	public function get dataField():String {
		return _dataField;
	}

	public function set dataField(value:String):void {
		_dataField = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// stroke
	//---------------------------------------------
	private var _stroke:IStroke = new SolidColorStroke(0, 2);

	/** stroke */
	public function get stroke():IStroke {
		return _stroke;
	}

	public function set stroke(value:IStroke):void {
		_stroke = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// useDashedLine
	//---------------------------------------------
	private var _useDashedLine:Boolean;

	/** useDashedLine */
	public function get useDashedLine():Boolean {
		return _useDashedLine;
	}

	public function set useDashedLine(value:Boolean):void {
		_useDashedLine = value;
		invalidateDisplayList();
	}

	public function ColumnTrendSingleLine() {
		mouseEnabled = false;
		mouseChildren = false;
		mouseFocusEnabled = false;
		tabEnabled = false;
		tabChildren = false;
		tabFocusEnabled = false;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		var chart:CartesianChart = cartesianChart;

		if (!chart || !chart["horizontalAxis"] || !(chart["horizontalAxis"] is IAxis) || !_data) {
			callLater(invalidateDisplayList);
			return;
		}

		var targetBound:Rectangle = new Rectangle(0, 0, unscaledWidth, 10);
		var targetPoint:Point = new Point(0, 0);

		var v:Number = Number(_data[_dataField]);
		var y:Number = getVerticalPosition(v);

		var g:Graphics = graphics;
		g.clear();

		if (_useDashedLine) {
			GraphicsUtils.drawDashedPolyLine(g, _stroke, [
				new Point(0, y),
				new Point(unscaledWidth, y)
			]);
			g.lineStyle();
		} else {
			_stroke.apply(g, targetBound, targetPoint);
			g.moveTo(0, y);
			g.lineTo(unscaledWidth, y);
			g.lineStyle();
		}
	}
}
}
