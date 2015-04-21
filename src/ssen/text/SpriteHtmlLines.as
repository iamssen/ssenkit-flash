package ssen.text {

import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;

import spark.core.SpriteVisualElement;

/**
 * Invalidation에 상관없이 Width와 Height를 바로 알 수 있는 Text가 필요할 때 사용.
 *
 * <p>MXML에 사용하기엔 좀 애매함...</p>
 */
public class SpriteHtmlLines extends SpriteVisualElement implements IHtmlLines {

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

	public function SpriteHtmlLines() {
		mixin = new HtmlLinesMixin(this);
	}
}
}
