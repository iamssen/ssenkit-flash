package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import flash.geom.Rectangle;

import mx.charts.series.items.BubbleSeriesItem;
import mx.core.IDataRenderer;
import mx.events.PropertyChangeEvent;
import mx.graphics.SolidColor;
import mx.skins.ProgrammaticSkin;
import mx.utils.ColorUtil;

import ssen.components.mxChartSupportClasses._showcase_.views.charts.fills.AdvancedBubbleFill;
import ssen.components.mxChartSupportClasses._showcase_.views.charts.fills.StatusFatalFill;
import ssen.components.mxChartSupportClasses._showcase_.views.charts.fills.StatusNormalFill;
import ssen.components.mxChartSupportClasses._showcase_.views.charts.fills.StatusWarningFill;

/** Bubble Chart 내부의 Bubble 들을 그리는 Renderer */
public class AdvancedBubbleRenderer extends ProgrammaticSkin implements IDataRenderer {

	//==========================================================================================
	// data
	//==========================================================================================
	//----------------------------------
	//  data
	//----------------------------------
	private var _data:Object;

	/** @private */
	public function get data():Object {
		return _data;
	}

	/** @private */
	public function set data(value:Object):void {
		if (_data == value) {
			return;
		}

		var d:IAdvancedBubbleData;

		// remove event old data
		if (_data && _data.item is IAdvancedBubbleData) {
			d=_data.item as IAdvancedBubbleData;
			d.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChanged);
		}

		_data=value;

		// add event new data
		if (value.item is IAdvancedBubbleData) {
			d=value.item as IAdvancedBubbleData;
			d.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChanged, false, 0, true);
		}

		invalidateDisplayList();
	}

	// event handler
	private function propertyChanged(event:PropertyChangeEvent):void {
		if (listenProperties.indexOf(event.property) > -1) {
			invalidateDisplayList();
		}
	}

	/** PropertyChangeEvent 시점에 잡아낼 property 항목들 */
	protected var listenProperties:Array=["selected", "status"];

	//==========================================================================================
	// draw
	//==========================================================================================
	private static var rect:Rectangle=new Rectangle();

	/** @private */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (!_data || !_data.item) {
			return;
		}

		var data:IAdvancedBubbleData=_data.item as IAdvancedBubbleData;
		var fill:AdvancedBubbleFill=calculateStatus();
		var x:Number;
		var y:Number;
		var radius:Number;
		const w:Number=0;

		if (_data is BubbleSeriesItem) {
			BubbleSeriesItem(_data).fill=new SolidColor(fill.color1);
				//			trace("AdvancedBubbleRenderer.updateDisplayList(", _data, ")");
		}

		//----------------------------------------------------------------
		// draw
		//----------------------------------------------------------------
		rect.right=unscaledWidth;
		rect.bottom=unscaledWidth;

		x=unscaledWidth / 2;
		y=unscaledHeight / 2;

		graphics.clear();

		if (data.selected) {
			radius=(getRadius() + 3) + (unscaledWidth / 2);

			graphics.beginFill(ColorUtil.adjustBrightness2(fill.color2, -60));
			graphics.drawCircle(x, y, radius);
			graphics.endFill();
		}

		radius=getRadius() + (unscaledWidth / 2);

		fill.begin(graphics, rect, null);
		graphics.drawCircle(x, y, radius);
		fill.end(graphics);
	}

	private static const DEFAULT:AdvancedBubbleFill=new AdvancedBubbleFill(0x555555, 0x000000);
	private static const NORMAL:AdvancedBubbleFill=new StatusNormalFill;
	private static const WARNING:AdvancedBubbleFill=new StatusWarningFill;
	private static const FATAL:AdvancedBubbleFill=new StatusFatalFill;

	/** Bubble의 색상을 계산한다 */
	protected function calculateStatus():AdvancedBubbleFill {
		var series:AdvancedBubbleSeries=_data.element as AdvancedBubbleSeries;
		var item:BubbleSeriesItem=_data as BubbleSeriesItem;

		var xbase:Number=series.xBase;
		var ybase:Number=series.yBase;
		var x:Number=Number(item.xValue);
		var y:Number=Number(item.yValue);

		if (x < xbase && y < ybase) {
			return NORMAL;
		} else if (x > xbase && y > ybase) {
			return FATAL;
		} else {
			return WARNING;
		}

		return DEFAULT;
	}

	/** Bubble의 Radius를 계산한다 */
	protected function getRadius():Number {
		var r:Number=getStyle('adjustedRadius');
		if (!r || r < 0) {
			r=0;
		}
		return r;
	}
}
}
