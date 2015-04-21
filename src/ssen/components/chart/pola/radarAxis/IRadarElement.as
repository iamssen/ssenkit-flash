package ssen.components.chart.pola.radarAxis {
import mx.core.UIComponent;

import ssen.components.chart.pola.*;

public interface IRadarElement extends IPolaElement {
	function render(radarItems:Vector.<RadarItem>, axis:RadarAxis, chart:PolaChart, targetContainer:UIComponent, animationTime:Number):void;
}
}
