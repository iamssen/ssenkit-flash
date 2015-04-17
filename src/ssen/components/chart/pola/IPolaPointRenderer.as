package ssen.components.chart.pola {

import flash.events.IEventDispatcher;

public interface IPolaPointRenderer {
	//---------------------------------------------
	// item
	//---------------------------------------------
	/** item */
	function get item():Object;

	function set item(value:Object):void;

	//---------------------------------------------
	// dispatchTarget
	//---------------------------------------------
	/** dispatchTarget */
	function get dispatchTarget():IEventDispatcher;

	function set dispatchTarget(value:IEventDispatcher):void;

	//----------------------------------------------------------------
	//
	//----------------------------------------------------------------
	function setPoint(centerX:Number, centerY:Number, pointX:Number, pointY:Number):void;

	function dispose():void;
}
}
