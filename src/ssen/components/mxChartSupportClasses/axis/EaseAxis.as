package ssen.components.mxChartSupportClasses.axis {

import mx.charts.AxisLabel;
import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.NumericAxis;

public class EaseAxis extends NumericAxis {
	public function EaseAxis() {
		super();
	}

	//---------------------------------------------
	// ease
	//---------------------------------------------
	private var _ease:Function;

	/** ease */
	public function get ease():Function {
		return _ease;
	}

	public function set ease(value:Function):void {
		_ease = value;
		invalidateCache();
	}

	override public function set direction(value:String):void {
		super.direction = value;
	}

	override protected function adjustMinMax(minValue:Number, maxValue:Number):void {
		super.adjustMinMax(minValue, maxValue);
	}

	override public function mapCache(cache:Array, field:String, convertedField:String, indexValues:Boolean = false):void {
		super.mapCache(cache, field, convertedField, indexValues);
	}


	override protected function buildLabelCache():Boolean {
		return super.buildLabelCache();
	}


	override protected function buildMinorTickCache():Array {
		return super.buildMinorTickCache();
	}


	override public function reduceLabels(intervalStart:AxisLabel, intervalEnd:AxisLabel):AxisLabelSet {
		return super.reduceLabels(intervalStart, intervalEnd);
	}


	override public function invertTransform(value:Number):Object {
		return super.invertTransform(value);
	}


	override protected function guardMinMax(min:Number, max:Number):Array {
		return super.guardMinMax(min, max);
	}
}
}
