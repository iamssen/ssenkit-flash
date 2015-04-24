package ssen.components.mxChartSupportClasses.seriesItemRenderers {
import flash.display.Graphics;
import flash.geom.Rectangle;

import mx.charts.ChartItem;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.core.IDataRenderer;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.skins.ProgrammaticSkin;
import mx.utils.ColorUtil;

public class LineSeriesItemRenderer extends ProgrammaticSkin implements IDataRenderer {
	private var _data:Object;

	public function get data():Object {
		return _data;
	}

	/**
	 * @private
	 */
	public function set data(value:Object):void {
		if (_data == value)
			return;
		_data = value;
	}

	private static var rcFill:Rectangle = new Rectangle();

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		var fill:IFill;
		var state:String = "";

		if (_data is ChartItem && _data.hasOwnProperty('fill')) {
			fill = _data.fill;
			state = _data.currentState;
		} else
			fill = GraphicsUtilities.fillFromStyle(getStyle('fill'));


		var color:uint;
		var adjustedRadius:Number = 0;

		switch (state) {
			case ChartItem.FOCUSED:
			case ChartItem.ROLLOVER:
				if (styleManager.isValidStyleValue(getStyle('itemRollOverColor')))
					color = getStyle('itemRollOverColor');
				else
					color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill), -20);
				fill = new SolidColor(color);
				adjustedRadius = getStyle('adjustedRadius');
				if (!adjustedRadius)
					adjustedRadius = 0;
				break;
			case ChartItem.DISABLED:
				if (styleManager.isValidStyleValue(getStyle('itemDisabledColor')))
					color = getStyle('itemDisabledColor');
				else
					color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill), 20);
				fill = new SolidColor(GraphicsUtilities.colorFromFill(color));
				break;
			case ChartItem.FOCUSEDSELECTED:
			case ChartItem.SELECTED:
				if (styleManager.isValidStyleValue(getStyle('itemSelectionColor')))
					color = getStyle('itemSelectionColor');
				else
					color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill), -30);
				fill = new SolidColor(color);
				adjustedRadius = getStyle('adjustedRadius');
				if (!adjustedRadius)
					adjustedRadius = 0;
				break;
		}

		var stroke:IStroke = getStyle("lineStroke");

		var w:Number = stroke ? stroke.weight / 2 : 0;

		rcFill.right = unscaledWidth;
		rcFill.bottom = unscaledHeight;

		var g:Graphics = graphics;
		g.clear();
		if (stroke)
			stroke.apply(g, null, null);
		if (fill)
			fill.begin(g, rcFill, null);
		g.drawEllipse(w - adjustedRadius, w - adjustedRadius, unscaledWidth - 2 * w + adjustedRadius * 2, unscaledHeight - 2 * w + adjustedRadius * 2);

		if (fill)
			fill.end(g);
	}

}
}
