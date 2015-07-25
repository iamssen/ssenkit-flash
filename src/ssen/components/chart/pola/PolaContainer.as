package ssen.components.chart.pola {
import flash.display.Graphics;

import mx.core.IVisualElement;
import mx.core.mx_internal;

import spark.components.SkinnableContainer;

use namespace mx_internal;

[SkinState("noContent")]

/*
IPolaElements, HolderElements 들의 상태에 따른 Display 초기화를 시켜준다
set axis() --> IPolaElement.chart = this
commitProperties() --> IPolaElement.initDisplayList()
	- IPolaElement 자체적으로 상위의 PolaChart를 비교해서 하위 Display 요소들을 초기화 한다

모든 Size 계산은 PolaChart 에서 계산해서 내려주게 된다
updateDisplayList() --> IPolaElement.resizeDisplayList(computedCenterX, computedCenterY, computedRadius)
*/
public class PolaContainer extends SkinnableContainer {
	//----------------------------------------------------------------
	// size and drawable datas
	//----------------------------------------------------------------
	//---------------------------------------------
	// gutterLeft
	//---------------------------------------------
	private var _gutterLeft:int;

	/** gutterLeft */
	public function get gutterLeft():int {
		return _gutterLeft;
	}

	public function set gutterLeft(value:int):void {
		_gutterLeft = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// gutterRight
	//---------------------------------------------
	private var _gutterRight:int;

	/** gutterRight */
	public function get gutterRight():int {
		return _gutterRight;
	}

	public function set gutterRight(value:int):void {
		_gutterRight = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// gutterTop
	//---------------------------------------------
	private var _gutterTop:int;

	/** gutterTop */
	public function get gutterTop():int {
		return _gutterTop;
	}

	public function set gutterTop(value:int):void {
		_gutterTop = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// gutterBottom
	//---------------------------------------------
	private var _gutterBottom:int;

	/** gutterBottom */
	public function get gutterBottom():int {
		return _gutterBottom;
	}

	public function set gutterBottom(value:int):void {
		_gutterBottom = value;
		invalidateDisplayList();
	}

	//----------------------------------------------------------------
	// generated properties (in commit properties)
	//----------------------------------------------------------------
	//---------------------------------------------
	// computedCenterX
	//---------------------------------------------
	private var _computedCenterX:Number;

	/** computedCenterX */
	public function get computedCenterX():Number {
		return _computedCenterX;
	}

	//---------------------------------------------
	// computedCenterY
	//---------------------------------------------
	private var _computedCenterY:Number;

	/** computedCenterY */
	public function get computedCenterY():Number {
		return _computedCenterY;
	}

	//---------------------------------------------
	// computedContentRadius
	//---------------------------------------------
	private var _computedContentRadius:Number;

	/** computedContentRadius */
	public function get computedContentRadius():Number {
		return _computedContentRadius;
	}

	/** @private this components need requrie width, height explicit or layout size */
	override protected function canSkipMeasurement():Boolean {
		return true;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (!numElements === 0
				|| !unscaledWidth
				|| !unscaledHeight) return;

		var oldComputedCenterX:Number = _computedCenterX;
		var oldComputedCenterY:Number = _computedCenterY;
		var oldComputedContentRadius:Number = _computedContentRadius;

		var halfWidth:int = (unscaledWidth - _gutterLeft - _gutterRight) / 2;
		var halfHeight:int = (unscaledHeight - _gutterTop - _gutterBottom) / 2;
		var centerX:int = halfWidth + _gutterLeft;
		var centerY:int = halfHeight + _gutterTop;
		var contentRadius:int = (halfWidth < halfHeight) ? halfWidth : halfHeight;

		if (oldComputedCenterX !== centerX || oldComputedCenterY !== centerY || oldComputedContentRadius !== contentRadius) {
			_computedCenterX = centerX;
			_computedCenterY = centerY;
			_computedContentRadius = contentRadius;

			var f:int = numElements;
			var element:IVisualElement;
			while (--f >= 0) {
				element = getElementAt(f);
				if (element is IPolaElement2) {
					IPolaElement2(element).resizeDisplayList(_computedCenterX, _computedCenterY, _computedContentRadius);
				}
			}
		}

		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0, 0.01);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();
	}

	public function PolaContainer() {
		width = 200;
		height = 200;
	}
}
}
