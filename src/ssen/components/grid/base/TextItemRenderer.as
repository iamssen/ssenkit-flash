package ssen.components.grid.base {
import flash.geom.Rectangle;

import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.formats.VerticalAlign;

import mx.core.UIComponent;
import mx.formatters.IFormatter;

import ssen.common.IDisposable;
import ssen.common.NullUtils;
import ssen.text.HtmlLabel;

// [Style(name="fontLookup", type="String", enumeration="auto,device,embeddedCFF", inherit="yes")]
// [Style(name="fontStyle", type="String", enumeration="normal,italic", inherit="yes")]
//[Style(name="textAlign", type="String", enumeration="left,right,center", inherit="yes")]
[Style(name="color", type="uint", format="Color", inherit="yes")]
[Style(name="fontFamily", type="String", inherit="yes")]
[Style(name="fontSize", type="Number", format="Length", inherit="yes", minValue="1.0", maxValue="720.0")]
[Style(name="fontWeight", type="String", enumeration="normal,bold", inherit="yes")]
[Style(name="lineHeight", type="Object", inherit="yes")]
[Style(name="trackingLeft", type="Object", inherit="yes")]
[Style(name="trackingRight", type="Object", inherit="yes")]

public class TextItemRenderer extends UIComponent implements IDisposable {
	private var label:HtmlLabel = new HtmlLabel;
	private var format:TextLayoutFormat = new TextLayoutFormat;

	public function TextItemRenderer() {
		format = new TextLayoutFormat;

		label = new HtmlLabel;
		label.format = format;

		addChild(label);
	}

	//==========================================================================================
	// Style
	//==========================================================================================
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

	public function set verticalAlign(value:String):void {
		_verticalAlign = value;
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

	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);

		switch (styleProp) {
			case "color":
				format.color = getStyle(styleProp);
				break;
			case "fontFamily":
				format.fontFamily = getStyle(styleProp);
				break;
			case "fontSize":
				format.fontSize = getStyle(styleProp);
				break;
			case "fontWeight":
				format.fontWeight = getStyle(styleProp);
				break;
			case "lineHeight":
				format.lineHeight = getStyle(styleProp);
				break;
			case "textAlign":
				format.textAlign = getStyle(styleProp);
				break;
			case "trackingLeft":
				format.trackingLeft = getStyle(styleProp);
				break;
			case "trackingRight":
				format.trackingRight = getStyle(styleProp);
				break;
			default:
				format.color = NullUtils.nanTo(getStyle("color"), 0x000000);
				format.fontFamily = NullUtils.nullTo(getStyle("fontFamily"), "_sans");
				format.fontSize = NullUtils.nanTo(getStyle("fontSize"), 12);
				format.fontWeight = NullUtils.nullTo(getStyle("fontWeight"), "normal");
				//fontStyle.lineHeight = NullUtils.nanTo(getStyle("lineHeight"), 0.2);
				//				format.textAlign = NullUtils.nullTo(getStyle("textAlign"), TextAlign.LEFT);
				//				fontStyle.trackingLeft = NullUtils.nanTo(getStyle("trackingLeft"), 0.5);
				//				fontStyle.trackingRight = NullUtils.nanTo(getStyle("trackingRight"), 0.5);
				break;
		}
	}

	//==========================================================================================
	// Render
	//==========================================================================================
	protected function getLabelText():String {
		throw new Error("TextItemRenderer.getData() not implemented");
	}

	protected function renderContent(bound:Rectangle):void {
		label.text = getLabelText();
		label.createTextLines();

		switch (label.textAlign) {
			case TextAlign.RIGHT:
				label.x = bound.x + bound.width - label.width + _paddingRight;
				break;
			case TextAlign.CENTER:
				label.x = (bound.x + bound.width + label.width - _paddingLeft - _paddingRight) / 2;
				break;
			default :
				label.x = bound.x + _paddingLeft;
				break;
		}

		switch (_verticalAlign) {
			case VerticalAlign.BOTTOM:
				label.y = bound.y + bound.height - label.height + _paddingBottom;
				break;
			case VerticalAlign.MIDDLE:
				label.y = (bound.y + bound.height + label.height - _paddingTop - _paddingBottom) / 2;
				break;
			default:
				label.y = bound.y + _paddingTop;
				break;
		}

		//---------------------------------------------
		// test
		//---------------------------------------------
		const padding:int = 5;

		graphics.beginFill(0x000000, 0.1);
		graphics.drawRect(bound.x, bound.y, bound.width, bound.height);
		graphics.drawRect(bound.x + padding, bound.y + padding, bound.width - (padding * 2), bound.height - (padding * 2));
		graphics.endFill();
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
