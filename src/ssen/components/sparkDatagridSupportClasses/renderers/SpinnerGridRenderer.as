package ssen.components.sparkDatagridSupportClasses.renderers {

import ssen.theme.squared.assets.SpinnerDecrementGrayArrow;
import ssen.theme.squared.assets.SpinnerIncrementGrayArrow;

public class SpinnerGridRenderer extends GridRenderer {
	private var incrementArrow:SpinnerIncrementGrayArrow;
	private var decrementArrow:SpinnerDecrementGrayArrow;

	public function SpinnerGridRenderer() {
		setStyle("paddingRight", 20);
	}

	override protected function draw(hasBeenRecycled:Boolean, dataChanged:Boolean, columnChanged:Boolean, sizeChanged:Boolean):void {
		if (sizeChanged) {
			if (!incrementArrow) {
				incrementArrow = new SpinnerIncrementGrayArrow;
				addChild(incrementArrow);
			}

			if (!decrementArrow) {
				decrementArrow = new SpinnerDecrementGrayArrow;
				addChild(decrementArrow);
			}

			incrementArrow.x = width - incrementArrow.width - 6;
			incrementArrow.y = 6;
			decrementArrow.x = incrementArrow.x;
			decrementArrow.y = height - decrementArrow.height - 6;
		}
	}

	override protected function clear(willBeRecycled:Boolean):void {
		if (!willBeRecycled) {
			removeChild(incrementArrow);
			removeChild(decrementArrow);
			incrementArrow = null;
			decrementArrow = null;
		}
	}
}
}
