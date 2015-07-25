package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.filters.BitmapFilter;

import mx.filters.IBitmapFilter;

public class FilterUtils {
	public static function convertFlexFiltersToFlashBitmapFilters(flexFilters:Array):Array {
		if (!flexFilters || flexFilters.length === 0) {
			return [];
		}

		var bitmapFilters:Array = [];
		var filter:Object;

		var f:int = -1;
		var fmax:int = flexFilters.length;

		while (++f < fmax) {
			filter = flexFilters[f];

			if (filter is BitmapFilter) {
				bitmapFilters.push(filter);
			} else if (filter is IBitmapFilter) {
				bitmapFilters.push(IBitmapFilter(flexFilters[f]).clone());
			}
		}

		return bitmapFilters;
	}
}
}
