package ssen.text {

import flash.filters.BitmapFilter;
import flash.text.engine.TextLine;

import flashx.textLayout.compose.TextLineRecycler;

import mx.collections.IList;
import mx.filters.BaseFilter;

public class TextLineCache {
	private var textLines:Vector.<TextLine> = new Vector.<TextLine>;
	private var filters:Array;

	public function add(textLineOrTextLines:*):void {
		var textLine:TextLine;
		var f:int;

		if (textLineOrTextLines is TextLine) {
			textLine = textLineOrTextLines as TextLine;
			textLines.push(textLine);
			if (filters) {
				textLine.filters = filters;
			}
		} else if (textLineOrTextLines is Vector.<TextLine>) {
			var vec:Vector.<TextLine> = textLineOrTextLines;
			f = vec.length;
			while (--f >= 0) {
				textLine = vec[f];
				textLines.push(textLine);
				if (filters) {
					textLine.filters = filters;
				}
			}
		} else if (textLineOrTextLines is Array) {
			var arr:Array = textLineOrTextLines;
			f = arr.length;
			while (--f >= 0) {
				textLine = arr[f];
				textLines.push(textLine);
				if (filters) {
					textLine.filters = filters;
				}
			}
		} else if (textLineOrTextLines is IList) {
			var list:IList = textLineOrTextLines;
			f = list.length;
			while (--f >= 0) {
				textLine = list.getItemAt(f) as TextLine;
				textLines.push(textLine);
				if (filters) {
					textLine.filters = filters;
				}
			}
		}
	}

	public function setFilters(filters:Array):void {
		this.filters = convertAnyFiltersToFlashBitmapFilters(filters);

		var f:int = -1;
		var fmax:int = textLines.length;

		while (++f < fmax) {
			textLines[f].filters = filters;
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

	//==========================================================================================
	// utils
	//==========================================================================================
	private static function convertAnyFiltersToFlashBitmapFilters(filters:Array):Array {
		var flashBitmapFilters:Array = [];

		var f:int = filters.length;
		var filter:Object;

		while (--f >= 0) {
			filter = filters[f];

			// if flex filter
			if (filter is BaseFilter && filter.hasOwnProperty("clone")) {
				filter = filter.clone();
			}

			// if flash filter
			if (filter is BitmapFilter) {
				flashBitmapFilters.push(filter);
			}
		}

		return flashBitmapFilters;
	}
}
}
