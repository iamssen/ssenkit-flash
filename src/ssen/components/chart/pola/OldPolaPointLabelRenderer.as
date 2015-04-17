package ssen.components.chart.pola {
import flash.display.Graphics;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import flash.text.engine.FontWeight;
import flash.text.engine.TextLine;

import flashx.textLayout.compose.ISWFContext;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;

import mx.core.UIComponent;

import ssen.common.MathUtils;
import ssen.text.EmbededFontUtils;
import ssen.text.TextLineCache;
import ssen.text.TextLineFactory;

public class OldPolaPointLabelRenderer extends UIComponent implements IPolaPointRenderer {
	//	IDataTipChartElement,

	//----------------------------------------------------------------
	// label data
	//----------------------------------------------------------------
	/** labelField */
	public var labelField:String;

	/** labelFunction `function(data:Object, labelField:String):String` */
	public var labelFunction:Function;

	//----------------------------------------------------------------
	// font style
	//----------------------------------------------------------------
	public var fontFamily:String = "_sans";
	public var fontSize:int = 12;
	public var fontColor:uint = 0x000000;
	public var fontWeight:String = "normal";

	[Inspectable(type="Array", enumeration="center,left,right", defaultValue="left")]
	public var textAlign:String = "center";

	private static var format:TextLayoutFormat;

	//---------------------------------------------
	// item
	//---------------------------------------------
	private var _item:Object;

	/** item */
	public function get item():Object {
		return _item;
	}

	public function set item(value:Object):void {
		_item = value;
	}

	//---------------------------------------------
	// dispatchTarget
	//---------------------------------------------
	private var _dispatchTarget:IEventDispatcher;

	/** dispatchTarget */
	public function get dispatchTarget():IEventDispatcher {
		return _dispatchTarget;
	}

	public function set dispatchTarget(value:IEventDispatcher):void {
		_dispatchTarget = value;
	}

	//	private var chartDataTip:ChartDataTip;

	private var textLines:TextLineCache;
	//	private static var factory:TextFlowTextLineFactory;

	public function OldPolaPointLabelRenderer() {
		textLines = new TextLineCache;

		//		if (!factory) {
		//			factory = new TextFlowTextLineFactory();
		//			factory.compositionBounds = new Rectangle(0, 0, 1000, 1000);
		//			format = new TextLayoutFormat;
		//		}

		if (!format) format = new TextLayoutFormat;

		addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
		addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
	}

	protected function setTextStyle(format:TextLayoutFormat):void {
		format.fontFamily = fontFamily;
		format.fontLookup = EmbededFontUtils.getFontLookup(fontFamily, fontWeight === FontWeight.BOLD);
		format.fontSize = fontSize;
		format.color = fontColor;
		format.textAlign = textAlign;
	}

	public function setPoint(centerX:Number, centerY:Number, pointX:Number, pointY:Number):void {
		//----------------------------------------------------------------
		// create label
		//----------------------------------------------------------------
		//		var textFlow:TextFlow;

		//		if (labelFunction !== null) {
		//			textFlow = TextLineFactory.getTextFlow(labelFunction(item, labelField));
		//		} else {
		//			textFlow = TextLineFactory.getTextFlow(item[labelField]);
		//		}

		//		var lines:Vector.<TextLine> = new Vector.<TextLine>();
		var f:int;
		var fmax:int;
		var line:TextLine;
		var w:Number = Number.MIN_VALUE;
		var h:Number = 0;
		var swfContext:ISWFContext = EmbededFontUtils.getSwfContext(this, fontFamily, fontWeight === FontWeight.BOLD);

		setTextStyle(format);
		//		textFlow.format = format;

		var lines:Vector.<TextLine>;

		if (labelFunction !== null) {
			lines = TextLineFactory.createTextLines(labelFunction(item, labelField), format, null, swfContext);
			//			textFlow = TextLineFactory.getTextFlow(labelFunction(item, labelField));
		} else {
			lines = TextLineFactory.createTextLines(item[labelField], format, null, swfContext);
			//			textFlow = TextLineFactory.getTextFlow(item[labelField]);
		}

		//---------------------------------------------
		// create and analyze text lines
		//---------------------------------------------
		//		factory.createTextLines(function (line:TextLine):void {
		f = -1;
		fmax = lines.length;
		while (++f < fmax) {
			line = lines[f];
			if (line.width > w) w = line.width;
			h = line.y + line.height - line.ascent;
			addChild(line);
			textLines.add(line);
		}
		//		}, textFlow);


		//---------------------------------------------
		// align text lines
		//---------------------------------------------
		if (format.textAlign === TextAlign.CENTER) {
			f = lines.length;
			while (--f >= 0) {
				line = lines[f];
				line.x = (w - line.width) / 2;
			}
		} else if (format.textAlign === TextAlign.RIGHT) {
			f = lines.length;
			while (--f >= 0) {
				line = lines[f];
				line.x = w - line.width;
			}
		}

		setActualSize(w, h);

		var g:Graphics = graphics;
		g.beginFill(0, 0);
		g.drawRect(0, 0, width, height);
		g.endFill();

		buttonMode = true;

		//----------------------------------------------------------------
		// set point
		//----------------------------------------------------------------
		if (MathUtils.rangeOf(pointX, centerX - 10, centerX + 10)) {
			pointX = pointX - (width / 2);
		} else if (pointX < centerX) {
			pointX = pointX - width;
		}

		if (MathUtils.rangeOf(pointY, centerY - 10, centerY + 10)) {
			pointY = pointY - (height / 2);
		} else if (pointY < centerY) {
			pointY = pointY - height;
		}

		x = pointX;
		y = pointY;
	}

	//==========================================================================================
	// life cycle
	//==========================================================================================
	public function dispose():void {
		removeEventListener(MouseEvent.CLICK, clickHandler);
		item = null;
		dispatchTarget = null;
	}

	public function clear():void {
		textLines.clear();
		graphics.clear();
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	private function rollOutHandler(event:MouseEvent):void {
		//		if (!chartDataTip) {
		//			return;
		//		}
		//
		//		PopUpManager.removePopUp(chartDataTip);
		//		chartDataTip = null;
	}

	private function rollOverHandler(event:MouseEvent):void {
		//		if (_chartDataTipFunction === null || chartDataTip) {
		//			return;
		//		}
		//
		//		var hit:HitData = new HitData(0, 0, 0, 0, new ChartItem(this, item));
		//		var tip:ChartDataTip = new ChartDataTip;
		//		tip.data = hit;
		//
		//		var sw:int = stage.stageWidth;
		//		var pos:Point = parent.localToGlobal(new Point(x, y));
		//
		//		PopUpManager.addPopUp(tip, this);
		//		tip.validateNow();
		//
		//		chartDataTip = tip;
		//
		//		var tx:int = pos.x;
		//		var ty:int = pos.y - chartDataTip.height - 10;
		//
		//		if (ty < 0) {
		//			ty = pos.y + height + 10;
		//		}
		//
		//		if (tx + chartDataTip.width > sw) {
		//			tx = sw - chartDataTip.width;
		//		}
		//
		//		chartDataTip.x = tx;
		//		chartDataTip.y = ty;
	}

	private function clickHandler(event:MouseEvent):void {
		var evt:PolaChartEvent = new PolaChartEvent(PolaChartEvent.ITEM_CLICK);
		evt.item = item;
		dispatchTarget.dispatchEvent(evt);
	}

	//==========================================================================================
	// implements for Data Tip
	//==========================================================================================
	//----------------------------------------------------------------
	// IChartElement
	//----------------------------------------------------------------
//	public function set chartDataProvider(value:Object):void {
//
//
//	}
//
//	public function chartStateChanged(oldState:uint, v:uint):void {
//
//
//	}
//
//	public function claimStyles(styles:Array, firstAvailable:uint):uint {
//
//		return 0;
//	}
//
//	public function collectTransitions(chartState:Number, transitions:Array):void {
//
//
//	}
//
//	public function set dataTransform(value:DataTransform):void {
//
//
//	}
//
//	public function describeData(dimension:String, requiredFields:uint):Array {
//
//		return null;
//	}
//
//	public function findDataPoints(x:Number, y:Number, sensitivity2:Number):Array {
//
//		return null;
//	}
//
//	public function get labelContainer():Sprite {
//
//		return null;
//	}
//
//	public function mappingChanged():void {
//
//
//	}

	//----------------------------------------------------------------
	// IDataTipChartElement
	//----------------------------------------------------------------
//	private var _chartDataTipFunction:Function;
//
//	/** chartDataTipFunction */
//	public function get chartDataTipFunction():Function {
//		return _chartDataTipFunction;
//	}
//
//	public function set chartDataTipFunction(value:Function):void {
//		_chartDataTipFunction = value;
//	}

	//	public function getChartDataTip(hitData:HitData):DataTipItem {
	//		if (_chartDataTipFunction != null) {
	//			return _chartDataTipFunction(hitData);
	//		}
	//		return null;
	//	}
}
}
