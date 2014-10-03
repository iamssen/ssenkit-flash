package ssen.components.core {

import flash.display.Graphics;

import mx.core.UIComponent;

public class TransparentElement extends UIComponent {
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var g:Graphics = graphics;
		g.beginFill(0, 0);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();
	}
}
}
