package ssen.components.chart.pola.radarAxis {

import mx.graphics.IStroke;

[DefaultProperty("stroke")]

public class RadarLine {
	/** radiusRatio 0 ~ 1 */
	public var radiusRatio:Number;

	/** radiusValue : is process order higher than radiusRatio */
	public var radiusValue:Number;

	/** stroke */
	public var stroke:IStroke;

	/** strokeFunction `function(radarLine:RadarLine):IStroke` */
	public var strokeFunction:Function;
}
}
