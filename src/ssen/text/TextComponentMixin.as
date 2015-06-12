package ssen.text {
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.formats.ITextLayoutFormat;

public class TextComponentMixin extends TextLayoutFormatComponentMixin {
	private static var bound:Rectangle = new Rectangle;

	private var component:ITextComponent;
	public var container:Sprite;
	private var printed:PrintedTextLinesInfo;

	public var text:String;
	public var width:Number = NaN;
	public var height:Number = NaN;
	public var paddingLeft:int = 0;
	public var paddingRight:int = 0;
	public var paddingTop:int = 0;
	public var paddingBottom:int = 0;
	public var useMinimizeScaling:Boolean;
	public var useMaximizeScaling:Boolean;

	public function TextComponentMixin(component:ITextComponent, container:Sprite = null) {
		this.component = component;
		this.container = (container) ? container : component as Sprite;
	}

	public function clear():void {
		if (printed) {
			printed.disposer.dispose();
			printed = null;
		}
	}

	public function print(params:Object):PrintedTextLinesInfo {
		clear();

		bound.x = paddingLeft;
		bound.y = paddingTop;
		bound.width = width - paddingLeft - paddingRight;
		bound.height = height - paddingTop - paddingBottom;

		var format:ITextLayoutFormat = getFormat(params);
		var lines:Vector.<TextLine> = TextLineFactory.createTextLines(text, format, truncationOptions, EmbededFontUtils.getSwfContextWithContainer(container, format));

		printed = TextLinePrinter.printTextLinesWithSpace(
				lines,
				container,
				width,
				height,
				paddingLeft,
				paddingRight,
				paddingTop,
				paddingBottom,
				format.textAlign,
				format.verticalAlign,
				useMinimizeScaling,
				useMaximizeScaling
		);

		return printed;
	}
}
}
