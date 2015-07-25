package ssen.components.chart.pola.pieAxis {
import mx.core.IUIComponent;
import mx.graphics.IFill;

public interface IPieSeriesWedgeRenderer extends IUIComponent {
	//---------------------------------------------
	// outerRadius
	//---------------------------------------------
	/** outerRadius */
	function get outerRadius():Number;

	function set outerRadius(value:Number):void;

	//---------------------------------------------
	// innerRadius
	//---------------------------------------------
	/** innerRadius */
	function get innerRadius():Number;

	function set innerRadius(value:Number):void;

	//---------------------------------------------
	// pie
	//---------------------------------------------
	/** pie */
	function get pie():PieSeriesWedge;

	function set pie(value:PieSeriesWedge):void;

	//---------------------------------------------
	// fill
	//---------------------------------------------
	/** fill */
	function get fill():IFill;

	function set fill(value:IFill):void;

	//---------------------------------------------
	// order
	//---------------------------------------------
	/** order */
	function get order():Number;

	function set order(value:Number):void;

	//---------------------------------------------
	// animate
	//---------------------------------------------
	/** animate */
	function get animate():Number;

	function set animate(value:Number):void;

	//	//---------------------------------------------
	//	// showDataTip
	//	//---------------------------------------------
	//	/** showDataTip */
	//	function get showDataTip():Boolean;
	//
	//	function set showDataTip(value:Boolean):void;
}
}
