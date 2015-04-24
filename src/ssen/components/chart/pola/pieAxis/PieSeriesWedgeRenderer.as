package ssen.components.chart.pola.pieAxis {
import flash.display.Graphics;
import flash.display.GraphicsPath;

import mx.graphics.IFill;

import spark.core.SpriteVisualElement;

import ssen.drawing.PathMaker;

public class PieSeriesWedgeRenderer extends SpriteVisualElement {
	public function render(outerRadius:Number, innerRadius:Number, pie:Pie, fill:IFill, index:Number, animationTime:Number):void {
		var animate:Number = ((1 - index) * animationTime) + animationTime;
		animate = Math.min(1, animate);

		outerRadius = outerRadius * animate;
		innerRadius = innerRadius + (outerRadius * (1 - animate));
		alpha = animate;

		var path:GraphicsPath = PathMaker.donut(0, 0, outerRadius, innerRadius, pie.startDeg, pie.endDeg);
		var graphics:Graphics = graphics;

		graphics.clear();

		graphics.lineStyle(4, 0xffffff);

		fill.begin(graphics, null, null);
		graphics.drawPath(path.commands, path.data, path.winding);
		fill.end(graphics);

		graphics.lineStyle();
	}
}
}
