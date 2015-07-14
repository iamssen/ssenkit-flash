package ssen.components.chart.pola {
import mx.core.IVisualElement;

import ssen.common.IDisposable;

public interface IPolaElement2 extends IVisualElement, IDisposable {
	function resizeDisplayList(centerX:Number, centerY:Number, contentRadius:Number):void;
}
}
