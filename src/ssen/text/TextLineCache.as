package ssen.text {

import flash.text.engine.TextLine;

import flashx.textLayout.compose.TextLineRecycler;

import mx.collections.IList;

[Deprecated(message="change text engine")]

public class TextLineCache {

	private var textLines:Vector.<TextLine> = new Vector.<TextLine>;

	public function add(textLineOrTextLines:*):void {
		var textLine:TextLine;
		var f:int;

		if (textLineOrTextLines is TextLine) {
			textLine = textLineOrTextLines as TextLine;
			textLines.push(textLine);
		} else if (textLineOrTextLines is Vector.<TextLine>) {
			var vec:Vector.<TextLine> = textLineOrTextLines;
			f = vec.length;
			while (--f >= 0) {
				textLine = vec[f];
				textLines.push(textLine);
			}
		} else if (textLineOrTextLines is Array) {
			var arr:Array = textLineOrTextLines;
			f = arr.length;
			while (--f >= 0) {
				textLine = arr[f];
				textLines.push(textLine);
			}
		} else if (textLineOrTextLines is IList) {
			var list:IList = textLineOrTextLines;
			f = list.length;
			while (--f >= 0) {
				textLine = list.getItemAt(f) as TextLine;
				textLines.push(textLine);
			}
		}
	}

	public function clear():void {
		var f:int;
		var fmax:int;

		var textLine:TextLine;

		if (textLines && textLines.length > 0) {
			f = -1;
			fmax = textLines.length;

			while (++f < fmax) {
				textLine = textLines[f];
				textLine.filters = null;

				if (textLine.parent) {
					textLine.parent.removeChild(textLine);
				}

				TextLineRecycler.addLineForReuse(textLine);
			}

			textLines.length = 0;
		}
	}
}
}
