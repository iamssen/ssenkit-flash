package ssen.text {
import flash.events.EventDispatcher;

import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;

public class ObjectTextComponent extends EventDispatcher implements ITextComponent {
	private var mixin:Mixin;

	public function ObjectTextComponent() {
		mixin = new Mixin(this);
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

	protected function renderText():void {
		if (linesChanged) linesChanged = false;
	}
}
}

import ssen.text.ITextComponent;
import ssen.text.TextLayoutFormatComponentMixin;

class Mixin extends TextLayoutFormatComponentMixin {
	private var component:ITextComponent;

	public var text:String;
	public var width:Number = NaN;
	public var height:Number = NaN;
	public var paddingLeft:int = 0;
	public var paddingRight:int = 0;
	public var paddingTop:int = 0;
	public var paddingBottom:int = 0;
	public var useMinimizeScaling:Boolean;
	public var useMaximizeScaling:Boolean;

	public function Mixin(component:ITextComponent) {
		this.component = component;
	}

	public function clear():void {

	}
}