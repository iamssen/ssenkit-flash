package ssen.text {
import flash.display.Graphics;

import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;

import mx.core.UIComponent;

public class UITextComponent extends UIComponent implements ITextComponent {
	private var mixin:TextComponentMixin;

	public function UITextComponent() {
		mixin = new TextComponentMixin(this, this);
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
		invalidateSize();
		invalidateDisplayList();
		invalidateParentSizeAndDisplayList();
	}

	protected function getParams():Object {
		return null;
	}

	override protected function measure():void {
		super.measure();

		if (!text) return;

		var explicitWidth:Number = this.explicitWidth;
		var explicitHeight:Number = this.explicitHeight;
		var hasExplicitWidth:Boolean = !isNaN(explicitWidth);
		var hasExplicitHeight:Boolean = !isNaN(explicitHeight);

		if (!hasExplicitWidth || !hasExplicitHeight) {
			if (linesChanged) {
				mixin.width = explicitWidth;
				mixin.height = explicitHeight;

				var printed:PrintedTextLinesInfo = mixin.print(getParams());

				measuredWidth = printed.width;
				measuredHeight = printed.height;

				linesChanged = false;
				//				renderInMeasure = true;
			}
		}
	}

	//	private var renderInMeasure:Boolean;
	//	private var lastWidth:Number;
	//	private var lastHeight:Number;

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (!unscaledWidth || !unscaledHeight) return;
		if (!text) return;

		//		if (!renderInMeasure) {
		//			if (lastWidth !== unscaledWidth || lastHeight !== unscaledHeight) {
		//				linesChanged = true;
		//			}
		//		}

		if (linesChanged) {
			//			trace("UITextComponent.updateDisplayList()", unscaledWidth, unscaledHeight);
			mixin.width = unscaledWidth;
			mixin.height = unscaledHeight;

			mixin.print(getParams());

			linesChanged = false;
		}
		//
		//		renderInMeasure = false;
		//		lastWidth = unscaledWidth;
		//		lastHeight = unscaledHeight;

		//		var g:Graphics = graphics;
		//		g.beginFill(0, 0.1);
		//		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		//		g.endFill();
	}
}
}
