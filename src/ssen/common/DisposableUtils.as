package ssen.common {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.text.engine.TextLine;

import flashx.textLayout.compose.TextLineRecycler;

import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;

public class DisposableUtils {
	public static function disposeContainer(container:IVisualElementContainer, clearGraphics:Boolean = true):void {
		var el:IVisualElement;
		var f:int = container.numElements;
		while (--f >= 0) {
			el = container.getElementAt(f);
			if (el is IDisposable) IDisposable(el).dispose();
			if (el is TextLine) TextLineRecycler.addLineForReuse(el as TextLine);
		}
		container.removeAllElements();

		if (clearGraphics && container["graphics"] is Graphics) Graphics(container["graphics"]).clear();
	}

	public static function disposeDisplayContainer(container:DisplayObjectContainer, clearGraphics:Boolean = true):void {
		var d:DisplayObject;
		var f:int = container.numChildren;
		while (--f >= 0) {
			d = container.getChildAt(f);
			if (d is IDisposable) IDisposable(d).dispose();
			if (d is TextLine) TextLineRecycler.addLineForReuse(d as TextLine);
			container.removeChildAt(f);
		}

		if (clearGraphics && container["graphics"] is Graphics) Graphics(container["graphics"]).clear();
	}
}
}
