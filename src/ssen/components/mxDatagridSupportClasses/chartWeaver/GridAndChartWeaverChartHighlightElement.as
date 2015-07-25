package ssen.components.mxDatagridSupportClasses.chartWeaver {
import flash.display.Graphics;

import mx.charts.chartClasses.ChartElement;

import mx.core.UIComponent;

public class GridAndChartWeaverChartHighlightElement extends ChartElement {
	//---------------------------------------------
	// highlighted
	//---------------------------------------------
	private var _highlighted:Boolean;

	/** highlighted */
	public function get highlighted():Boolean {
		return _highlighted;
	}

	public function set highlighted(value:Boolean):void {
		_highlighted=value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// highlightStartX
	//---------------------------------------------
	private var _highlightStartX:Number;

	/** highlightStartX */
	public function get highlightStartX():Number {
		return _highlightStartX;
	}

	public function set highlightStartX(value:Number):void {
		_highlightStartX=value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// highlightEndX
	//---------------------------------------------
	private var _highlightEndX:Number;

	/** highlightEndX */
	public function get highlightEndX():Number {
		return _highlightEndX;
	}

	public function set highlightEndX(value:Number):void {
		_highlightEndX=value;
		invalidateDisplayList();
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var g:Graphics=graphics;

		g.clear();

		if (!_highlighted) {
			return;
		}

		g.beginFill(0xff0000, 0.3);
		g.drawRect(_highlightStartX, 0, _highlightEndX - _highlightStartX, unscaledHeight);
		g.endFill();
	}

}
}
