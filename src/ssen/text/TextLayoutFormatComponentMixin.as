package ssen.text {
import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;

public class TextLayoutFormatComponentMixin {
	public var textAlign:String = "left";
	public var truncationOptions:TruncationOptions;
	public var format:ITextLayoutFormat;
	public var formatFunction:Function;

	public function getFormat(params:Object):ITextLayoutFormat {
		if (formatFunction !== null) return formatFunction(format, params);
		return format;
	}
}
}
