package ssen.components.simpleGrid {
import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

public class TestComponent extends UIComponent {
	public function TestComponent() {
		invalidateSize();
		invalidateParentSizeAndDisplayList();
	}


	override protected function commitProperties():void {
		super.commitProperties();
		trace("TestComponent.commitProperties()", name);
	}


	override mx_internal function measureSizes():Boolean {
		var bool:Boolean=super.measureSizes();
		trace("TestComponent.measureSizes()", name);
		return bool;
	}

	override protected function measure():void {
		super.measure();
		trace("TestComponent.measure()", name);
		measuredWidth = 600;
		measuredHeight = 500;
	}


	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		trace("TestComponent.updateDisplayList()", unscaledWidth, unscaledHeight, name);
	}
}
}
