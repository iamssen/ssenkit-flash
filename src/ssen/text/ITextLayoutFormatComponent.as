package ssen.text {
import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;

public interface ITextLayoutFormatComponent {
	//---------------------------------------------
	// textAlign
	//---------------------------------------------
	/** textAlign */
	function get textAlign() : String;
	[Inspectable(type="Array", enumeration="center,left,right", defaultValue="left")]
	function set textAlign(value : String):void;

	//---------------------------------------------
	// truncationOptions
	//---------------------------------------------
	/** truncationOptions */
	function get truncationOptions() : TruncationOptions;
	function set truncationOptions(value : TruncationOptions):void;

	//---------------------------------------------
	// format
	//---------------------------------------------
	/** format */
	function get format() : ITextLayoutFormat;
	function set format(value : ITextLayoutFormat):void;

	//---------------------------------------------
	// formatFunction
	//---------------------------------------------
	/** formatFunction = `(defaultFormat:ITextLayoutFormat, params:Dictionary) => ITextLayoutFormat` */
	function get formatFunction() : Function;
	function set formatFunction(value : Function):void;
}
}
