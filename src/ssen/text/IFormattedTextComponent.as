package ssen.text {
import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;

[Deprecated(message="change text engine")]

public interface IFormattedTextComponent {
	//---------------------------------------------
	// textAlign
	//---------------------------------------------
	/** textAlign */
	function get textAlign() : String;
	[Inspectable(type="Array", enumeration="center,left,right", defaultValue="left")]
	function set textAlign(value : String):void;

	//---------------------------------------------
	// fontLookup
	//---------------------------------------------
	/** fontLookup */
	function get fontLookup() : String;
	[Inspectable(type="Array", enumeration="auto,device,embeddedCFF", defaultValue="device")]
	function set fontLookup(value : String):void;

	//---------------------------------------------
	// color
	//---------------------------------------------
	/** color */
	function get color() : uint;
	function set color(value : uint):void;

	//---------------------------------------------
	// fontSize
	//---------------------------------------------
	/** fontSize */
	function get fontSize() : uint;
	function set fontSize(value : uint):void;

	//---------------------------------------------
	// fontFamily
	//---------------------------------------------
	/** fontFamily */
	function get fontFamily() : String;
	function set fontFamily(value : String):void;

	//---------------------------------------------
	// fontWeight
	//---------------------------------------------
	/** fontWeight */
	function get fontWeight() : String;
	[Inspectable(type="Array", enumeration="normal,bold", defaultValue="normal")]
	function set fontWeight(value : String):void;

	//---------------------------------------------
	// lineHeight
	//---------------------------------------------
	/** lineHeight */
	function get lineHeight() : Object;
	function set lineHeight(value : Object):void;

	//---------------------------------------------
	// trackingLeft
	//---------------------------------------------
	/** trackingLeft */
	function get trackingLeft() : Object;
	function set trackingLeft(value : Object):void;

	//---------------------------------------------
	// trackingRight
	//---------------------------------------------
	/** trackingRight */
	function get trackingRight() : Object;
	function set trackingRight(value : Object):void;

	//---------------------------------------------
	// truncationOptions
	//---------------------------------------------
	/** truncationOptions */
	function get truncationOptions() : TruncationOptions;
	function set truncationOptions(value : TruncationOptions):void;

	//---------------------------------------------
	// textFormatFunction
	//---------------------------------------------
	/** textFormatFunction = `(format:TextLayoutFormat, ...params:Array) => void` */
	function get textFormatFunction() : Function;
	function set textFormatFunction(value : Function):void;

	function getFormat():ITextLayoutFormat;
	function setFormat(newFormat:ITextLayoutFormat):void;
}
}
