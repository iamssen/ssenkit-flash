package ssen.text {
import spark.components.RichText;

import ssen.text.TextLineFactory;

public class HtmlRichText extends RichText {
	//---------------------------------------------
	// text
	//---------------------------------------------
	private var _text:String;

	/** text */
	override public function get text():String {
		return _text;
	}

	override public function set text(value:String):void {
		_text = value;
		textFlow = TextLineFactory.getTextFlow(value);
	}
}
}
