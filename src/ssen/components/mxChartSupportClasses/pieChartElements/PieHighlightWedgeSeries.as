package ssen.components.mxChartSupportClasses.pieChartElements {

import flash.display.DisplayObject;

import mx.charts.series.PieSeries;
import mx.charts.series.items.PieSeriesItem;
import mx.core.IDataRenderer;
import mx.filters.IBitmapFilter;

import spark.filters.GlowFilter;

public class PieHighlightWedgeSeries extends PieSeries {
	//---------------------------------------------
	// highlightFilters
	//---------------------------------------------
	private var highlightFiltersChanged:Boolean = true;
	private var _highlightFilters:Array = [new GlowFilter(0xffffff, 0.7, 7, 7, 5)];
	/** highlightFilters */
	public function get highlightFilters():Array {
		return _highlightFilters;
	}

	[Inspectable(arrayType="mx.filters.IBitmapFilter")]
	public function set highlightFilters(value:Array):void {
		_highlightFilters = value;
		highlightFiltersChanged = true;
		invalidateProperties();
	}

	//---------------------------------------------
	// highlightFunction
	//---------------------------------------------
	private var _highlightFunction:Function;

	/** highlightFunction */
	public function get highlightFunction():Function {
		return _highlightFunction;
	}

	public function set highlightFunction(value:Function):void {
		_highlightFunction = value;
		invalidateDisplayList();
	}

	//==========================================================================================
	// life cycle
	//==========================================================================================
	override protected function dataChanged():void {
		super.dataChanged();

		invalidateDisplayList();
	}

	//==========================================================================================
	//
	//==========================================================================================
	private var highlightBitmapFilters:Array;

	override protected function commitProperties():void {
		super.commitProperties();

		if (highlightFiltersChanged) {
			highlightBitmapFilters = [];

			var f:int = -1;
			var fmax:int = _highlightFilters.length;
			var bitmapFilter:IBitmapFilter;

			while (++f < fmax) {
				bitmapFilter = _highlightFilters[f];
				highlightBitmapFilters.push(bitmapFilter.clone());
			}

			highlightFiltersChanged = false;

			invalidateDisplayList();
		}
	}

	//==========================================================================================
	// draw
	//==========================================================================================
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (_highlightFunction === null) {
			return;
		}

		clearTicks();

		var f:int = -1;
		var fmax:int = numChildren;
		var child:DisplayObject;
		var dataRenderer:IDataRenderer;
		var wedge:DisplayObject;
		var item:PieSeriesItem;

		var highlighedWedges:Vector.<DisplayObject> = new Vector.<DisplayObject>();

		while (++f < fmax) {
			child = getChildAt(f);

			if (child is IDataRenderer) {
				dataRenderer = child as IDataRenderer;
				item = dataRenderer.data as PieSeriesItem;

				if (item.item) {
					wedge = child as DisplayObject;
					if (_highlightFunction(item.item)) {
						highlighedWedges.push(wedge);
						setHighlighter(wedge);
					} else {
						wedge.filters = [];
					}
				}
			}
		}

		f = highlighedWedges.length;
		while (--f >= 0) {
			wedge = highlighedWedges[f];
			wedge.parent.setChildIndex(wedge, wedge.parent.numChildren - 1);
		}

		if (labelContainer) {
			labelContainer.parent.setChildIndex(labelContainer, labelContainer.parent.numChildren - 1);
		}
	}

	private var ticks:Vector.<Tick> = new Vector.<Tick>();

	protected function setHighlighter(wedge:DisplayObject):void {
		if (Tick.hasWedge(wedge)) {
			return;
		}

		var tick:Tick = new Tick;
		tick.wedge = wedge;
		tick.filters = highlightBitmapFilters.slice();
		tick.start();

		ticks.push(tick);
	}

	private function clearTicks():void {
		if (ticks.length === 0) {
			return;
		}

		var f:int = ticks.length;
		while (--f >= 0) {
			ticks[f].stop();
		}

		ticks.length = 0;
	}
}
}

import flash.display.DisplayObject;
import flash.events.Event;

class Tick {
	private static var wedges:Object = {};

	public static function hasWedge(wedge:DisplayObject):Boolean {
		return wedges[wedge] !== undefined;
	}

	public var wedge:DisplayObject;
	private var tick:int;
	public const TICK:int = 60;
	public var filters:Array;

	public function start():void {
		wedges[wedge] = wedge;

		tick = TICK;

		wedge.filters = filters;
		wedge.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		wedge.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	}

	public function stop():void {
		dispose();
	}

	private function enterFrameHandler(event:Event):void {
		// trace("Tick.enterFrameHandler(", event, tick, wedge.filters.length, wedge.filters.length > 0, wedge.name, ")");
		if (--tick > 0) {
		} else {
			if (wedge.filters.length > 0) {
				wedge.filters = [];
			} else {
				wedge.filters = filters;
			}

			tick = TICK;
		}
	}

	private function removedFromStageHandler(event:Event):void {
		dispose();
	}

	private function dispose():void {
		wedge.filters = [];

		wedge.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		wedge.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

		delete wedges[wedge];
	}
}
