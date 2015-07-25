package ssen.components.mxChartSupportClasses.legend {

import flash.events.Event;

/**
 * Fired when a CheckBoxLegendItem's selected property changes.
 *
 * @author Chris Callendar
 * @date October 21st, 2009
 */
public class CheckBoxLegendItemChangeEvent extends Event {

	public static const CHANGE:String = Event.CHANGE;

	private var _legendItem:CheckBoxLegendItem;

	public function CheckBoxLegendItemChangeEvent(type:String, legendItem:CheckBoxLegendItem) {
		super(type);
		this._legendItem = legendItem;
	}

	public function get legendItem():CheckBoxLegendItem {
		return _legendItem;
	}

	public function get legendItemSelected():Boolean {
		return (_legendItem ? _legendItem.selected : false);
	}

}
}