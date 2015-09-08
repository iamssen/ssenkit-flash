package ssen.components.base {
import mx.core.mx_internal;

import spark.components.Group;

use namespace mx_internal;

public class Showcase__SizeProperties extends Group {
	public function Showcase__SizeProperties() {
		var comp:Comp = new Comp;
		//		comp.setStyle("left", 0);
		//		comp.setStyle("right", 0);
		comp.percentWidth = 70;
		//		comp.explicitWidth = 400;
		addElement(comp);
	}


	override mx_internal function measureSizes():Boolean {
		return super.mx_internal::measureSizes();
	}
}
}

import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

class Comp extends UIComponent {
	//	override protected function canSkipMeasurement():Boolean {
	//		var skip:Boolean = super.canSkipMeasurement();
	//		trace("Comp.canSkipMeasurement()", skip);
	//		return false;
	//	}
	//
	//	override mx_internal function measureSizes():Boolean {
	//		var changed:Boolean = super.mx_internal::measureSizes();
	//		trace("Comp.measureSizes()", measuredWidth);
	//		//		invalidateSizeFlag = true;
	//		//		setActualSize(200, NaN);
	//		//		measuredWidth = 200;
	//		//		_explicitMaxWidth = 200;
	//		return true;
	//	}
	//
	//	override protected function measure():void {
	//		super.measure();
	//		trace("Comp.measure()", measuredWidth);
	//		measuredWidth = 300;
	//		measuredMinWidth = 100;
	//	}

	override public function setActualSize(w:Number, h:Number):void {
		trace("Comp.setActualSize()", w);
		super.setActualSize(200, h);
	}

	//	override public function getExplicitOrMeasuredWidth():Number {
	//		return 200;
	//	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		trace("Comp.updateDisplayList()", unscaledWidth, measuredWidth);
	}
}