package ssen.text {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.VerticalAlign;

import ssen.drawing.DrawingUtils;

public class TextLinePrinter {
	/*
	TODO print text를 여러 방식으로 구현하자
	 - 공간지정 --> x, y, width=NaN, height=NaN, padding
	 - 정렬 --> horizontal, vertical align
	 - 비율 별 리사이즈 --> minimize, maximize
	*/

	public static function printTextLineWithSpace(line:TextLine,
												  container:DisplayObjectContainer,
												  width:Number,
												  height:Number,
												  paddingLeft:int,
												  paddingRight:int,
												  paddingTop:int,
												  paddingBottom:int,
												  horizontalAlign:String,
												  verticalAlign:String,
												  minimize:Boolean,
												  maximize:Boolean):PrintedTextLinesInfo {
		var printed:PrintedTextLinesInfo = new PrintedTextLinesInfo;

		const explicitWidth:Boolean = !isNaN(width);
		const explicitHeight:Boolean = !isNaN(height);

		var spaceWidth:Number;
		var spaceHeight:Number;

		var lineWidth:Number;
		var lineHeight:Number;

		var scale:Number;

		//---------------------------------------------
		// calculate size if has explicit width or height
		//---------------------------------------------
		if (explicitWidth || explicitHeight) {
			if (explicitWidth && explicitHeight) {
				spaceWidth = width - paddingLeft - paddingRight;
				spaceHeight = height - paddingTop - paddingBottom;

				scale = Math.min(spaceWidth / line.width, spaceHeight / line.height);
			} else if (explicitWidth) {
				spaceWidth = width - paddingLeft - paddingRight;
				spaceHeight = paddingTop + line.height + paddingBottom;

				scale = spaceWidth / line.width;
			} else {
				spaceWidth = paddingLeft + line.width + paddingRight;
				spaceHeight = height - paddingTop - paddingBottom;

				scale = spaceHeight / line.height;
			}

			if (scale > 1) {
				scale = maximize ? scale : 1;
			} else if (scale < 1) {
				scale = minimize ? scale : 1;
			}

			lineWidth = line.width * scale;
			lineHeight = line.height * scale;

			line.scaleX = scale;
			line.scaleY = scale;
		} else {
			scale = 1;

			lineWidth = line.width;
			lineHeight = line.height;
		}

		//---------------------------------------------
		// x
		//---------------------------------------------
		if (explicitWidth) {
			switch (horizontalAlign) {
				case TextAlign.CENTER:
					line.x = paddingLeft + ((spaceWidth - lineWidth) / 2);
					break;
				case TextAlign.RIGHT:
					line.x = paddingLeft + spaceWidth - lineWidth;
					break;
				default:
					line.x = paddingLeft;
					break;
			}
		} else {
			line.x = paddingLeft;
		}

		printed.width = paddingLeft + lineWidth + paddingRight;

		//---------------------------------------------
		// y
		//---------------------------------------------
		if (explicitHeight) {
			switch (verticalAlign) {
				case VerticalAlign.MIDDLE:
					line.y = paddingTop + ((spaceHeight - lineHeight) / 2) + (line.y * scale);
					break;
				case VerticalAlign.BOTTOM:
					line.y = paddingTop + spaceHeight - lineHeight + (line.y * scale);
					break;
				default:
					line.y = paddingTop + (line.y * scale);
					break;
			}
		} else {
			line.y = paddingTop + line.y;
		}

		printed.height = paddingTop + lineHeight + paddingBottom;

		//---------------------------------------------
		// add
		//---------------------------------------------
		container.addChild(line);

		printed.disposer = new TextLineDisposer(line);

		return printed;
	}

	public static function printTextLinesWithSpace(lines:Vector.<TextLine>,
												   container:DisplayObjectContainer,
												   width:Number,
												   height:Number,
												   paddingLeft:int,
												   paddingRight:int,
												   paddingTop:int,
												   paddingBottom:int,
												   horizontalAlign:String,
												   verticalAlign:String,
												   minimize:Boolean,
												   maximize:Boolean):PrintedTextLinesInfo {
		var printed:PrintedTextLinesInfo = new PrintedTextLinesInfo;

		const explicitWidth:Boolean = !isNaN(width);
		const explicitHeight:Boolean = !isNaN(height);

		var spaceWidth:Number;
		var spaceHeight:Number;

		var lineWidth:Number;
		var lineHeight:Number;
		var scaledVerticalGap:Number;

		var line:TextLine;
		var f:int;
		var fmax:int;

		var bounds:Rectangle = DrawingUtils.unionDisplayObjectBounds(linesToDisplays(lines));
		var scale:Number;

		//----------------------------------------------------------------
		// bounds process
		//----------------------------------------------------------------
		//---------------------------------------------
		// calculate size if has explicit width or height
		//---------------------------------------------
		if (explicitWidth || explicitHeight) {
			if (explicitWidth && explicitHeight) {
				spaceWidth = width - paddingLeft - paddingRight;
				spaceHeight = height - paddingTop - paddingBottom;

				scale = Math.min(spaceWidth / bounds.width, spaceHeight / bounds.height);
			} else if (explicitWidth) {
				spaceWidth = width - paddingLeft - paddingRight;
				spaceHeight = paddingTop + bounds.height + paddingBottom;

				scale = spaceWidth / bounds.width;
			} else {
				spaceWidth = paddingLeft + bounds.width + paddingRight;
				spaceHeight = height - paddingTop - paddingBottom;

				scale = spaceHeight / bounds.height;
			}

			if (scale > 1) {
				scale = maximize ? scale : 1;
			} else if (scale < 1) {
				scale = minimize ? scale : 1;
			}

			if (explicitHeight) {
				switch (verticalAlign) {
					case VerticalAlign.MIDDLE:
						scaledVerticalGap = (spaceHeight - (bounds.height * scale)) / 2;
						break;
					case VerticalAlign.BOTTOM:
						scaledVerticalGap = spaceHeight - (bounds.height * scale);
						break;
					default:
						scaledVerticalGap = 0;
						break;
				}
			} else {
				scaledVerticalGap = 0;
			}
		} else {
			scale = 1;
			scaledVerticalGap = 0;
		}

		//----------------------------------------------------------------
		// line process
		//----------------------------------------------------------------
		f = -1;
		fmax = lines.length;
		while (++f < fmax) {
			line = lines[f];

			//---------------------------------------------
			// calculate size if has explicit width or height
			//---------------------------------------------
			if (explicitWidth || explicitHeight) {
				lineWidth = line.width * scale;
				lineHeight = line.height * scale;

				line.scaleX = scale;
				line.scaleY = scale;
			} else {
				lineWidth = line.width;
				lineHeight = line.height;
			}

			//---------------------------------------------
			// x
			//---------------------------------------------
			if (explicitWidth) {
				switch (horizontalAlign) {
					case TextAlign.CENTER:
						line.x = paddingLeft + ((spaceWidth - lineWidth) / 2);
						break;
					case TextAlign.RIGHT:
						line.x = paddingLeft + (spaceWidth - lineWidth);
						break;
					default:
						line.x = paddingLeft;
						break;
				}
			} else {
				line.x = paddingLeft;
			}

			//---------------------------------------------
			// y
			//---------------------------------------------
			line.y = paddingTop + scaledVerticalGap + (line.y * scale);

			//---------------------------------------------
			// add
			//---------------------------------------------
			container.addChild(line);
		}

		printed.disposer = new TextLinesDisposer(lines);

		if (explicitWidth) {
			printed.width = paddingLeft + (bounds.width * scale) + paddingRight;
		} else {
			printed.width = paddingLeft + bounds.width + paddingRight;
		}

		if (explicitHeight) {
			printed.height = paddingTop + (bounds.height * scale) + paddingBottom;
		} else {
			printed.height = paddingTop + bounds.height + paddingBottom;
		}

		return printed;
	}

	private static function linesToDisplays(lines:Vector.<TextLine>):Vector.<DisplayObject> {
		var displays:Vector.<DisplayObject> = new Vector.<DisplayObject>(lines.length, true);
		var f:int = -1;
		var fmax:int = lines.length;
		while (++f < fmax) {
			displays[f] = lines[f];
		}
		return displays;
	}
}
}

import flash.text.engine.TextLine;

import flashx.textLayout.compose.TextLineRecycler;

import ssen.common.IDisposable;

class TextLineDisposer implements IDisposable {
	private var line:TextLine;

	public function TextLineDisposer(line:TextLine) {
		this.line = line;
	}

	public function dispose():void {
		if (line.parent) line.parent.removeChild(line);
		TextLineRecycler.addLineForReuse(line);
	}
}

class TextLinesDisposer implements IDisposable {
	private var lines:Vector.<TextLine>;

	public function TextLinesDisposer(lines:Vector.<TextLine>) {
		this.lines = lines;
	}

	public function dispose():void {
		var f:int = lines.length;
		var line:TextLine;
		while (--f >= 0) {
			line = lines[f];
			if (line.parent) line.parent.removeChild(line);
			TextLineRecycler.addLineForReuse(line);
		}
	}
}

