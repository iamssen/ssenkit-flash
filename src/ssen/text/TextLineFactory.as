package ssen.text {

import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.compose.ISWFContext;
import flashx.textLayout.conversion.TextConverter;
import flashx.textLayout.elements.TextFlow;
import flashx.textLayout.factory.TextFlowTextLineFactory;
import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;

import ssen.common.StringUtils;

public class TextLineFactory {

	public static function createTextLine(str:String, format:ITextLayoutFormat, swfContext:ISWFContext = null):TextLine {
		var textLine:TextLine = null;
		var factory:TextFlowTextLineFactory = getTextLineFactory();
		if (swfContext) factory.swfContext = swfContext;

		var textFlow:TextFlow = getTextFlow(str);
		textFlow.hostFormat = format;

		factory.createTextLines(function (line:TextLine):void {
			if (textLine) {
				throw new Error("내려쓰기가 나올 수 없음");
			}

			textLine = line;
		}, textFlow);

		return textLine;
	}

	public static function createTextLines(str:String, format:ITextLayoutFormat, truncationOptions:TruncationOptions = null, swfContext:ISWFContext = null):Vector.<TextLine> {
		var textLines:Vector.<TextLine> = new Vector.<TextLine>;
		var factory:TextFlowTextLineFactory = getTextLineFactory();
		if (truncationOptions) factory.truncationOptions = truncationOptions;
		if (swfContext) factory.swfContext = swfContext;

		var textFlow:TextFlow = getTextFlow(str);
		textFlow.hostFormat = format;

		factory.createTextLines(function (line:TextLine):void {
			textLines.push(line);
		}, textFlow);

		return textLines;
	}

	public static function getTextFlow(str:String):TextFlow {
		var format:String = (StringUtils.isRichText(str)) ? TextConverter.TEXT_FIELD_HTML_FORMAT : TextConverter.PLAIN_TEXT_FORMAT;
		return TextConverter.importToFlow(str, format);
	}

	//==========================================================================================
	// utils
	//==========================================================================================
	//----------------------------------------------------------------
	// reuseble text line factory
	//----------------------------------------------------------------
	private static var _textLineFactory:TextFlowTextLineFactory;

	private static function getTextLineFactory():TextFlowTextLineFactory {
		if (!_textLineFactory) {
			_textLineFactory = new TextFlowTextLineFactory;
			_textLineFactory.compositionBounds = new Rectangle(0, 0, 1000, 100);
		}

		return _textLineFactory;
	}
}
}
