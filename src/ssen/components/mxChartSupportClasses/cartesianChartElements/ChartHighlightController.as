package ssen.components.mxChartSupportClasses.cartesianChartElements {

import flash.events.Event;

import mx.charts.Legend;
import mx.charts.chartClasses.ChartBase;
import mx.charts.chartClasses.Series;
import mx.charts.events.ChartItemEvent;
import mx.charts.events.LegendMouseEvent;
import mx.charts.series.LineSeries;

public class ChartHighlightController {
	//==========================================================================================
	// properties
	//==========================================================================================
	//---------------------------------------------
	// chart
	//---------------------------------------------
	private var _chart:ChartBase;

	/** target이 되는 chart <code>chart="{chart}"</code> 형태로 넣으면 됨 */
	public function get chart():ChartBase {
		return _chart;
	}

	public function set chart(value:ChartBase):void {
		if (_chart === value) {
			return;
		}

		if (_chart) {
			clearChart(value);
		}

		_chart = value;

		if (value) {
			registerChart(value);
		}
	}

	//---------------------------------------------
	// legend
	//---------------------------------------------
	private var _legend:Legend;

	/** legend */
	public function get legend():Legend {
		return _legend;
	}

	public function set legend(value:Legend):void {
		if (_legend === value) {
			return;
		}

		if (_legend) {
			clearLegend(_legend);
		}

		_legend = value;

		if (value) {
			registerLegend(value);
		}
	}

	//---------------------------------------------
	// targetSereisTypes
	//---------------------------------------------
	[Inspectable(arrayType="Class")]
	private var _targetSereisTypes:Array = [LineSeries];

	/** targetSereisTypes */
	public function get targetSereisTypes():Array {
		return _targetSereisTypes;
	}

	public function set targetSereisTypes(value:Array):void {
		_targetSereisTypes = value;
		clearHighlight();
	}

	//---------------------------------------------
	// highlightAlpha
	//---------------------------------------------
	private var _highlightAlpha:Number = 1;

	/** highlightAlpha */
	public function get highlightAlpha():Number {
		return _highlightAlpha;
	}

	public function set highlightAlpha(value:Number):void {
		_highlightAlpha = value;
		clearHighlight();
	}

	//---------------------------------------------
	// highlightFilters
	//---------------------------------------------
	private var _highlightFilters:Array;
	private var _highlightBitmapFilters:Array = [];

	/** highlightFilters */
	public function get highlightFilters():Array {
		return _highlightFilters;
	}

	public function set highlightFilters(value:Array):void {
		_highlightFilters = value;
		_highlightBitmapFilters = FilterUtils.convertFlexFiltersToFlashBitmapFilters(value);
		clearHighlight();
	}

	//---------------------------------------------
	// unhighlightFilters
	//---------------------------------------------
	private var _unhighlightFilters:Array;
	private var _unhighlightBitmapFilters:Array = [];

	/** unhighlightFilters */
	public function get unhighlightFilters():Array {
		return _unhighlightFilters;
	}

	public function set unhighlightFilters(value:Array):void {
		_unhighlightFilters = value;
		_unhighlightBitmapFilters = FilterUtils.convertFlexFiltersToFlashBitmapFilters(value);
		clearHighlight();
	}

	//---------------------------------------------
	// unhighlightAlpha
	//---------------------------------------------
	private var _unhighlightAlpha:Number = 0.3;

	/** unhighlightAlpha */
	public function get unhighlightAlpha():Number {
		return _unhighlightAlpha;
	}

	public function set unhighlightAlpha(value:Number):void {
		_unhighlightAlpha = value;
		clearHighlight();
	}

	public function clear():void {
		clearHighlight();
	}

	//==========================================================================================
	// registering control targets
	//==========================================================================================
	private function registerChart(chart:ChartBase):void {
		chart.addEventListener("legendDataChanged", chartLegendDataChanged, false, 0, true);
		chart.addEventListener(ChartItemEvent.ITEM_CLICK, chartItemClick, false, 0, true);
	}

	private function clearChart(chart:ChartBase):void {
		chart.removeEventListener("legendDataChanged", chartLegendDataChanged);
		chart.removeEventListener(ChartItemEvent.ITEM_CLICK, chartItemClick);
	}

	private function registerLegend(legend:Legend):void {
		legend.addEventListener(LegendMouseEvent.ITEM_CLICK, legendItemClick, false, 0, true);
	}

	private function clearLegend(legend:Legend):void {
		legend.removeEventListener(LegendMouseEvent.ITEM_CLICK, legendItemClick);
	}

	//==========================================================================================
	// compute highlight
	//==========================================================================================
	private var currentHighlightedSeries:Series;

	private function clearHighlight():void {
		if (!_chart || !_chart.series || _chart.series.length === 0) {
			return;
		}

		var seriesList:Array = _chart.series;
		var series:Series;

		var f:int = seriesList.length;
		while (--f >= 0) {
			series = seriesList[f];
			series.alpha = 1;
			series.filters = [];
		}

		currentHighlightedSeries = null;
	}

	private function setHighlight(highlighted:Series):void {
		if (!_chart || !_chart.series || _chart.series.length === 0) {
			return;
		}

		if (highlighted === currentHighlightedSeries) {
			clearHighlight();
			return;
		}

		currentHighlightedSeries = highlighted;

		var seriesList:Array = _chart.series;
		var series:Series;

		var f:int = seriesList.length;
		while (--f >= 0) {
			series = seriesList[f];

			if (isTargetSeriesType(series)) {
				series.alpha = (series === highlighted) ? _highlightAlpha : _unhighlightAlpha;
				series.filters = (series === highlighted) ? _highlightBitmapFilters : _unhighlightBitmapFilters;
			} else {
				series.alpha = 1;
			}
		}
	}

	private function isTargetSeriesType(series:Series):Boolean {
		var f:int = _targetSereisTypes.length;
		while (--f >= 0) {
			if (series is _targetSereisTypes[f]) {
				return true;
			}
		}

		return false;
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	private function chartLegendDataChanged(event:Event):void {
		clearHighlight();
	}

	private function chartItemClick(event:ChartItemEvent):void {
		setHighlight(event.hitData.chartItem.element as Series);
	}

	private function legendItemClick(event:LegendMouseEvent):void {
		setHighlight(event.item.element as Series);
	}
}
}

