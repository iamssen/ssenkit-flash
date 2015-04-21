package ssen.text {
import flash.display.Graphics;

import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.VerticalAlign;

import mx.core.UIComponent;

public class HtmlLabel extends UIComponent {
	private var lines:SpriteHtmlLines;

	//---------------------------------------------
	// text
	//---------------------------------------------
	/** text */
	public function get text():String {
		return lines.text;
	}

	public function set text(value:String):void {
		lines.text = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// format
	//---------------------------------------------
	/** format */
	public function get format():ITextLayoutFormat {
		return lines.format;
	}

	public function set format(value:ITextLayoutFormat):void {
		lines.format = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// truncationOptions
	//---------------------------------------------
	/** truncationOptions */
	public function get truncationOptions():TruncationOptions {
		return lines.truncationOptions;
	}

	public function set truncationOptions(value:TruncationOptions):void {
		lines.truncationOptions = value;
		invalidate_lines();
	}

	//---------------------------------------------
	// textAlign
	//---------------------------------------------
	/** textAlign */
	public function get textAlign():String {
		return lines.textAlign;
	}

	[Inspectable(type="Array", enumeration="center,left,right", defaultValue="left")]
	public function set textAlign(value:String):void {
		lines.textAlign = value;
		invalidate_lines();
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
		invalidate_lines();
	}

	//---------------------------------------------
	// canZoomingOverActualSize
	//---------------------------------------------
	private var _canZoomingOverActualSize:Boolean = false;

	/** canZoomingOverActualSize */
	public function get canZoomingOverActualSize():Boolean {
		return _canZoomingOverActualSize;
	}

	public function set canZoomingOverActualSize(value:Boolean):void {
		_canZoomingOverActualSize = value;
		invalidate_lines();
	}

	//==========================================================================================
	// life cycle
	//==========================================================================================
	public function HtmlLabel() {
		lines = new SpriteHtmlLines;
		addChild(lines);
	}

	//---------------------------------------------
	// inavalidate lines
	//---------------------------------------------
	private var linesChanged:Boolean;

	final protected function invalidate_lines():void {
		linesChanged = true;
		invalidateProperties();
	}

	//---------------------------------------------
	// commit lines
	//---------------------------------------------
	protected function commit_lines():void {
		lines.createTextLines();
	}

	override protected function commitProperties():void {
		super.commitProperties();

		if (linesChanged) {
			trace("HtmlLabel.commitProperties()");
			commit_lines();
			linesChanged = false;
			invalidateSize();
			invalidateDisplayList();
		}
	}

	override protected function measure():void {
		super.measure();
		trace("HtmlLabel.measure()");

		var explicitWidth:Number = this.explicitWidth;
		var explicitHeight:Number = this.explicitHeight;
		var linesWidth:Number;
		var linesHeight:Number;

		if (!isNaN(explicitWidth) || !isNaN(explicitHeight)) {
			linesWidth = lines.width;
			linesHeight = lines.height;

			var scale:Number;

			if (!isNaN(explicitWidth)) {
				scale = fixActualScale(explicitWidth / linesWidth);
				measuredWidth = linesWidth;
				measuredHeight = linesHeight * scale;
			} else {
				scale = fixActualScale(explicitHeight / linesHeight);
				measuredWidth = linesWidth * scale;
				measuredHeight = linesHeight;
			}

			lines.scaleX = scale;
			lines.scaleY = scale;

			linesWidth = linesWidth * scale;
			linesHeight = linesHeight * scale;
		} else {
			measuredWidth = lines.width;
			measuredHeight = lines.height;

			linesWidth = lines.width;
			linesHeight = lines.height;
		}

		if (measuredWidth !== linesWidth) {
			switch (textAlign) {
				case TextAlign.RIGHT:
					lines.x = measuredWidth - linesWidth;
					break;
				case TextAlign.CENTER:
					lines.x = (measuredWidth + linesWidth) / 2;
					break;
				default:
					lines.x = 0;
					break;
			}
		} else {
			lines.x = 0;
		}

		if (measuredHeight !== linesHeight) {
			switch (verticalAlign) {
				case VerticalAlign.BOTTOM:
					lines.y = measuredHeight - linesHeight;
					break;
				case VerticalAlign.MIDDLE:
					lines.y = (measuredHeight + lines.height) / 2;
					break;
				default:
					lines.y = 0;
					break;
			}
		} else {
			lines.y = 0;
		}
	}

	private function fixActualScale(scale:Number):Number {
		return (scale > 1 && !_canZoomingOverActualSize) ? 1 : scale;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		trace("HtmlLabel.updateDisplayList()");
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var g:Graphics = graphics;

		g.clear();
		g.beginFill(0, 0);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();
	}
}
}
