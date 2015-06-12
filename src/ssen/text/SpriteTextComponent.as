package ssen.text {
import flash.display.Sprite;

import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;

public class SpriteTextComponent extends Sprite implements ITextComponent {
	private var mixin:TextComponentMixin;

	public function SpriteTextComponent() {
		mixin = new TextComponentMixin(this, this);
	}

	private var _width:Number;
	private var _height:Number;

	override public function get width():Number {
		return _width;
	}

	override public function set width(value:Number):void {
	}

	override public function get height():Number {
		return _height;
	}

	override public function set height(value:Number):void {
	}

	//---------------------------------------------
	// textAlign
	//---------------------------------------------
	/** textAlign */
	public function get textAlign():String {
		return mixin.textAlign;
	}

	[Inspectable(type="Array", enumeration="center,left,right", defaultValue="left")]
	public function set textAlign(value:String):void {
		mixin.textAlign = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// truncationOptions
	//---------------------------------------------
	/** truncationOptions */
	public function get truncationOptions():TruncationOptions {
		return mixin.truncationOptions;
	}

	public function set truncationOptions(value:TruncationOptions):void {
		mixin.truncationOptions = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// format
	//---------------------------------------------
	/** format */
	public function get format():ITextLayoutFormat {
		return mixin.format;
	}

	public function set format(value:ITextLayoutFormat):void {
		mixin.format = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// formatFunction
	//---------------------------------------------
	/** formatFunction */
	public function get formatFunction():Function {
		return mixin.formatFunction;
	}

	public function set formatFunction(value:Function):void {
		mixin.formatFunction = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// text
	//---------------------------------------------
	/** text */
	public function get text():String {
		return mixin.text;
	}

	public function set text(value:String):void {
		mixin.text = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// paddingLeft
	//---------------------------------------------
	/** paddingLeft */
	public function get paddingLeft():int {
		return mixin.paddingLeft;
	}

	public function set paddingLeft(value:int):void {
		mixin.paddingLeft = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// paddingRight
	//---------------------------------------------
	/** paddingRight */
	public function get paddingRight():int {
		return mixin.paddingRight;
	}

	public function set paddingRight(value:int):void {
		mixin.paddingRight = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// paddingTop
	//---------------------------------------------
	/** paddingTop */
	public function get paddingTop():int {
		return mixin.paddingTop;
	}

	public function set paddingTop(value:int):void {
		mixin.paddingTop = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// paddingBottom
	//---------------------------------------------
	/** paddingBottom */
	public function get paddingBottom():int {
		return mixin.paddingBottom;
	}

	public function set paddingBottom(value:int):void {
		mixin.paddingBottom = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// useMinimizeScaling
	//---------------------------------------------
	/** useMinimizeScaling */
	public function get useMinimizeScaling():Boolean {
		return mixin.useMinimizeScaling;
	}

	public function set useMinimizeScaling(value:Boolean):void {
		mixin.useMinimizeScaling = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// useMaximizeScaling
	//---------------------------------------------
	/** useMaximizeScaling */
	public function get useMaximizeScaling():Boolean {
		return mixin.useMaximizeScaling;
	}

	public function set useMaximizeScaling(value:Boolean):void {
		mixin.useMaximizeScaling = value;
		invalidate_lines();
	}

	//==========================================================================================
	// process
	//==========================================================================================
	private var linesChanged:Boolean;

	final protected function invalidate_lines():void {
		linesChanged = true;
	}

	protected function getParams():Object {
		return null;
	}

	public function renderText():void {
		if (linesChanged) {
			mixin.width = NaN;
			mixin.height = NaN;

			var printed:PrintedTextLinesInfo = mixin.print(getParams());
			_width = printed.width;
			_height = printed.height;

			linesChanged = false;
		}
	}
}
}
