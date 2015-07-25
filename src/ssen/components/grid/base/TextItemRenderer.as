package ssen.components.grid.base {
import flash.geom.Rectangle;

import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.formats.VerticalAlign;

import mx.core.UIComponent;
import mx.formatters.IFormatter;

import ssen.common.IDisposable;
import ssen.ssen_internal;
import ssen.text.IFormattedTextComponent;
import ssen.text.LabelComponentUtils;
import ssen.text.SpriteHtmlLines;

use namespace ssen_internal;

public class TextItemRenderer extends UIComponent implements IDisposable, IFormattedTextComponent {
	ssen_internal static var isDebugMode:Boolean = false;

	private var label:SpriteHtmlLines = new SpriteHtmlLines;
	private var format:TextLayoutFormat = new TextLayoutFormat;

	public function TextItemRenderer() {
		format = new TextLayoutFormat;

		label = new SpriteHtmlLines;
		label.format = format;

		addChild(label);
	}

	//==========================================================================================
	// Style
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
	// formatter
	//---------------------------------------------
	private var _formatter:IFormatter;

	/** formatter */
	public function get formatter():IFormatter {
		return _formatter;
	}

	public function set formatter(value:IFormatter):void {
		_formatter = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// paddingLeft
	//---------------------------------------------
	private var _paddingLeft:uint = 10;

	/** paddingLeft */
	public function get paddingLeft():uint {
		return _paddingLeft;
	}

	public function set paddingLeft(value:uint):void {
		_paddingLeft = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// paddingRight
	//---------------------------------------------
	private var _paddingRight:uint = 10;

	/** paddingRight */
	public function get paddingRight():uint {
		return _paddingRight;
	}

	public function set paddingRight(value:uint):void {
		_paddingRight = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// paddingTop
	//---------------------------------------------
	private var _paddingTop:uint = 10;

	/** paddingTop */
	public function get paddingTop():uint {
		return _paddingTop;
	}

	public function set paddingTop(value:uint):void {
		_paddingTop = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// paddingBottom
	//---------------------------------------------
	private var _paddingBottom:uint = 10;

	/** paddingBottom */
	public function get paddingBottom():uint {
		return _paddingBottom;
	}

	public function set paddingBottom(value:uint):void {
		_paddingBottom = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// textAlign
	//---------------------------------------------
	/** textAlign */
	public function get textAlign():String {
		return label.textAlign;
	}

	[Inspectable(type="Array", enumeration="center,left,right", defaultValue="left")]
	public function set textAlign(value:String):void {
		format.textAlign = value;
		label.textAlign = value;
		invalidateDisplayList();
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
		invalidateDisplayList();
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
		invalidateDisplayList();
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
		invalidateDisplayList();
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
		invalidateDisplayList();
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
		invalidateDisplayList();
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
		invalidateDisplayList();
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
		invalidateDisplayList();
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
		invalidateDisplayList();
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
		invalidateDisplayList();
	}

	//---------------------------------------------
	// truncationOptions
	//---------------------------------------------
	/** truncationOptions */
	public function get truncationOptions():TruncationOptions {
		return label.truncationOptions;
	}

	public function set truncationOptions(value:TruncationOptions):void {
		label.truncationOptions = value;
		invalidateDisplayList();
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
		invalidateDisplayList();
	}

	public function getFormat():ITextLayoutFormat {
		return format;
	}

	public function setFormat(newFormat:ITextLayoutFormat):void {
		format = new TextLayoutFormat(newFormat);
	}

	//==========================================================================================
	// Render
	//==========================================================================================
	protected function getLabelText():String {
		throw new Error("TextItemRenderer.getData() not implemented");
	}

	protected function renderContent(bound:Rectangle):void {
		label.text = getLabelText();
		label.format = LabelComponentUtils.getTextLayoutFormat(this, this);
		label.createTextLines();

		switch (label.textAlign) {
			case TextAlign.RIGHT:
				label.x = bound.x + bound.width - label.width - _paddingRight;
				break;
			case TextAlign.CENTER:
				label.x = bound.x + _paddingLeft + (((bound.width - _paddingLeft - _paddingRight) - label.width) / 2 );
				break;
			default :
				label.x = bound.x + _paddingLeft;
				break;
		}

		switch (_verticalAlign) {
			case VerticalAlign.BOTTOM:
				label.y = bound.y + bound.height - label.height - _paddingBottom;
				break;
			case VerticalAlign.MIDDLE:
				label.y = bound.y + _paddingTop + (((bound.height - _paddingTop - _paddingBottom) - label.height) / 2);
				break;
			default:
				label.y = bound.y + _paddingTop;
				break;
		}

		//---------------------------------------------
		// test
		//---------------------------------------------
		if (isDebugMode) {
			const padding:int = 5;

			graphics.beginFill(0x000000, 0.1);
			graphics.drawRect(bound.x, bound.y, bound.width, bound.height);
			graphics.drawRect(bound.x + padding, bound.y + padding, bound.width - (padding * 2), bound.height - (padding * 2));
			graphics.endFill();
		}
	}

	protected function clear():void {
		graphics.clear();
	}

	public function dispose():void {
		clear();
		removeChild(label);
		label = null;
	}
}
}
