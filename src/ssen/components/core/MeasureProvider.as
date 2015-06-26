package ssen.components.core {
import mx.core.IUIComponent;

import ssen.ssen_internal;

use namespace ssen_internal;

public class MeasureProvider {
	//	[Inspectable(type="Array", enumeration="left,center,right", defaultValue="center")]
	//	public var horizontalAlign:String = "center";
	//
	//	[Inspectable(type="Array", enumeration="top,middle,bottom", defaultValue="middle")]
	//	public var verticalAlign:String = "middle";

	public var contentWidth:Number;

	public var contentHeight:Number;

	ssen_internal var component:IUIComponent;

	public function MeasureProvider(component:IUIComponent) {
		this.component = component;
	}

	public function getMeasureWidth():Number {
		return getMeasureSize(component.explicitWidth, component.explicitMinWidth, component.explicitMaxWidth, contentWidth);
	}

	public function getMeasureHeight():Number {
		return getMeasureSize(component.explicitHeight, component.explicitMinHeight, component.explicitMaxHeight, contentHeight);
	}

	public function canSkipMeasurment():Boolean {
		if (!isNaN(component.explicitWidth) && !isNaN(component.explicitHeight)) {
			return true;
		} else {
			return component.width != getMeasureWidth() || component.height != getMeasureHeight();
		}
	}

	private static function getMeasureSize(explicit:Number, explicitMin:Number, explicitMax:Number, content:Number):Number {
		if (!isNaN(explicit)) {
			return explicit;
		} else if (!isNaN(explicitMax) && content > explicitMax) {
			return explicitMax;
		} else if (!isNaN(explicitMin) && content < explicitMin) {
			return explicitMin;
		} else {
			return content;
		}
	}
}
}
