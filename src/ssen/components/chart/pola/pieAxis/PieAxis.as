package ssen.components.chart.pola.pieAxis {
import flash.events.EventDispatcher;

import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.events.CollectionEvent;

import ssen.components.chart.pola.IPolaAxis;
import ssen.components.chart.pola.PolaChart;
import ssen.ssen_internal;

use namespace ssen_internal;

public class PieAxis extends EventDispatcher implements IPolaAxis {
	//==========================================================================================
	// properties
	//==========================================================================================
	private var invalidated:Boolean;

	//---------------------------------------------
	// drawStartAngle
	//---------------------------------------------
	private var _drawStartAngle:Number = 0;

	/** drawStartAngle */
	public function get drawStartAngle():Number {
		return _drawStartAngle;
	}

	public function set drawStartAngle(value:Number):void {
		_drawStartAngle = value;
		invalidate();
	}

	//---------------------------------------------
	// drawEndAngle
	//---------------------------------------------
	private var _drawEndAngle:Number = 360;

	/** drawEndAngle */
	public function get drawEndAngle():Number {
		return _drawEndAngle;
	}

	public function set drawEndAngle(value:Number):void {
		_drawEndAngle = value;
		invalidate();
	}

	//---------------------------------------------
	// dataProvider
	//---------------------------------------------
	private var _dataProvider:IList;

	/** dataProvider */
	public function get dataProvider():IList {
		return _dataProvider;
	}

	public function set dataProvider(value:IList):void {
		if (_dataProvider == value) {
			return;
		}

		if (_dataProvider && _dataProvider.hasEventListener(CollectionEvent.COLLECTION_CHANGE)) {
			_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
		}

		_dataProvider = value;

		if (_dataProvider is ICollectionView) {
			_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
		}

		invalidate();
	}

	//---------------------------------------------
	// chart
	//---------------------------------------------
	private var _chart:PolaChart;

	/** chart */
	public function get chart():PolaChart {
		return _chart;
	}

	public function set chart(value:PolaChart):void {
		_chart = value;
		invalidate();
	}


	//---------------------------------------------
	// series
	//---------------------------------------------
	private var _series:Vector.<IPieElement>;

	/** series */
	public function get series():Vector.<IPieElement> {
		return _series;
	}

	public function set series(value:Vector.<IPieElement>):void {
		_series = value;
		invalidate();
	}

	//---------------------------------------------
	// backgroundElements
	//---------------------------------------------
	private var _backgroundElements:Vector.<IPieElement>;

	/** backgroundElements */
	public function get backgroundElements():Vector.<IPieElement> {
		return _backgroundElements;
	}

	public function set backgroundElements(value:Vector.<IPieElement>):void {
		_backgroundElements = value;
		invalidate();
	}

	//---------------------------------------------
	// annotationElements
	//---------------------------------------------
	private var _annotationElements:Vector.<IPieElement>;

	/** annotationElements */
	public function get annotationElements():Vector.<IPieElement> {
		return _annotationElements;
	}

	public function set annotationElements(value:Vector.<IPieElement>):void {
		_annotationElements = value;
		invalidate();
	}

	//---------------------------------------------
	// drawRadiusRatio
	//---------------------------------------------
	private var _drawRadiusRatio:Number = 1;

	/** drawRadiusRatio */
	public function get drawRadiusRatio():Number {
		return _drawRadiusRatio;
	}

	public function set drawRadiusRatio(value:Number):void {
		_drawRadiusRatio = value;
		invalidate();
	}

	//==========================================================================================
	// render
	//==========================================================================================
	public function render():void {
		if (!_series || _series.length === 0 || !_dataProvider || _dataProvider.length === 0 || !_chart) {
			return;
		}

		if (invalidated) {
			invalidated = false;
		}

		var f:int;
		var fmax:int;

		// render background elements
		if (_backgroundElements && _backgroundElements.length > 0) {
			f = -1;
			fmax = _backgroundElements.length;
			while (++f < fmax) {
				_backgroundElements[f].render(this, _chart, _chart.backgroundElementsHolder);
			}
		}

		// render series
		if (_series.length > 0) {
			f = -1;
			fmax = _series.length;
			while (++f < fmax) {
				_series[f].render(this, _chart, _chart.seriesHolder);
			}
		}

		// render annotation elements
		if (_annotationElements && _annotationElements.length > 0) {
			f = -1;
			fmax = _annotationElements.length;
			while (++f < fmax) {
				_annotationElements[f].render(this, _chart, _chart.annotationElementsHolder);
			}
		}
	}

	private function invalidate():void {
		invalidated = true;

		if (chart) {
			chart.render();
		}
	}

	private function collectionChangeHandler(event:CollectionEvent):void {
		invalidate();
	}
}
}
