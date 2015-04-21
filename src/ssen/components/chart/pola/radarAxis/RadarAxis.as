package ssen.components.chart.pola.radarAxis {
import flash.events.EventDispatcher;

import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.events.CollectionEvent;

import ssen.components.animate.Animation;
import ssen.components.chart.pola.*;
import ssen.ssen_internal;

use namespace ssen_internal;

public class RadarAxis extends EventDispatcher implements IPolaAxis {
	//==========================================================================================
	// properties
	//==========================================================================================
	private var invalidated:Boolean;

	//---------------------------------------------
	// animation
	//---------------------------------------------
	private var _animation:Animation = new Animation(3);

	/** animation */
	public function get animation():Animation {
		return _animation;
	}

	public function set animation(value:Animation):void {
		if (_animation) _animation.stop();
		_animation = value;
	}

	//---------------------------------------------
	// maximum
	//---------------------------------------------
	private var _maximum:Number;

	/** maximum */
	public function get maximum():Number {
		return _maximum;
	}

	public function set maximum(value:Number):void {
		_maximum = value;
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

	private function collectionChangeHandler(event:CollectionEvent):void {
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
	// computedMaximum
	//---------------------------------------------
	private var _computedMaximum:Number;

	/** computedMaximum */
	public function get computedMaximum():Number {
		return _computedMaximum;
	}

	//---------------------------------------------
	// series
	//---------------------------------------------
	private var _series:Vector.<IRadarElement>;

	/** series */
	public function get series():Vector.<IRadarElement> {
		return _series;
	}

	public function set series(value:Vector.<IRadarElement>):void {
		_series = value;
		invalidate();
	}

	//---------------------------------------------
	// backgroundElements
	//---------------------------------------------
	private var _backgroundElements:Vector.<IRadarElement>;

	/** backgroundElements */
	public function get backgroundElements():Vector.<IRadarElement> {
		return _backgroundElements;
	}

	public function set backgroundElements(value:Vector.<IRadarElement>):void {
		_backgroundElements = value;
		invalidate();
	}

	//---------------------------------------------
	// annotationElements
	//---------------------------------------------
	private var _annotationElements:Vector.<IRadarElement>;

	/** annotationElements */
	public function get annotationElements():Vector.<IRadarElement> {
		return _annotationElements;
	}

	public function set annotationElements(value:Vector.<IRadarElement>):void {
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
	internal var items:Vector.<RadarItem>;

	public function render():void {
		if (!_series || _series.length === 0 || !_dataProvider || _dataProvider.length === 0 || !_chart) {
			return;
		}

		if (invalidated) {
			compute();
			invalidated = false;
		}

		if (!items) {
			return;
		}

		if (animation) animation.stop();
		animation.start(renderFrame);
	}

	private function renderFrame(time:Number):void {
		var f:int;
		var fmax:int;

		// render background elements
		if (_backgroundElements && _backgroundElements.length > 0) {
			f = -1;
			fmax = _backgroundElements.length;
			while (++f < fmax) {
				_backgroundElements[f].render(items, this, _chart, _chart.backgroundElementsHolder, time);
			}
		}

		// render series
		if (_series.length > 0) {
			f = -1;
			fmax = _series.length;
			while (++f < fmax) {
				_series[f].render(items, this, _chart, _chart.seriesHolder, time);
			}
		}

		// render annotation elements
		if (_annotationElements && _annotationElements.length > 0) {
			f = -1;
			fmax = _annotationElements.length;
			while (++f < fmax) {
				_annotationElements[f].render(items, this, _chart, _chart.annotationElementsHolder, time);
			}
		}
	}

	private function compute():void {
		var max:Number = Number.MIN_VALUE;
		var n:Number;
		var source:Object;
		var series:IRadarElement;
		var vo:RadarItem;

		var f:int;
		var fmax:int;

		var vos:Vector.<RadarItem>;
		var wedge:Number;
		var angle:Number;

		//---------------------------------------------
		// compute series / maximum
		//---------------------------------------------
		if (isNaN(_maximum)) {
			f = _series.length;

			while (--f >= 0) {
				series = _series[f];

				n = series.computeMaximumValue(_dataProvider);

				if (!isNaN(n) && n > max) {
					max = n;
				}
			}

			_computedMaximum = max;
		} else {
			_computedMaximum = _maximum;
		}

		//---------------------------------------------
		// compute data
		//---------------------------------------------
		f = -1;
		fmax = _dataProvider.length;

		vos = new Vector.<RadarItem>(fmax, true);
		wedge = 360 / fmax;
		angle = 0;

		while (++f < fmax) {
			source = _dataProvider.getItemAt(f);

			vo = new RadarItem();
			vo.angle = angle;
			vo.data = source;
			vo.radian = rotate(angle) * Math.PI / 180;
			vos[f] = vo;

			angle += wedge;
		}

		items = vos;
	}

	private static function rotate(angle:Number):Number {
		angle -= 90;

		if (angle < 0) {
			angle = 360 + angle;
		} else if (angle > 360) {
			angle = angle - 360;
		}

		return angle;
	}

	//==========================================================================================
	// invalidation
	//==========================================================================================
	private function invalidate():void {
		invalidated = true;

		if (chart) {
			chart.render();
		}
	}
}
}