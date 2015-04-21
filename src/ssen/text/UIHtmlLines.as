package ssen.text {
import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;

import mx.core.UIComponent;

public class UIHtmlLines extends UIComponent implements IHtmlLines {
	private var mixin:HtmlLinesMixin;

	public function get text():String {
		return mixin.text;
	}

	public function set text(value:String):void {
		mixin.text = value;
	}

	public function get format():ITextLayoutFormat {
		return mixin.format;
	}

	public function set format(value:ITextLayoutFormat):void {
		mixin.format = value;
	}

	public function get truncationOptions():TruncationOptions {
		return mixin.truncationOptions;
	}

	public function set truncationOptions(value:TruncationOptions):void {
		mixin.truncationOptions = value;
	}

	public function get textAlign():String {
		return mixin.textAlign;
	}

	public function set textAlign(value:String):void {
		mixin.textAlign = value;
	}

	public function createTextLines():void {
		mixin.createTextLines();
	}

	override public function get width():Number {
		return mixin.width;
	}

	override public function set width(value:Number):void {
	}

	override public function get height():Number {
		return mixin.height;
	}

	override public function set height(value:Number):void {
	}

	public function UIHtmlLines() {
		mixin = new HtmlLinesMixin(this);
	}
}
}
