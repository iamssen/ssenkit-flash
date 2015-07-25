package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.engine.FontWeight;
import flash.text.engine.TextLine;

import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.formats.VerticalAlign;

import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.IAxis;
import mx.collections.IList;
import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;

import ssen.common.DisposableUtils;
import ssen.drawing.GraphicsUtils;
import ssen.text.EmbededFontUtils;
import ssen.text.ITextLayoutFormatComponent;
import ssen.text.TextLayoutFormatComponentMixin;
import ssen.text.TextLineFactory;
import ssen.text.TextLinePrinter;

public class ColumnTrendPolyLine extends CartesianChartElement implements ITextLayoutFormatComponent {
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

	//---------------------------------------------
	// textAlign
	//---------------------------------------------
	/** textAlign */
	public function get textAlign():String {
		return formatMixin.textAlign;
	}

	public function set textAlign(value:String):void {
		trace("ColumnTrendLineElement.textAlign() do not change textAlign options");
	}

	//---------------------------------------------
	// truncationOptions
	//---------------------------------------------
	/** truncationOptions */
	public function get truncationOptions():TruncationOptions {
		return formatMixin.truncationOptions;
	}

	public function set truncationOptions(value:TruncationOptions):void {
		formatMixin.truncationOptions = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// format
	//---------------------------------------------
	/** format */
	public function get format():ITextLayoutFormat {
		return formatMixin.format;
	}

	public function set format(value:ITextLayoutFormat):void {
		formatMixin.format = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// formatFunction
	//---------------------------------------------
	/** formatFunction */
	public function get formatFunction():Function {
		return formatMixin.formatFunction;
	}

	public function set formatFunction(value:Function):void {
		formatMixin.formatFunction = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// labelFunction
	//---------------------------------------------
	private var _labelFunction:Function;

	/** labelFunction */
	public function get labelFunction():Function {
		return _labelFunction;
	}

	public function set labelFunction(value:Function):void {
		_labelFunction = value;
		invalidateDisplayList();
	}

	private var formatMixin:TextLayoutFormatComponentMixin;

	public function ColumnTrendPolyLine() {
		formatMixin = new TextLayoutFormatComponentMixin;
		formatMixin.format = new TextLayoutFormat;
		formatMixin.textAlign = TextAlign.CENTER;

		mouseEnabled = false;
		mouseChildren = false;
		mouseFocusEnabled = false;
		tabEnabled = false;
		tabChildren = false;
		tabFocusEnabled = false;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		var chart:CartesianChart = cartesianChart;
		var dataProvider:IList = chart.dataProvider as IList;

		if (!chart || !chart["horizontalAxis"] || !(chart["horizontalAxis"] is IAxis) || !dataProvider || !_dataField) {
			callLater(invalidateDisplayList);
			return;
		}

		var haxis:IAxis = chart.horizontalAxis;
		var labelSet:AxisLabelSet = haxis.getLabelEstimate();
		var ticks:Array = labelSet.ticks;

		var f:int = -1;
		var fmax:int = dataProvider.length;

		var tick1:Number;
		var tick2:Number;
		var source1:Object, source2:Object;
		var v1:Number, v2:Number;
		var x1:Number, x2:Number;
		var y1:Number, y2:Number;

		DisposableUtils.disposeDisplayContainer(this, true);

		var g:Graphics = graphics;

		var labelBound:Rectangle = new Rectangle;
		var targetBound:Rectangle = new Rectangle;
		var targetPoint:Point = new Point(0, 0);

		var format:ITextLayoutFormat;
		var label:String;

		while (++f < fmax) {
			tick1 = ticks[f];
			tick2 = ticks[f + 1];

			x1 = tick1 * unscaledWidth;
			x2 = tick2 * unscaledWidth;

			source1 = dataProvider.getItemAt(f);
			v1 = Number(source1[_dataField]);
			y1 = getVerticalPosition(v1);

			source2 = null;

			if (f < fmax - 1) {
				source2 = dataProvider.getItemAt(f + 1);
				v2 = Number(source2[_dataField]);
				y2 = getVerticalPosition(v2);

				targetBound.x = x1;
				targetBound.width = x2 - x1;
				if (y1 > y2) {
					targetBound.y = y2;
					targetBound.height = y1 - y2;
				} else {
					targetBound.y = y1;
					targetBound.height = y2 - y1;
				}

				if (_useDashedLine) {
					GraphicsUtils.drawDashedPolyLine(g, _stroke, [
						new Point(x1, y1),
						new Point(x2, y1),
						new Point(x2, y2)
					]);
					g.lineStyle();
				} else {
					_stroke.apply(g, targetBound, targetPoint);
					g.moveTo(x1, y1);
					g.lineTo(x2, y1);
					g.lineTo(x2, y2);
					g.lineStyle();
				}
			} else if (f === fmax - 1) {
				targetBound.x = x1;
				targetBound.width = unscaledWidth - x1;
				targetBound.y = y1;
				targetBound.height = 10;

				if (_useDashedLine) {
					GraphicsUtils.drawDashedPolyLine(g, _stroke, [
						new Point(x1, y1),
						new Point(unscaledWidth + 10, y1)
					]);
					g.lineStyle();
				} else {
					_stroke.apply(g, targetBound, targetPoint);
					g.moveTo(x1, y1);
					g.lineTo(unscaledWidth + 10, y1);
					g.lineStyle();
				}
			}

			if (_labelFunction !== null) {
				format = formatMixin.getFormat({data: source1, nextData: source2, dataField: _dataField});
				label = _labelFunction({data: source1, nextData: source2, dataField: _dataField});

				labelBound.x = x1;
				labelBound.y = y1 - 100;
				labelBound.width = x2 - x1;
				labelBound.height = 94;

				var lines:Vector.<TextLine> = TextLineFactory.createTextLines(label, format, formatMixin.truncationOptions, EmbededFontUtils.getSwfContext(this, format.fontFamily, format.fontWeight === FontWeight.BOLD));
				TextLinePrinter.printTextLinesWithSpace(lines,
						this,
						labelBound.right,
						labelBound.bottom,
						labelBound.left,
						0,
						labelBound.top,
						0,
						TextAlign.CENTER,
						VerticalAlign.BOTTOM,
						false,
						false
				);

				//				g.beginFill(0, 0.3);
				//				g.drawRect(labelBound.x, labelBound.y, labelBound.width, labelBound.height);
				//				g.endFill();
			}
		}
	}
}
}
