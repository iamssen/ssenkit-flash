package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.engine.FontWeight;
import flash.text.engine.TextLine;

import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;

import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.IAxis;
import mx.graphics.IFill;
import mx.graphics.SolidColor;

import ssen.common.DisposableUtils;
import ssen.text.EmbededFontUtils;
import ssen.text.TextLayoutFormatComponentMixin;
import ssen.text.TextLineFactory;
import ssen.text.TextLinePrinter;

public class ColumnTrendSideLabel extends CartesianChartElement {
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
	// boxWidth
	//---------------------------------------------
	private var _boxWidth:Number = 60;

	/** boxWidth */
	public function get boxWidth():Number {
		return _boxWidth;
	}

	public function set boxWidth(value:Number):void {
		_boxWidth = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// boxHeight
	//---------------------------------------------
	private var _boxHeight:Number;

	/** boxHeight */
	public function get boxHeight():Number {
		return _boxHeight;
	}

	public function set boxHeight(value:Number):void {
		_boxHeight = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// fill
	//---------------------------------------------
	private var _fill:IFill;

	/** fill */
	public function get fill():IFill {
		return _fill;
	}

	public function set fill(value:IFill):void {
		_fill = value;
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
		formatMixin.textAlign = value;
		invalidateDisplayList();
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

	private static const defaultFill:SolidColor = new SolidColor(0xeeeeee);

	private var box:Box;

	public function ColumnTrendSideLabel() {
		formatMixin = new TextLayoutFormatComponentMixin;
		formatMixin.format = new TextLayoutFormat;
		formatMixin.textAlign = TextAlign.CENTER;

		mouseEnabled = false;
		mouseChildren = false;
		mouseFocusEnabled = false;
		tabEnabled = false;
		tabChildren = false;
		tabFocusEnabled = false;

		box = new Box;
		box.parentComponent = this;
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}

	private function removedFromStage(event:Event):void {
		//		trace("ColumnTrendSideLabelElement.removedFromStage()");
		DisposableUtils.disposeDisplayContainer(this, true);
		//		removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		var chart:CartesianChart = cartesianChart;

		if (!chart || !chart["horizontalAxis"] || !(chart["horizontalAxis"] is IAxis) || !_data) {
			callLater(invalidateDisplayList);
			return;
		}

		DisposableUtils.disposeDisplayContainer(box, true);

		var w:Number = _boxWidth;
		var h:Number = _boxHeight;

		var targetBound:Rectangle = new Rectangle(0, 0, w, h);
		var targetPoint:Point = new Point(0, 0);
		var fill:IFill = (_fill) ? _fill : defaultFill;

		var g:Graphics = box.graphics;
		fill.begin(g, targetBound, targetPoint);
		g.drawRoundRect(0, 0, w, h, 4, 4);
		g.endFill();
		fill.begin(g, targetBound, targetPoint);
		g.drawCircle(0, h / 2, 5);
		g.endFill();

		//		var source:Object = dataProvider.getItemAt(dataProvider.length - 1);

		if (_labelFunction !== null) {
			var format:ITextLayoutFormat;
			var label:String;

			format = formatMixin.getFormat({data: _data});
			label = _labelFunction({data: _data, dataField: _dataField});

			var lines:Vector.<TextLine> = TextLineFactory.createTextLines(label, format, formatMixin.truncationOptions, EmbededFontUtils.getSwfContext(this, format.fontFamily, format.fontWeight === FontWeight.BOLD));
			TextLinePrinter.printTextLinesWithSpace(lines,
					box,
					w,
					h,
					0,
					0,
					0,
					0,
					formatMixin.textAlign,
					format.verticalAlign,
					false,
					false
			);

			//				g.beginFill(0, 0.3);
			//				g.drawRect(labelBound.x, labelBound.y, labelBound.width, labelBound.height);
			//				g.endFill();
		}

		var v:Number = Number(data[_dataField]);
		var y:Number = getVerticalPosition(v);

		if (parent.parent === chart) {
			var gutters:Rectangle = chart.computedGutters;
			var index:int = getIndex(chart);

			box.x = unscaledWidth + gutters.x;
			box.y = y + gutters.y - (h / 2);

			if (index === int.MAX_VALUE) {
				chart.addChild(box);
			} else {
				chart.addChildAt(box, index);
			}
		}
	}

	private function getIndex(chart:Sprite):int {
		var labelIndex:int = parent.getChildIndex(this);
		var toBoxIndex:int = int.MAX_VALUE;

		var f:int = chart.numChildren;
		var d:DisplayObject;

		var targetBox:Box;
		var targetIndex:int;

		while (--f >= 0) {
			d = chart.getChildAt(f);
			if (d is Box) {
				targetBox = d as Box;
				targetIndex = parent.getChildIndex(targetBox.parentComponent);
				if (labelIndex < targetIndex) {
					toBoxIndex = chart.getChildIndex(targetBox) - 1;
				}
			}
		}

		return toBoxIndex;
	}
}
}

import flash.display.Sprite;

import ssen.components.mxChartSupportClasses.cartesianChartElements.ColumnTrendSideLabel;

class Box extends Sprite {
	public var parentComponent:ColumnTrendSideLabel;
}