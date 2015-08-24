package ssen.components.chart.pola.pieAxis {
import mx.core.UIComponent;

import ssen.components.chart.pola.IPolaElement;
import ssen.components.chart.pola.PolaChart;

[Deprecated(message="Remove when end of project")]

public interface IPieElement extends IPolaElement {
	function render(axis:PieAxis, chart:PolaChart, targetContainer:UIComponent, animationRatio:Number):void;
}
}
