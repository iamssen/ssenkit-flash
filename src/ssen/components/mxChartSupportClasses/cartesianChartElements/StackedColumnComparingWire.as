package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.formats.TextLayoutFormat;

import mx.events.PropertyChangeEvent;
import mx.graphics.IFill;

import ssen.text.EmbededFontUtils;
import ssen.text.TextLineCache;
import ssen.text.TextLineFactory;

[Style(name="wireLabelFontFamily", inherit="no", type="String")]
[Style(name="wireLabelFontSize", inherit="no", type="int")]
[Style(name="wireLabelFontColor", inherit="no", type="String")]

public class StackedColumnComparingWire extends StackedColumnSeriesRenderBaseElement {
	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// labelFunction
	//---------------------------------------------
	private var _labelFunction:Function;

	/** labelFunction */
	[Bindable]
	public function get labelFunction():Function {
		return _labelFunction;
	}

	public function set labelFunction(value:Function):void {
		var oldValue:Function = _labelFunction;
		_labelFunction = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelFunction", oldValue, _labelFunction));
		}

		invalidateDisplayList();
	}

	//---------------------------------------------
	// colorFunction
	//---------------------------------------------
	private var _colorFunction:Function;

	/** colorFunction */
	[Bindable]
	public function get colorFunction():Function {
		return _colorFunction;
	}

	public function set colorFunction(value:Function):void {
		var oldValue:Function = _colorFunction;
		_colorFunction = value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "colorFunction", oldValue, _colorFunction));
		}

		invalidateDisplayList();
	}

	//----------------------------------------------------------------
	// caches
	//----------------------------------------------------------------
	private var textLines:TextLineCache = new TextLineCache;
	//	private var labelFormat:TextFormatManager;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function StackedColumnComparingWire() {
		//		labelFormat=new TextFormatManager({wireLabelFontFamily: "fontFamily", wireLabelFontColor: "color", wireLabelFontSize: "fontSize", wireLabelFontLookup: "fontLookup"});
	}

	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch (styleProp) {
			case "wireLabelFontFamily":
			case "wireLabelFontColor":
			case "wireLabelFontSize":
				//				labelFormat.setStyle(styleProp, getStyle(styleProp));
				break;
		}
	}

	//==========================================================================================
	// implements abstract methods
	//==========================================================================================
	/** @private */
	override protected function drawCenterOfColumns(x:int, data1:Object, data2:Object):void {
	}

	/** @private */
	override protected function drawColumnOverHead(rect:Rectangle, data:Object):void {
	}

	/** @private */
	override protected function drawWireOfColumnStacks(x:int, y:int, data1:Object, data2:Object, v1:Number, v2:Number, columnRect1:Rectangle, columnRect2:Rectangle,
													   dataField:String, fill:IFill):void {
		if (_labelFunction == null) {
			return;
		}

		if (_colorFunction !== null) {
			//			labelFormat.setStyle("color", _colorFunction(data1, data2, dataField, fill));
		}

		var str:String = _labelFunction(data1, data2, dataField);
		var textLine:TextLine = TextLineFactory.createTextLine(str, new TextLayoutFormat);
		textLine.x = x - (textLine.width / 2);
		textLine.y = y;

		addChild(textLine);
		textLines.add(textLine);
	}

	/** @private */
	override protected function begin():void {
		textLines.clear();

		var fontFamily:String;
		var fontColor:uint;
		var fontLookup:String;
		var fontSize:int;

		fontFamily = getStyle("wireLabelFontFamily") || "hyundaiLight";
		fontColor = getStyle("wireLabelFontColor") || 0x000000;
		fontLookup = EmbededFontUtils.getFontLookup(fontFamily);
		fontSize = getStyle("wireLabelFontSize") || 12;

		//		labelFormat.setStyle("wireLabelFontFamily", fontFamily);
		//		labelFormat.setStyle("wireLabelFontColor", fontColor);
		//		labelFormat.setStyle("wireLabelFontLookup", fontLookup);
		//		labelFormat.setStyle("wireLabelFontSize", fontSize);
	}
}
}
