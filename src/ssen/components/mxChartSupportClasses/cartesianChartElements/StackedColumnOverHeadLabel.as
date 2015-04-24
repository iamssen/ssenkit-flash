package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.formats.TextLayoutFormat;

import mx.events.PropertyChangeEvent;
import mx.graphics.IFill;

import ssen.text.EmbededFontUtils;
import ssen.text.TextLineCache;
import ssen.text.TextLineFactory;

[Style(name="overHeadLabelFontFamily", inherit="no", type="String")]
[Style(name="overHeadLabelFontSize", inherit="no", type="int")]
[Style(name="overHeadLabelFontColor", inherit="no", type="String")]

public class StackedColumnOverHeadLabel extends StackedColumnSeriesRenderBaseElement {
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

	//----------------------------------------------------------------
	// caches
	//----------------------------------------------------------------
	private var textLines:TextLineCache = new TextLineCache;
	//	private var labelFormat:TextFormatManager;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function StackedColumnOverHeadLabel() {
		//		labelFormat = new TextFormatManager({
		//			overHeadLabelFontFamily: "fontFamily", overHeadLabelFontColor: "color", overHeadLabelFontSize: "fontSize",
		//			overHeadLabelFontLookup: "fontLookup"
		//		});
	}

	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch (styleProp) {
			case "overHeadLabelFontFamily":
			case "overHeadLabelFontColor":
			case "overHeadLabelFontSize":
				//				labelFormat.setStyle(styleProp, getStyle(styleProp));
				break;
		}
	}

	//==========================================================================================
	// implements abstract methods
	//==========================================================================================
	/** @private */
	override protected function begin():void {
		textLines.clear();

		var fontFamily:String;
		var fontColor:uint;
		var fontLookup:String;
		var fontSize:int;

		fontFamily = getStyle("overHeadLabelFontFamily") || "hyundaiLight";
		fontColor = getStyle("overHeadLabelFontColor") || 0x000000;
		fontLookup = EmbededFontUtils.getFontLookup(fontFamily);
		fontSize = getStyle("overHeadLabelFontSize") || 12;

		//		labelFormat.setStyle("overHeadLabelFontFamily", fontFamily);
		//		labelFormat.setStyle("overHeadLabelFontColor", fontColor);
		//		labelFormat.setStyle("overHeadLabelFontLookup", fontLookup);
		//		labelFormat.setStyle("overHeadLabelFontSize", fontSize);
	}

	/** @private */
	override protected function drawCenterOfColumns(x:int, data1:Object, data2:Object):void {

	}

	/** @private */
	override protected function drawColumnOverHead(rect:Rectangle, data:Object):void {
		if (_labelFunction == null) {
			return;
		}

		var str:String = _labelFunction(data);
		var lines:Vector.<TextLine> = TextLineFactory.createTextLines(str, new TextLayoutFormat);
		var line:TextLine;

		var f:int = lines.length;
		var ny:int = rect.y;

		while (--f >= 0) {
			line = lines[f];

			ny = ny - line.height;

			line.x = rect.x - (line.width / 2) + (rect.width / 2);
			line.y = ny;

			addChild(line);
			textLines.add(line);
		}
	}

	/** @private */
	override protected function drawWireOfColumnStacks(x:int, y:int, data1:Object, data2:Object, v1:Number, v2:Number, columnRect1:Rectangle, columnRect2:Rectangle,
													   dataField:String, fill:IFill):void {
	}
}
}
