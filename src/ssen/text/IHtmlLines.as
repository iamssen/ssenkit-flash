package ssen.text {
import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;

[Deprecated(message="change text engine")]

public interface IHtmlLines {
	//---------------------------------------------
	// text
	//---------------------------------------------
	/** text */
	function get text() : String;
	function set text(value : String):void;

	//---------------------------------------------
	// format
	//---------------------------------------------
	/** format */
	function get format() : ITextLayoutFormat;
	function set format(value : ITextLayoutFormat):void;

	//---------------------------------------------
	// truncationOptions
	//---------------------------------------------
	/** truncationOptions */
	function get truncationOptions() : TruncationOptions;
	function set truncationOptions(value : TruncationOptions):void;

	//---------------------------------------------
	// textAlign
	//---------------------------------------------
	/** textAlign */
	function get textAlign() : String;
	function set textAlign(value : String):void;

	function createTextLines():void;
}
}
