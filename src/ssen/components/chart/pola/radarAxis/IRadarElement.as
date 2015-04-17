package ssen.components.chart.pola.radarAxis {
import ssen.components.chart.pola.*;

import mx.core.UIComponent;

import ssen.components.chart.pola.radarAxis.RadarAxis;
import ssen.components.chart.pola.radarAxis.RadarItem;

public interface IRadarElement extends IPolaElement {
	function render(radarItems:Vector.<RadarItem>, axis:RadarAxis, chart:PolaChart, targetContainer:UIComponent):void;
}
}
