package ssen.components.mxDatagridSupportClasses.chartWeaver {
import mx.charts.ColumnChart;
import mx.events.PropertyChangeEvent;

public class GridAndChartWeaverColumnChart extends ColumnChart {

	override public function set dataProvider(value:Object):void {
		var oldValue:Object=dataProvider;

		super.dataProvider=value;

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "dataProvider", oldValue, value));
		}
	}
}
}
