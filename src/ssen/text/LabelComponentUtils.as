package ssen.text {
import flashx.textLayout.formats.ITextLayoutFormat;
import flashx.textLayout.formats.TextLayoutFormat;

import mx.formatters.IFormatter;

[Deprecated(message="change text engine")]

public class LabelComponentUtils {
	public static function getTextLayoutFormat(component:IFormattedTextComponent, ...args:Array):ITextLayoutFormat {
		if (component.textFormatFunction !== null) {
			var newFormat:TextLayoutFormat = new TextLayoutFormat(component.getFormat());
			component.textFormatFunction.apply(null, [newFormat].concat(args));
			return newFormat;
		}

		return component.getFormat();
	}

	public static function getLabel(data:Object, dataField:String, formatter:IFormatter = null, labelFunction:Function = null, ...args:Array):String {
		if (labelFunction !== null) {
			return labelFunction.apply(null, [data, dataField].concat(args));
		} else if (formatter) {
			return formatter.format(data[dataField]);
		}
		var value:Object = data[dataField];
		return (value) ? value.toString() : "-";
	}
}
}
