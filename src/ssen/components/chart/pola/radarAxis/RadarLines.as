package ssen.components.chart.pola.radarAxis {
import ssen.components.chart.pola.*;

import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.collections.IList;
import mx.core.UIComponent;
import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;

import ssen.common.MathUtils;

[DefaultProperty("lines")]

public class RadarLines implements IRadarElement {

	//==========================================================================================
	// properties
	//==========================================================================================
	/** lines */
	public var lines:Vector.<RadarLine>;

	/** stroke */
	public var stroke:IStroke = new SolidColorStroke(0, 1, 0.3, true);

	/** @private */
	public function computeMaximumValue(dataProvider:IList):Number {
		return NaN;
	}

	//==========================================================================================
	// init
	//==========================================================================================
	private var display:Shape;

	public function RadarLines() {
		display = new Shape();
	}

	//==========================================================================================
	// render
	//==========================================================================================
	public function render(radarItems:Vector.<RadarItem>, axis:RadarAxis, chart:PolaChart, targetContainer:UIComponent):void {
		//----------------------------------------------------------------
		// init display
		//----------------------------------------------------------------
		targetContainer.addChild(display);

		var g:Graphics = display.graphics;
		g.clear();

		//----------------------------------------------------------------
		// coordinate info
		//----------------------------------------------------------------
		var maximum:Number = axis.computedMaximum;
		var centerX:Number = chart.computedCenterX;
		var centerY:Number = chart.computedCenterY;
		var radius:Number = chart.computedContentRadius * axis.drawRadiusRatio;

		//----------------------------------------------------------------
		// draw properties
		//----------------------------------------------------------------
		var bound:Rectangle = new Rectangle();
		var point:Point = new Point();
		var line:RadarLine;
		var r:Number;
		var st:IStroke;
		var radarItem:RadarItem;
		var x:Number;
		var y:Number;

		var f:int = -1;
		var fmax:int = lines.length;
		var s:int;
		var smax:int;

		while (++f < fmax) {
			line = lines[f];

			//---------------------------------------------
			// calculate radius
			//---------------------------------------------
			if (!isNaN(line.radiusValue)) {
				r = radius * (line.radiusValue / maximum);
			} else if (MathUtils.rangeOf(line.radiusRatio, 0.1, 1)) {
				r = radius * line.radiusRatio;
			} else {
				continue;
			}

			//---------------------------------------------
			// stroke setting
			//---------------------------------------------
			bound.x = centerX - radius;
			bound.y = centerY - radius;
			bound.width = radius * 2;
			bound.height = radius * 2;
			point.x = centerX - radius;
			point.y = centerY - radius;

			if (line.strokeFunction !== null) {
				st = line.strokeFunction(line);
			} else if (line.stroke) {
				st = line.stroke;
			} else {
				st = stroke;
			}

			st.apply(g, bound, point);
			g.beginFill(0, 0);

			//---------------------------------------------
			// loop
			//---------------------------------------------
			s = -1;
			smax = radarItems.length;

			while (++s < smax) {
				//---------------------------------------------
				// get draw point
				//---------------------------------------------
				radarItem = radarItems[s];
				x = (Math.cos(radarItem.radian) * r) + centerX;
				y = (Math.sin(radarItem.radian) * r) + centerY;

				//---------------------------------------------
				// draw
				//---------------------------------------------
				if (s === 0) {
					g.moveTo(x, y);
				} else {
					g.lineTo(x, y);
				}
			}

			//---------------------------------------------
			// draw line to first point
			//---------------------------------------------
			radarItem = radarItems[0];
			x = (Math.cos(radarItem.radian) * r) + centerX;
			y = (Math.sin(radarItem.radian) * r) + centerY;
			g.lineTo(x, y);

			//---------------------------------------------
			// end stroke
			//---------------------------------------------
			g.endFill();
			g.lineStyle();
		}
	}
}
}
