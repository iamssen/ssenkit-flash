package ssen.flexkit.components.grid.renderers {
import ssen.theme.squared.assets.DropDownGrayArrow;

public class SelectionalGridRenderer extends GridRenderer {
	private var dropDownArrow:DropDownGrayArrow;

	public function SelectionalGridRenderer() {
		setStyle("paddingRight", 20);
	}

	override protected function draw(hasBeenRecycled:Boolean, dataChanged:Boolean, columnChanged:Boolean, sizeChanged:Boolean):void {
		if (sizeChanged) {
			if (!dropDownArrow) {
				dropDownArrow=new DropDownGrayArrow;
				addChild(dropDownArrow);
			}

			dropDownArrow.x=width - dropDownArrow.width - 4;
			dropDownArrow.y=int((height - dropDownArrow.height) / 2);
		}
	}

	override protected function clear(willBeRecycled:Boolean):void {
		if (!willBeRecycled) {
			removeChild(dropDownArrow);
			dropDownArrow=null;
		}
	}
}
}
