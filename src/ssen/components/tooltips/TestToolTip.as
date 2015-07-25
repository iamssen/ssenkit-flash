package ssen.components.tooltips {
import flash.display.Graphics;

import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;

public class TestToolTip extends UIComponent implements IFlexDisplayObject {
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0, 0.4);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();
	}
}
}
