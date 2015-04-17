package ssen.components.chart.pola.radarAxis {

import mx.utils.StringUtil;

public class RadarItem {
	public var angle:Number;
	public var data:Object;
	public var radian:Number;

	public function toString():String {
		return StringUtil.substitute("[RadarVO angle={0} data={1}]", angle, data);
	}
}
}
