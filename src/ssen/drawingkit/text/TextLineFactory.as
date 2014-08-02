package ssen.drawingkit.text {
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.conversion.TextConverter;
import flashx.textLayout.elements.TextFlow;
import flashx.textLayout.factory.TextFlowTextLineFactory;
import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.TextLayoutFormat;

public class TextLineFactory {
	private static var _textLineFactory:TextFlowTextLineFactory;

	private static function getTextLineFactory():TextFlowTextLineFactory {
		if (!_textLineFactory) {
			_textLineFactory=new TextFlowTextLineFactory;
			_textLineFactory.compositionBounds=new Rectangle(0, 0, 1000, 100);
		}

		return _textLineFactory;
	}

	public static function createTextLine(str:String, format:TextLayoutFormat, truncationOptions:TruncationOptions=null):TextLine {
		var textLine:TextLine;
		var factory:TextFlowTextLineFactory=getTextLineFactory();
		var textFlow:TextFlow=getTextFlow(str);
		textFlow.hostFormat=format;

		factory.createTextLines(function(line:TextLine):void {
			if (textLine) {
				throw new Error("내려쓰기가 나올 수 없음");
			}

			textLine=line;
		}, textFlow);

		return textLine;
	}

	public static function createTextLines(str:String, format:TextLayoutFormat, truncationOptions:TruncationOptions=null):Vector.<TextLine> {
		var textLines:Vector.<TextLine>=new Vector.<TextLine>;
		var factory:TextFlowTextLineFactory=getTextLineFactory();
		var textFlow:TextFlow=getTextFlow(str);
		textFlow.hostFormat=format;

		factory.createTextLines(function(line:TextLine):void {
			textLines.push(line);
		}, textFlow);

		return textLines;
	}

	public static function getTextFlow(str:String):TextFlow {
		if (str.indexOf("<") > -1) {
			return TextConverter.importToFlow(str, TextConverter.TEXT_FIELD_HTML_FORMAT);
		}

		return TextConverter.importToFlow(str, TextConverter.PLAIN_TEXT_FORMAT);
	}
}
}
