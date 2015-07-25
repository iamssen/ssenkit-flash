package ssen.components.chart.pola.renderers {
import flash.events.IEventDispatcher;

import ssen.common.MathUtils;
import ssen.text.UIHtmlLines;

public class LabelPolaPointRenderer extends UIHtmlLines implements IPolaPointRenderer {
	//==========================================================================================
	// Style
	//==========================================================================================
	//----------------------------------------------------------------
	// label data
	//----------------------------------------------------------------
	/** labelField */
	public var labelField:String;

	/** labelFunction `function(data:Object, labelField:String):String` */
	public var labelFunction:Function;

	//==========================================================================================
	// implements IChartPointRenderer
	//==========================================================================================
	//---------------------------------------------
	// data
	//---------------------------------------------
	private var _data:Object;

	/** data */
	public function get data():Object {
		return _data;
	}

	public function set data(value:Object):void {
		_data = value;
	}

	//---------------------------------------------
	// item
	//---------------------------------------------
	private var _item:IEventDispatcher;

	/** item */
	public function get item():IEventDispatcher {
		return _item;
	}

	public function set item(value:IEventDispatcher):void {
		_item = value;
	}

	public function render(centerX:Number, centerY:Number, pointX:Number, pointY:Number):void {
		text = (labelFunction !== null) ? labelFunction(data, labelField) : data[labelField].toString();

		createTextLines();

		if (MathUtils.rangeOf(pointX, centerX - 10, centerX + 10)) {
			pointX = pointX - (width / 2);
		} else if (pointX < centerX) {
			pointX = pointX - width;
		}

		if (MathUtils.rangeOf(pointY, centerY - 10, centerY + 10)) {
			pointY = pointY - (height / 2);
		} else if (pointY < centerY) {
			pointY = pointY - height;
		}

		x = pointX;
		y = pointY;
	}

	public function dispose():void {
		// dispose?
	}


}
}
