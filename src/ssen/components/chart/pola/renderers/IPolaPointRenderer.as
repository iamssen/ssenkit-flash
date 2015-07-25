package ssen.components.chart.pola.renderers {
import flash.events.IEventDispatcher;

import mx.core.IVisualElement;

import ssen.common.IDisposable;

public interface IPolaPointRenderer extends IVisualElement, IDisposable {
	//---------------------------------------------
	// data
	//---------------------------------------------
	/** data */
	function get data() : Object;
	function set data(value : Object):void;

	//---------------------------------------------
	// item
	//---------------------------------------------
	/** item */
	function get item() : IEventDispatcher;
	function set item(value : IEventDispatcher):void;

	function render(centerX:Number, centerY:Number, pointX:Number, pointY:Number):void;
}
}
