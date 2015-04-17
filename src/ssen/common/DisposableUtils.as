package ssen.common {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;

import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;

public class DisposableUtils {
	public static function disposeContainer(container:IVisualElementContainer):void {
		var el:IVisualElement;
		var f:int = container.numElements;
		while (--f >= 0) {
			el = container.getElementAt(f);
			if (el is IDisposable) IDisposable(el).dispose();
		}
		container.removeAllElements();
		if (container["graphics"] is Graphics) Graphics(container["graphics"]).clear();
	}

	public static function disposeDisplayContainer(container:DisplayObjectContainer):void {
		var d:DisplayObject;
		var f:int = container.numChildren;
		while (--f >= 0) {
			d = container.getChildAt(f);
			if (d is IDisposable) IDisposable(d).dispose();
			container.removeChildAt(f);
		}
		if (container["graphics"] is Graphics) Graphics(container["graphics"]).clear();
	}
}
}
