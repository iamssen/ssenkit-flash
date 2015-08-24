package ssen.components.chart.pola.pieAxis {
import com.greensock.easing.Quad;

import flash.events.EventDispatcher;
import flash.geom.Rectangle;

import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;

import mx.collections.IList;
import mx.core.UIComponent;

import ssen.components.animate.AnimationTrack;
import ssen.components.chart.pola.PolaChart;
import ssen.drawing.DrawingUtils;
import ssen.text.IFormattedTextComponent;
import ssen.text.LabelComponentUtils;
import ssen.text.SpriteHtmlLines;
[Deprecated(message="Remove when end of project")]
public class PieCenterLabel extends EventDispatcher implements IPieElement, IFormattedTextComponent {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// style
	//----------------------------------------------------------------
	public var radiusRatio:Number = 1;

	//----------------------------------------------------------------
	// animate
	//----------------------------------------------------------------
	public var animationTrack:AnimationTrack = new AnimationTrack(0, 1, Quad.easeOut);
	private var lastAnimationRatio:Number;

	//----------------------------------------------------------------
	// text
	//----------------------------------------------------------------
	//---------------------------------------------
	// text
	//---------------------------------------------
	private var textChanged:Boolean;

	/** text */
	public function get text():String {
		return display.text;
	}

	public function set text(value:String):void {
		display.text = value;
		textChanged = true;
	}

	//==========================================================================================
	// compute
	//==========================================================================================
	public function computeMaximumValue(dataProvider:IList):Number {
		return NaN;
	}

	//==========================================================================================
	// render
	//==========================================================================================
	private var display:SpriteHtmlLines;

	public function PieCenterLabel() {
		format = new TextLayoutFormat;

		display = new SpriteHtmlLines;
		display.textAlign = TextAlign.CENTER;

		display.mouseChildren = false;
		display.mouseEnabled = false;
		display.tabChildren = false;
		display.tabEnabled = false;
	}

	public function render(axis:PieAxis, chart:PolaChart, targetContainer:UIComponent, animationRatio:Number):void {
		//----------------------------------------------------------------
		// time tracking
		//----------------------------------------------------------------
		animationRatio = animationTrack.getTime(animationRatio);

		if (isNaN(animationRatio)) {
			display.alpha = 0;
			return;
		} else if (animationRatio === lastAnimationRatio) {
			return;
		}

		lastAnimationRatio = animationRatio;

		//----------------------------------------------------------------
		// init display
		//----------------------------------------------------------------
		targetContainer.addChild(display);

		//----------------------------------------------------------------
		// coordinate info
		//----------------------------------------------------------------
		var radius:Number = chart.computedContentRadius * axis.drawRadiusRatio * this.radiusRatio;

		//----------------------------------------------------------------
		// draw
		//----------------------------------------------------------------
		if (textChanged) {
			display.format = LabelComponentUtils.getTextLayoutFormat(this);
			display.createTextLines();
			textChanged = false;
		}

		var ratio:Number = DrawingUtils.getScalingMinimizeRatio(new Rectangle(0, 0, display.width, display.height), new Rectangle(0, 0, radius * 2, radius * 2));
		ratio = ratio * animationRatio;

		display.alpha = animationRatio;
		display.x = ((display.width * ratio) / -2) + chart.computedCenterX;
		display.y = ((display.height * ratio) / -2) + chart.computedCenterY;
		display.scaleX = ratio;
		display.scaleY = ratio;
	}

	//==========================================================================================
	// implements IFormattedTextComponent
	//==========================================================================================
	//----------------------------------------------------------------
	// style
	//----------------------------------------------------------------
	private var format:TextLayoutFormat;

	//---------------------------------------------
	// textAlign
	//---------------------------------------------
	/** textAlign */
	public function get textAlign():String {
		return display.textAlign;
	}

	[Inspectable(type="Array", enumeration="center,left,right", defaultValue="left")]
	public function set textAlign(value:String):void {
		format.textAlign = value;
		display.textAlign = value;
		textChanged = true;
	}

	//---------------------------------------------
	// verticalAlign
	//---------------------------------------------
	private var _verticalAlign:String = "top";

	/** verticalAlign */
	public function get verticalAlign():String {
		return _verticalAlign;
	}

	[Inspectable(type="Array", enumeration="top,middle,bottom", defaultValue="top")]
	public function set verticalAlign(value:String):void {
		_verticalAlign = value;
		textChanged = true;
	}

	//---------------------------------------------
	// fontLookup
	//---------------------------------------------
	/** fontLookup */
	public function get fontLookup():String {
		return format.fontLookup;
	}

	[Inspectable(type="Array", enumeration="auto,device,embeddedCFF", defaultValue="device")]
	public function set fontLookup(value:String):void {
		format.fontLookup = value;
		textChanged = true;
	}

	//---------------------------------------------
	// color
	//---------------------------------------------
	/** color */
	public function get color():uint {
		return format.color;
	}

	public function set color(value:uint):void {
		format.color = value;
		textChanged = true;
	}

	//---------------------------------------------
	// fontFamily
	//---------------------------------------------
	/** fontFamily */
	public function get fontFamily():String {
		return format.fontFamily;
	}

	public function set fontFamily(value:String):void {
		format.fontFamily = value;
		textChanged = true;
	}

	//---------------------------------------------
	// fontSize
	//---------------------------------------------
	/** fontSize */
	public function get fontSize():uint {
		return format.fontSize;
	}

	public function set fontSize(value:uint):void {
		format.fontSize = value;
		textChanged = true;
	}

	//---------------------------------------------
	// fontWeight
	//---------------------------------------------
	/** fontWeight */
	public function get fontWeight():String {
		return format.fontWeight;
	}

	[Inspectable(type="Array", enumeration="normal,bold", defaultValue="normal")]
	public function set fontWeight(value:String):void {
		format.fontWeight = value;
		textChanged = true;
	}

	//---------------------------------------------
	// lineHeight
	//---------------------------------------------
	/** lineHeight */
	public function get lineHeight():Object {
		return format.lineHeight;
	}

	public function set lineHeight(value:Object):void {
		format.lineHeight = value;
		textChanged = true;
	}

	//---------------------------------------------
	// trackingLeft
	//---------------------------------------------
	/** trackingLeft */
	public function get trackingLeft():Object {
		return format.trackingLeft;
	}

	public function set trackingLeft(value:Object):void {
		format.trackingLeft = value;
		textChanged = true;
	}

	//---------------------------------------------
	// trackingRight
	//---------------------------------------------
	/** trackingRight */
	public function get trackingRight():Object {
		return format.trackingRight;
	}

	public function set trackingRight(value:Object):void {
		format.trackingRight = value;
		textChanged = true;
	}

	//---------------------------------------------
	// truncationOptions
	//---------------------------------------------
	/** truncationOptions */
	public function get truncationOptions():TruncationOptions {
		return display.truncationOptions;
	}

	public function set truncationOptions(value:TruncationOptions):void {
		display.truncationOptions = value;
		textChanged = true;
	}

	//---------------------------------------------
	// textFormatFunction
	//---------------------------------------------
	private var _textFormatFunction:Function;

	/** textFormatFunction */
	public function get textFormatFunction():Function {
		return _textFormatFunction;
	}

	public function set textFormatFunction(value:Function):void {
		_textFormatFunction = value;
		textChanged = true;
	}

	public function getFormat():ITextLayoutFormat {
		return format;
	}

	public function setFormat(newFormat:ITextLayoutFormat):void {
		format = new TextLayoutFormat(newFormat);
		textChanged = true;
	}
}
}
