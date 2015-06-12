package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.geom.Rectangle;
import flash.text.engine.FontWeight;
import flash.text.engine.TextLine;

import flashx.textLayout.formats.ITextLayoutFormat;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.formats.VerticalAlign;

import mx.graphics.IFill;

import ssen.common.DisposableSet;

import ssen.text.EmbededFontUtils;
import ssen.text.PrintedTextLinesInfo;
import ssen.text.TextLineFactory;
import ssen.text.TextLinePrinter;

[Style(name="overHeadLabelFontFamily", inherit="no", type="String")]
[Style(name="overHeadLabelFontSize", inherit="no", type="int")]
[Style(name="overHeadLabelFontColor", inherit="no", type="String")]
[Style(name="overHeadLabelFontWeight", inherit="no", type="String")]

public class StackedBarOverHeadLabel extends StackedBarSeriesRenderBaseElement {
	//==========================================================================================
	// properties
	//==========================================================================================
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

	//---------------------------------------------
	// formatFunction
	//---------------------------------------------
	private var _formatFunction:Function;

	/** formatFunction */
	public function get formatFunction():Function {
		return _formatFunction;
	}

	public function set formatFunction(value:Function):void {
		_formatFunction = value;
		invalidateDisplayList();
	}

	//----------------------------------------------------------------
	// caches
	//----------------------------------------------------------------
	//	private var textLines:TextLineCache = new TextLineCache;
	private var cleaner:DisposableSet = new DisposableSet;
	private var format:TextLayoutFormat;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function StackedBarOverHeadLabel() {
		format = new TextLayoutFormat;
	}

	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch (styleProp) {
			case "overHeadLabelFontFamily":
				format.fontFamily = getStyle("fontFamily");
				break;
			case "overHeadLabelFontColor":
				format.color = getStyle("color");
				break;
			case "overHeadLabelFontSize":
				format.fontSize = getStyle("fontSize");
				break;
			case "overHeadLabelFontWeight":
				format.fontSize = getStyle("fontWeight");
				break;
			default:
				format.fontFamily = getStyle("fontFamily");
				format.color = getStyle("color");
				format.fontSize = getStyle("fontSize");
				break;
		}
	}

	//==========================================================================================
	// implements abstract methods
	//==========================================================================================
	/** @private */
	override protected function begin():void {
		if (cleaner) cleaner.dispose();

		var fontFamily:String;
		var fontColor:uint;
		var fontLookup:String;
		var fontSize:int;
		var fontWeight:String;

		fontFamily = getStyle("overHeadLabelFontFamily") || "nanum";
		fontColor = getStyle("overHeadLabelFontColor") || 0x000000;
		fontLookup = EmbededFontUtils.getFontLookup(fontFamily);
		fontSize = getStyle("overHeadLabelFontSize") || 12;
		fontWeight = getStyle("overHeadLabelFontWeight") || FontWeight.NORMAL;

		format.fontFamily = fontFamily;
		format.color = fontColor;
		format.fontLookup = fontLookup;
		format.fontSize = fontSize;
		format.fontWeight = fontWeight;
	}

	/** @private */
	override protected function drawCenterOfBars(x:int, data1:Object, data2:Object):void {

	}

	/** @private */
	override protected function drawBarOverHead(rect:Rectangle, data:Object):void {
		if (_labelFunction == null) return;
		var format:ITextLayoutFormat = this.format;
		if (_formatFunction !== null) format = _formatFunction(data, format);

		var str:String = _labelFunction(data);
		var lines:Vector.<TextLine> = TextLineFactory.createTextLines(str, format);

		var printed:PrintedTextLinesInfo = TextLinePrinter.printTextLinesWithSpace(lines,
				this,
				1000,
				rect.height + rect.y,
				rect.width + 10,
				0,
				rect.y,
				0,
				TextAlign.LEFT,
				VerticalAlign.MIDDLE,
				false,
				false);

		cleaner.add(printed.disposer);

		//		var line:TextLine;
		//
		//		var f:int = lines.length;
		//		var ny:int = rect.y;
		//
		//		while (--f >= 0) {
		//			line = lines[f];
		//
		//			ny = ny - line.height;
		//
		//			line.x = rect.x - (line.width / 2) + (rect.width / 2);
		//			line.y = ny;
		//
		//			addChild(line);
		//			textLines.add(line);
		//		}
	}

	/** @private */
	override protected function drawWireOfBarStacks(x:int,
													y:int,
													data1:Object,
													data2:Object,
													v1:Number,
													v2:Number,
													columnRect1:Rectangle,
													columnRect2:Rectangle,
													dataField:String,
													fill:IFill):void {
	}
}
}
