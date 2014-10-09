package ssen.components.mxChartSupportClasses._showcase_.views.charts.fills {
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.graphics.IFill;

/** Bubble을 그려내는 Graphics Fill */
public class AdvancedBubbleFill implements IFill {

	/** Fill Color */
	public var color1:uint;

	/** Stroke Color */
	public var color2:uint;

	public function AdvancedBubbleFill(color1:uint, color2:uint) {
		this.color1=color1;
		this.color2=color2;
	}

	/** @private */
	public function begin(target:Graphics, targetBounds:Rectangle, targetOrigin:Point):void {
		var g:Graphics=target;
		g.lineStyle(2, color2, 1, false);
		g.beginFill(color1);
	}

	/** @private */
	public function end(target:Graphics):void {
		var g:Graphics=target;
		g.endFill();
	}


}
}
import mx.graphics.GradientEntry;
import mx.graphics.RadialGradient;


class AdvancedBubbleFillBack extends RadialGradient {
	public static const NORMAL:String="normal";
	public static const WARNING:String="warning";
	public static const FATAL:String="fatal";

	public var color1:uint;
	public var color2:uint;

	public function AdvancedBubbleFillBack(color1:uint, color2:uint) {
		this.color1=color1;
		this.color2=color2;

		entries=[new GradientEntry(color1, 0), new GradientEntry(color1, 0.5), new GradientEntry(color2, 1)];
	}
}
