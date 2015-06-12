package ssen.text {
import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;

public class TextLayoutFormatComponent implements ITextLayoutFormatComponent {
	private var mixin:TextLayoutFormatComponentMixin;

	public function TextLayoutFormatComponent() {
		mixin = new TextLayoutFormatComponentMixin;
	}

	//---------------------------------------------
	// textAlign
	//---------------------------------------------
	/** textAlign */
	public function get textAlign():String {
		return mixin.textAlign;
	}

	[Inspectable(type="Array", enumeration="center,left,right", defaultValue="left")]
	public function set textAlign(value:String):void {
		mixin.textAlign = value;
	}

	//---------------------------------------------
	// truncationOptions
	//---------------------------------------------
	/** truncationOptions */
	public function get truncationOptions():TruncationOptions {
		return mixin.truncationOptions;
	}

	public function set truncationOptions(value:TruncationOptions):void {
		mixin.truncationOptions = value;
	}

	//---------------------------------------------
	// format
	//---------------------------------------------
	/** format */
	public function get format():ITextLayoutFormat {
		return mixin.format;
	}

	public function set format(value:ITextLayoutFormat):void {
		mixin.format = value;
	}

	//---------------------------------------------
	// formatFunction
	//---------------------------------------------
	/** formatFunction */
	public function get formatFunction():Function {
		return mixin.formatFunction;
	}

	public function set formatFunction(value:Function):void {
		mixin.formatFunction = value;
	}

	protected function getFormat(params:Object = null):ITextLayoutFormat {
		return mixin.getFormat(params);
	}
}
}
