package ssen.text {
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.text.engine.FontLookup;
import flash.text.engine.TextLine;

import flashx.textLayout.compose.ISWFContext;
import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;

import mx.core.FlexGlobals;
import mx.core.UIComponent;

import ssen.common.StringUtils;
import ssen.ssen_internal;

use namespace ssen_internal;

[Deprecated(message="change text engine")]

public class HtmlLinesMixin {
	private var container:Sprite;

	//==========================================================================================
	// properties
	//==========================================================================================
	ssen_internal static var defaultFormat:ITextLayoutFormat;

	//----------------------------------------------------------------
	// text source properties
	//----------------------------------------------------------------
	//---------------------------------------------
	// text
	//---------------------------------------------
	private var _text:String;

	/** text */
	public function get text():String {
		return _text;
	}

	public function set text(value:String):void {
		_text = value;
		invalidate_text();
	}

	//---------------------------------------------
	// format
	//---------------------------------------------
	private var _format:ITextLayoutFormat;

	/** format */
	public function get format():ITextLayoutFormat {
		return _format;
	}

	public function set format(value:ITextLayoutFormat):void {
		_format = value;
		invalidate_text();
	}

	//---------------------------------------------
	// truncationOptions
	//---------------------------------------------
	private var _truncationOptions:TruncationOptions;

	/** truncationOptions */
	public function get truncationOptions():TruncationOptions {
		return _truncationOptions;
	}

	public function set truncationOptions(value:TruncationOptions):void {
		_truncationOptions = value;
		invalidate_text();
	}

	//----------------------------------------------------------------
	// text align properties
	//----------------------------------------------------------------
	//---------------------------------------------
	// textAlign
	//---------------------------------------------
	private var _textAlign:String = "left";

	/** textAlign */
	public function get textAlign():String {
		return _textAlign;
	}

	public function set textAlign(value:String):void {
		_textAlign = value;
		invalidate_position();
	}

	//---------------------------------------------
	// width
	//---------------------------------------------
	private var _width:Number;

	/** width */
	public function get width():Number {
		return _width;
	}

	//---------------------------------------------
	// height
	//---------------------------------------------
	private var _height:Number;

	/** height */
	public function get height():Number {
		return _height;
	}

	//==========================================================================================
	// constructor
	//==========================================================================================
	private var textLineCache:TextLineCache;

	/** @private */
	ssen_internal var textLines:Vector.<TextLine>;

	public function HtmlLinesMixin(container:Sprite) {
		this.container = container;

		textLineCache = new TextLineCache;

		if (!defaultFormat) {
			var format:TextLayoutFormat = new TextLayoutFormat;
			format.fontFamily = "_sans";
			format.fontSize = 12;
			defaultFormat = format;
		}

		_format = defaultFormat;
	}

	//==========================================================================================
	// validation
	//==========================================================================================
	//----------------------------------------------------------------
	// invalidation
	//----------------------------------------------------------------
	//---------------------------------------------
	// inavalidate text
	//---------------------------------------------
	private var textChanged:Boolean;

	final protected function invalidate_text():void {
		textChanged = true;
	}

	//---------------------------------------------
	// inavalidate position
	//---------------------------------------------
	private var positionChanged:Boolean;

	final protected function invalidate_position():void {
		positionChanged = true;
	}

	//---------------------------------------------
	// commit text
	//---------------------------------------------
	protected function commit_text():void {
		textLineCache.clear();
		textLines = null;

		if (!StringUtils.isBlank(_text)) {
			var swfContext:ISWFContext;

			if (_format && _format.fontLookup === FontLookup.EMBEDDED_CFF) {
				//---------------------------------------------
				// get ui component context
				//---------------------------------------------
				var component:UIComponent;

				if (container.parent) {
					var display:DisplayObjectContainer = container;

					while (display.parent) {
						if (display.parent is UIComponent) {
							component = display.parent as UIComponent;
							break;
						}
						display = display.parent;
					}
				}

				if (!component) {
					component = FlexGlobals.topLevelApplication as UIComponent;
				}

				//---------------------------------------------
				// get swf context
				//---------------------------------------------
				if (component) {
					swfContext = EmbededFontUtils.getSwfContext(component, _format.fontFamily);
				}
			}

			textLines = TextLineFactory.createTextLines(_text, _format, _truncationOptions, swfContext);
			textLineCache.add(textLines);

			var f:int = textLines.length;
			var textLine:TextLine;
			while (--f >= 0) {
				textLine = textLines[f];
				container.addChild(textLine);
			}
		}
	}

	//---------------------------------------------
	// commit position
	//---------------------------------------------
	protected function commit_position():void {
		if (!textLines || textLines.length === 0) {
			_width = 0;
			_height = 0;
			return;
		}

		var f:int;
		var fmax:int;
		var textLine:TextLine;

		var x:Number;
		var xmax:Number = Number.MIN_VALUE;
		var y:Number;
		var ymax:Number = Number.MIN_VALUE;

		f = -1;
		fmax = textLines.length;
		while (++f < fmax) {
			textLine = textLines[f];

			x = textLine.width;
			if (x > xmax) {
				xmax = x;
			}

			y = textLine.y + textLine.height - textLine.ascent;
			if (y > ymax) {
				ymax = y;
			}
		}

		_width = xmax;
		_height = ymax;

		//		graphics.clear();
		//		graphics.beginFill(0x000000, 0.3);

		f = -1;
		fmax = textLines.length;
		while (++f < fmax) {
			textLine = textLines[f];

			switch (_textAlign) {
				case TextAlign.RIGHT:
					textLine.x = xmax - textLine.width;
					break;
				case TextAlign.CENTER:
					textLine.x = (xmax - textLine.width) / 2;
					break;
				default:
					textLine.x = 0;
			}

			//			graphics.drawRect(textLine.x, textLine.y - textLine.ascent, textLine.width, textLine.height);
		}

		//		graphics.endFill();


	}

	//==========================================================================================
	// commit
	//==========================================================================================
	public function createTextLines():void {
		if (textChanged) {
			commit_text();
			textChanged = false;
			positionChanged = true;
		}

		if (positionChanged) {
			commit_position();
			positionChanged = false;
		}

		//		invalidateSize();

		var graphics:Graphics = container.graphics;

		graphics.clear();
		graphics.beginFill(0, 0);
		graphics.drawRect(0, 0, _width, _height);
		graphics.endFill();
	}
}
}
