package ssen.components.chart.pola {
import flash.events.IEventDispatcher;

import mx.collections.IList;

// 데이터를 논리적으로 어떻게 해석할 것인지를 결정한다
// 데이터를 가지고 논리적인 데이터들을 만들어낸다 (Ratio Base)
public interface IPolaAxis extends IEventDispatcher {
	//---------------------------------------------
	// dataProvider
	//---------------------------------------------
	//	/** dataProvider */
	//	function get dataProvider():IList;
	//
	//	function set dataProvider(value:IList):void;

	//---------------------------------------------
	// chart
	//---------------------------------------------
	/** chart */
	function get chart():PolaChart;

	function set chart(value:PolaChart):void;

	//---------------------------------------------
	// series
	//---------------------------------------------
	//	/** series */
	//	function get series():Vector.<IRadarElement>;
	//
	//	function set series(value:Vector.<IRadarElement>):void;

	/** render */
	function render():void;
}
}
