package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import flash.geom.Rectangle;
import flash.text.engine.FontLookup;
import flash.text.engine.TextLine;

import mx.charts.LinearAxis;
import mx.events.PropertyChangeEvent;

import flashx.textLayout.compose.TextLineRecycler;
import flashx.textLayout.factory.StringTextLineFactory;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.formats.VerticalAlign;

import ssen.common.StringUtils;

/** Bubble Chart 내부에 기준선을 그리는 Chart Element */
public class AdvancedBubbleChartBaseLineElement extends AdvancedBubbleChartElement {
	//---------------------------------------------
	// horizontalLineEnabled
	//---------------------------------------------
	private var _horizontalLineEnabled:Boolean;

	/** 세로선(X축)을 그릴지 여부 */
	[Bindable]
	public function get horizontalLineEnabled():Boolean {
		return _horizontalLineEnabled;
	}

	public function set horizontalLineEnabled(value:Boolean):void {
		var oldValue:Boolean=_horizontalLineEnabled;
		_horizontalLineEnabled=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalLineEnabled", oldValue, _horizontalLineEnabled));
		}

		invalidateDisplayList();
	}

	//---------------------------------------------
	// verticalLineEnabled
	//---------------------------------------------
	private var _verticalLineEnabled:Boolean;

	/** 가로선(Y축)을 그릴지 여부 */
	[Bindable]
	public function get verticalLineEnabled():Boolean {
		return _verticalLineEnabled;
	}

	public function set verticalLineEnabled(value:Boolean):void {
		var oldValue:Boolean=_verticalLineEnabled;
		_verticalLineEnabled=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "verticalLineEnabled", oldValue, _verticalLineEnabled));
		}

		invalidateDisplayList();
	}

	//---------------------------------------------
	// horizontalLineLabel
	//---------------------------------------------
	private var _horizontalLineLabel:String;

	/** 세로선(X축)에 그릴 텍스트 */
	[Bindable]
	public function get horizontalLineLabel():String {
		return _horizontalLineLabel;
	}

	public function set horizontalLineLabel(value:String):void {
		var oldValue:String=_horizontalLineLabel;
		_horizontalLineLabel=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalLineLabel", oldValue, _horizontalLineLabel));
		}

		hLabelChanged=true;
		invalidateProperties();
	}

	//---------------------------------------------
	// verticalLineLabel
	//---------------------------------------------
	private var _verticalLineLabel:String;

	/** 가로선(Y축)에 그릴 텍스트 */
	[Bindable]
	public function get verticalLineLabel():String {
		return _verticalLineLabel;
	}

	public function set verticalLineLabel(value:String):void {
		var oldValue:String=_verticalLineLabel;
		_verticalLineLabel=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "verticalLineLabel", oldValue, _verticalLineLabel));
		}

		vLabelChanged=true;
		invalidateProperties();
	}

	//---------------------------------------------
	// horizontalLineValue
	//---------------------------------------------
	private var _horizontalLineValue:Number;

	/** 세로선(X축)의 값 (horizontalAxis의 minimum, maximum과 비교해서 비율적으로 그리게 된다) */
	[Bindable]
	public function get horizontalLineValue():Number {
		return _horizontalLineValue;
	}

	public function set horizontalLineValue(value:Number):void {
		var oldValue:Number=_horizontalLineValue;
		_horizontalLineValue=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalLineValue", oldValue, _horizontalLineValue));
		}

		invalidateDisplayList();
	}

	//---------------------------------------------
	// verticalLineValue
	//---------------------------------------------
	private var _verticalLineValue:Number;

	/** 가로선(Y축)의 값 (verticalAxis의 minimum, maximum과 비교해서 비율적으로 그리게 된다) */
	[Bindable]
	public function get verticalLineValue():Number {
		return _verticalLineValue;
	}

	public function set verticalLineValue(value:Number):void {
		var oldValue:Number=_verticalLineValue;
		_verticalLineValue=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "verticalLineValue", oldValue, _verticalLineValue));
		}

		invalidateDisplayList();
	}

	//---------------------------------------------
	// horizontalLineColor
	//---------------------------------------------
	private var _horizontalLineColor:uint;

	/** 세로선(X축)의 색상 */
	[Bindable]
	public function get horizontalLineColor():uint {
		return _horizontalLineColor;
	}

	public function set horizontalLineColor(value:uint):void {
		var oldValue:uint=_horizontalLineColor;
		_horizontalLineColor=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalLineColor", oldValue, _horizontalLineColor));
		}

		invalidateDisplayList();
	}

	//---------------------------------------------
	// verticalLineColor
	//---------------------------------------------
	private var _verticalLineColor:uint;

	/** 가로선(Y축)의 색상 */
	[Bindable]
	public function get verticalLineColor():uint {
		return _verticalLineColor;
	}

	public function set verticalLineColor(value:uint):void {
		var oldValue:uint=_verticalLineColor;
		_verticalLineColor=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "verticalLineColor", oldValue, _verticalLineColor));
		}

		invalidateDisplayList();
	}


	//==========================================================================================
	// constructor
	//==========================================================================================
	private var vLabelChanged:Boolean;
	private var hLabelChanged:Boolean;

	//	private var hLabelComponent:Label;
	//	private var vLabelComponent:Label;

	public function AdvancedBubbleChartBaseLineElement() {
		//		vLabelComponent=getLabelComponent();
		//		vLabelComponent.setStyle("textAlign", TextAlign.RIGHT);
		//		vLabelComponent.setStyle("verticalAlign", VerticalAlign.BOTTOM);
		//		addChild(vLabelComponent);
		//
		//		hLabelComponent=getLabelComponent();
		//		hLabelComponent.setStyle("textAlign", TextAlign.LEFT);
		//		hLabelComponent.setStyle("verticalAlign", VerticalAlign.TOP);
		//		addChild(hLabelComponent);

		mouseChildren=false;
		mouseEnabled=false;
		mouseFocusEnabled=false;
		tabChildren=false;
		tabEnabled=false;
		tabFocusEnabled=false;
	}

	//	private function getLabelComponent():Label {
	//		var label:Label=new Label;
	//		label.maxDisplayedLines=1;
	//		label.setStyle("fontFamily", "mainfont");
	//		label.setStyle("fontSize", 13);
	//		label.setStyle("color", 0xcccccc);
	//		label.width=300;
	//		label.height=200;
	//		return label;
	//	}

	//==========================================================================================
	// rendering
	//==========================================================================================
	/** @private */
	override protected function commitProperties():void {
		super.commitProperties();

		if (hLabelChanged || vLabelChanged) {
			hLabelChanged=false;
			vLabelChanged=false;
			invalidateDisplayList();
		}

		//		if (hLabelChanged) {
		//			hLabelComponent.text=horizontalLineLabel;
		//			hLabelComponent.invalidateDisplayList();
		//			hLabelChanged=false;
		//			invalidateDisplayList();
		//		}
		//
		//		if (vLabelChanged) {
		//			vLabelComponent.text=verticalLineLabel;
		//			vLabelChanged=false;
		//			invalidateDisplayList();
		//		}
	}

	/** @private */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var haxis:LinearAxis=getHorizontalAxis();
		var vaxis:LinearAxis=getVerticalAxis();

		var x:int, y:int;

		graphics.clear();
		clearTexts();
		//		hLabelComponent.visible=false;
		//		vLabelComponent.visible=false;

		if (_horizontalLineEnabled) {
			var xratio:Number=(_horizontalLineValue - haxis.minimum) / (haxis.maximum - haxis.minimum);

			if (xratio > 0 && xratio < 1) {
				x=getHorizontalPosition(_horizontalLineValue);
				//				x=xratio * unscaledWidth;
				vr(x, unscaledHeight, _horizontalLineColor);
				printHorizontalText(horizontalLineLabel, x);

					//				hLabelComponent.width=150;
					//				hLabelComponent.height=40;
					//				hLabelComponent.x=x + 5;
					//				hLabelComponent.y=0;
					//
					//				hLabelComponent.setStyle("color", _horizontalLineColor);
					//
					//				hLabelComponent.visible=true;
			}
		}

		if (_verticalLineEnabled) {
			var yratio:Number=(_verticalLineValue - vaxis.minimum) / (vaxis.maximum - vaxis.minimum);

			if (yratio > 0 && yratio < 1) {
				y=getVerticalPosition(_verticalLineValue);
				//				y=yratio * unscaledHeight;
				hr(y, unscaledWidth, _verticalLineColor);
				printVerticalText(verticalLineLabel, y);

					//				vLabelComponent.width=150;
					//				vLabelComponent.height=40;
					//				vLabelComponent.x=unscaledWidth - vLabelComponent.width;
					//				vLabelComponent.y=y - vLabelComponent.height - 5;
					//
					//				vLabelComponent.setStyle("color", _verticalLineColor);
					//
					//				vLabelComponent.visible=true;
			}
		}
	}

	/** @private */
	override public function mappingChanged():void {
		invalidateDisplayList();
	}


	private function hr(y:Number, w:Number, color:uint):void {
		var dot:int=4;
		var dash:int=3;
		var rect:Rectangle=new Rectangle(0, y - 1, dot, 2);

		graphics.beginFill(color);

		while (rect.x < w) {
			rect.width=(rect.x + dot > w) ? w - rect.x : dot;

			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);

			rect.x=rect.x + dot + dash;
		}

		graphics.endFill();
	}

	private function vr(x:Number, h:Number, color:uint):void {
		var dot:int=4;
		var dash:int=3;
		var rect:Rectangle=new Rectangle(x - 1, 0, 2, dot);

		graphics.beginFill(color);

		while (rect.y < h) {
			rect.height=(rect.y + dot > h) ? h - rect.y : dot;

			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);

			rect.y=rect.y + dot + dash;
		}

		graphics.endFill();
	}

	//==========================================================================================
	// text control
	//==========================================================================================
	//---------------------------------------------
	// verticalTextWidth
	//---------------------------------------------
	private var _verticalTextWidth:int;

	/** verticalTextWidth */
	[Bindable(event="propertyChange")]
	public function get verticalTextWidth():int {
		return _verticalTextWidth;
	}

	//---------------------------------------------
	// horizontalTextHeight
	//---------------------------------------------
	private var _horizontalTextHeight:int;

	/** horizontalTextHeight */
	[Bindable(event="propertyChange")]
	public function get horizontalTextHeight():int {
		return _horizontalTextHeight;
	}

	//---------------------------------------------
	// verticalTextGap
	//---------------------------------------------
	private var _verticalTextGap:int;

	/** verticalTextGap */
	[Bindable]
	public function get verticalTextGap():int {
		return _verticalTextGap;
	}

	public function set verticalTextGap(value:int):void {
		var oldValue:int=_verticalTextGap;
		_verticalTextGap=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "verticalTextGap", oldValue, _verticalTextGap));
		}

		invalidateDisplayList();
	}

	//---------------------------------------------
	// horizontalTextGap
	//---------------------------------------------
	private var _horizontalTextGap:int;

	/** horizontalTextGap */
	[Bindable]
	public function get horizontalTextGap():int {
		return _horizontalTextGap;
	}

	public function set horizontalTextGap(value:int):void {
		var oldValue:int=_horizontalTextGap;
		_horizontalTextGap=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalTextGap", oldValue, _horizontalTextGap));
		}

		invalidateDisplayList();
	}

	private var textLines:Vector.<TextLine>=new Vector.<TextLine>;

	private static var strFac:StringTextLineFactory=new StringTextLineFactory;
	private static var strRect:Rectangle=new Rectangle;
	private static var textFormat:TextLayoutFormat;

	private function printVerticalText(label:String, y:int):void {
		var oldVerticalTextWidth:int=_verticalTextWidth;
		_verticalTextWidth=0;

		if (!StringUtils.isBlank(label)) {
			var format:TextLayoutFormat=getTextFormat();

			strRect.x=0;
			strRect.y=y - 50;
			strRect.width=unscaledWidth;
			strRect.height=50;

			format.textAlign=TextAlign.RIGHT;
			format.verticalAlign=VerticalAlign.BOTTOM;
			format.paddingRight=(_verticalTextGap > 0) ? _verticalTextGap + 10 : 0;
			format.paddingLeft=0;
			format.paddingTop=0;
			format.paddingBottom=5;
			format.color=_verticalLineColor;

			strFac.textFlowFormat=format;
			strFac.compositionBounds=strRect;
			strFac.text=label;
			strFac.createTextLines(function(line:TextLine):void {
				addChild(line);

				line.mouseEnabled=false;
				line.mouseChildren=false;

				textLines.push(line);

				_verticalTextWidth=line.width;
			});
		}

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "verticalTextWidth", oldVerticalTextWidth, _verticalTextWidth));
		}
	}

	private function printHorizontalText(label:String, x:int):void {
		var oldHorizontalTextHeight:int=_horizontalTextHeight;
		_horizontalTextHeight=0;

		if (!StringUtils.isBlank(label)) {
			var format:TextLayoutFormat=getTextFormat();

			strRect.x=x;
			strRect.y=(_horizontalTextGap > 0) ? _horizontalTextGap + 5 : 0;
			strRect.width=500;
			strRect.height=100;

			format.textAlign=TextAlign.LEFT;
			format.verticalAlign=VerticalAlign.TOP;
			format.paddingRight=0;
			format.paddingLeft=5;
			format.paddingTop=0;
			format.paddingBottom=0;
			format.color=_horizontalLineColor;

			strFac.textFlowFormat=format;
			strFac.compositionBounds=strRect;
			strFac.text=label;
			strFac.createTextLines(function(line:TextLine):void {
				addChild(line);

				line.mouseEnabled=false;
				line.mouseChildren=false;

				textLines.push(line);

				_horizontalTextHeight=line.height;
			});
		}

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "horizontalTextHeight", oldHorizontalTextHeight, _horizontalTextHeight));
		}
	}

	private function getTextFormat():TextLayoutFormat {
		if (!textFormat) {
			textFormat=new TextLayoutFormat;
			textFormat.fontSize=12;
			textFormat.fontLookup=FontLookup.EMBEDDED_CFF;
			textFormat.fontFamily="mainfont";
		}

		return textFormat;
	}

	private function clearTexts():void {
		if (!textLines) {
			return;
		}

		var f:int=textLines.length;
		var line:TextLine;
		while (--f >= 0) {
			line=textLines[f];
			removeChild(line);
			TextLineRecycler.addLineForReuse(line);
		}
		textLines.length=0;
	}
}
}
