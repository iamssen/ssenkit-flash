package ssen.text {

import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.compose.ISWFContext;
import flashx.textLayout.conversion.TextConverter;
import flashx.textLayout.elements.TextFlow;
import flashx.textLayout.factory.TextFlowTextLineFactory;
import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.formats.VerticalAlign;
import flashx.textLayout.tlf_internal;

import ssen.common.StringUtils;

use namespace tlf_internal;

public class TextLineFactory {

	public static function createTextLine(text:String, format:ITextLayoutFormat, swfContext:ISWFContext = null):TextLine {
		_format.copy(format);
		_format.textAlign = TextAlign.LEFT;
		_format.verticalAlign = VerticalAlign.TOP;

		var textLine:TextLine = null;
		var factory:TextFlowTextLineFactory = getTextLineFactory();
		if (swfContext) factory.swfContext = swfContext;

		var textFlow:TextFlow = getTextFlow(text);
		textFlow.hostFormat = _format;

		factory.createTextLines(function (line:TextLine):void {
			if (textLine) {
				throw new Error("내려쓰기가 나올 수 없음");
			}

			textLine = line;
		}, textFlow);

		return textLine;
	}

	public static function createTextLines(text:String, format:ITextLayoutFormat, truncationOptions:TruncationOptions = null, swfContext:ISWFContext = null):Vector.<TextLine> {
		_format.copy(format);
		_format.textAlign = TextAlign.LEFT;
		_format.verticalAlign = VerticalAlign.TOP;

		var textLines:Vector.<TextLine> = new Vector.<TextLine>;
		var factory:TextFlowTextLineFactory = getTextLineFactory();
		if (truncationOptions) factory.truncationOptions = truncationOptions;
		if (swfContext) factory.swfContext = swfContext;

		var textFlow:TextFlow = getTextFlow(text);
		textFlow.hostFormat = _format;

		factory.createTextLines(function (line:TextLine):void {
			textLines.push(line);
		}, textFlow);

		return textLines;
	}

	public static function getTextFlow(text:String):TextFlow {
		var format:String = (StringUtils.isRichText(text)) ? TextConverter.TEXT_FIELD_HTML_FORMAT : TextConverter.PLAIN_TEXT_FORMAT;
		return TextConverter.importToFlow(text, format);
	}

	//==========================================================================================
	// utils
	//==========================================================================================
	//---------------------------------------------
	// reuseble text line factory
	//---------------------------------------------
	private static var _textLineFactory:TextFlowTextLineFactory;

	private static function getTextLineFactory():TextFlowTextLineFactory {
		if (!_textLineFactory) {
			_textLineFactory = new TextFlowTextLineFactory;
			_textLineFactory.compositionBounds = new Rectangle(0, 0, 1000, 100);
		}

		return _textLineFactory;
	}

	private static var _format:TextLayoutFormat = new TextLayoutFormat;
}
}