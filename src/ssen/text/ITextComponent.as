package ssen.text {
public interface ITextComponent extends ITextLayoutFormatComponent {
	//---------------------------------------------
	// text
	//---------------------------------------------
	/** text */
	function get text() : String;
	function set text(value : String):void;

	//---------------------------------------------
	// paddingLeft
	//---------------------------------------------
	/** paddingLeft */
	function get paddingLeft() : int;
	function set paddingLeft(value : int):void;

	//---------------------------------------------
	// paddingRight
	//---------------------------------------------
	/** paddingRight */
	function get paddingRight() : int;
	function set paddingRight(value : int):void;

	//---------------------------------------------
	// paddingTop
	//---------------------------------------------
	/** paddingTop */
	function get paddingTop() : int;
	function set paddingTop(value : int):void;

	//---------------------------------------------
	// paddingBottom
	//---------------------------------------------
	/** paddingBottom */
	function get paddingBottom() : int;
	function set paddingBottom(value : int):void;

	//---------------------------------------------
	// useMinimizeScaling
	//---------------------------------------------
	/** useMinimizeScaling */
	function get useMinimizeScaling() : Boolean;
	function set useMinimizeScaling(value : Boolean):void;

	//---------------------------------------------
	// useMaximizeScaling
	//---------------------------------------------
	/** useMaximizeScaling */
	function get useMaximizeScaling() : Boolean;
	function set useMaximizeScaling(value : Boolean):void;
}
}
