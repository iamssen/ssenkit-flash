package ssen.components.chart.pola.pieAxis2 {
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.core.UIComponent;
import mx.events.CollectionEvent;

import ssen.animation.Animation;
import ssen.components.chart.pola.IPolaElement2;

/*
ENTER = ANIMATION
EXIT = CUT
ADD = CUT
REMOVE = CUT
CHANGE = CUT
*/
public class PieAxis extends UIComponent implements IPolaElement2 {
	//==========================================================================================
	// setting
	//==========================================================================================
	//---------------------------------------------
	// animation
	//---------------------------------------------
	private var _animation:Animation;

	/** animation */
	public function get animation():Animation {
		return _animation;
	}

	public function set animation(value:Animation):void {
		if (_animation) _animation.dispose();
		_animation = value;
	}

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
		invalidate_drawProperties();
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
		invalidate_drawProperties();
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
		invalidate_drawProperties();
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
		if (_dataProvider === value) {
			return;
		}

		if (_dataProvider && _dataProvider.hasEventListener(CollectionEvent.COLLECTION_CHANGE)) {
			_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
		}

		_dataProvider = value;

		if (_dataProvider is ICollectionView) {
			_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler, false, 0, true);
		}

		invalidate_dataProvider();
	}

	//---------------------------------------------
	// elements
	//---------------------------------------------
	private var _elements:Vector.<PieAxisElement>;

	/** elements */
	public function get elements():Vector.<PieAxisElement> {
		return _elements;
	}

	public function set elements(value:Vector.<PieAxisElement>):void {
		var oldElements:Vector.<PieAxisElement> = _elements;
		var newElements:Vector.<PieAxisElement> = value;
		var element:PieAxisElement;

		var f:int;

		if (oldElements && oldElements.length > 0) {
			f = oldElements.length;
			while (--f >= 0) {
				element = oldElements[f];
				if (!newElements || newElements.indexOf(element) === -1) {
					element.dispose();
				}
			}
		}

		if (newElements && newElements.length > 0) {
			f = newElements.length;
			while (--f >= 0) {
				element = newElements[f];
				if (element.axis !== this) {
					element.axis = this;
				}
			}
		}

		_elements = value;
		invalidate_dataProvider();
	}


	//==========================================================================================
	// from pola container
	//==========================================================================================
	private var _centerX:Number;
	private var _centerY:Number;
	private var _contentRadius:Number;

	public function get centerX():Number {
		return _centerX;
	}

	public function get centerY():Number {
		return _centerY;
	}

	public function get contentRadius():Number {
		return _contentRadius;
	}

	public function resizeDisplayList(centerX:Number, centerY:Number, contentRadius:Number):void {
		_centerX = centerX;
		_centerY = centerY;
		_contentRadius = contentRadius;

		invalidate_drawProperties();
	}

	//==========================================================================================
	// invalidate
	//==========================================================================================
	//---------------------------------------------
	// inavalidate drawProperties
	//---------------------------------------------
	private var drawPropertiesChanged:Boolean;

	final protected function invalidate_drawProperties():void {
		drawPropertiesChanged = true;
		invalidateProperties();
	}

	//---------------------------------------------
	// inavalidate dataProvider
	//---------------------------------------------
	private var dataProviderChanged:Boolean;

	final protected function invalidate_dataProvider():void {
		dataProviderChanged = true;
		invalidateProperties();
	}

	//---------------------------------------------
	// inavalidate dataItem
	//---------------------------------------------
	private var dataItemChanged:Boolean;

	final protected function invalidate_dataItem():void {
		dataItemChanged = true;
		invalidateProperties();
	}

	//==========================================================================================
	//
	//==========================================================================================
	override protected function commitProperties():void {
		super.commitProperties();

		if (dataProviderChanged || drawPropertiesChanged || dataItemChanged) {
			if (_animation && dataProviderChanged) {
				_animation.ready = ready;
				_animation.animate = animate;
				_animation.render = render;
				_animation.start();
			} else {
				ready();
				render();
			}

			dataProviderChanged = false;
			drawPropertiesChanged = false;
			dataItemChanged = false;
		}
	}

	private function ready():void {
		if (!_elements || _elements.length === 0) return;
		var f:int = _elements.length;
		while (--f >= 0) {
			_elements[f].ready();
		}
	}

	private function animate(t:Number):void {
		if (!_elements || _elements.length === 0) return;
		var f:int = _elements.length;
		while (--f >= 0) {
			_elements[f].animate(t);
		}
	}

	private function render():void {
		if (!_elements || _elements.length === 0) return;
		var f:int = _elements.length;
		while (--f >= 0) {
			_elements[f].render();
		}
	}

	override protected function canSkipMeasurement():Boolean {
		return true;
	}

	private function collectionChangeHandler(event:CollectionEvent):void {
		invalidate_dataItem();
	}

	public function dispose():void {
		if (!_elements || _elements.length === 0) return;
		var f:int = _elements.length;
		while (--f >= 0) {
			_elements[f].dispose();
		}
	}
}
}