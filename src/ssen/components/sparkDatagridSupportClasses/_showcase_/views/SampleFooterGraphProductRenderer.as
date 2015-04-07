package ssen.components.sparkDatagridSupportClasses._showcase_.views {
import ssen.components.sparkDatagridSupportClasses.renderers.GridRenderer;

public class SampleFooterGraphProductRenderer extends GridRenderer {
	public function SampleFooterGraphProductRenderer() {
		setStyle("paddingLeft", 30);
	}

	override protected function clear(willBeRecycled:Boolean):void {
		if (!willBeRecycled) {
			graphics.clear();
		}
	}

	private const symbolWidth:int=10;
	private const symbolHeight:int=10;

	override protected function draw(hasBeenRecycled:Boolean, dataChanged:Boolean, columnChanged:Boolean, sizeChanged:Boolean):void {
		if (sizeChanged) {
			var y:int=(height - symbolHeight) / 2;

			graphics.clear();

			graphics.beginFill(data.color);
			graphics.drawRect(13, y, symbolWidth, symbolHeight);
			graphics.endFill();
		}
	}
}
}
