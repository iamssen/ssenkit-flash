package ssen.components.chart.pola.pieAxis {
import flash.display.Graphics;
import flash.display.GraphicsPath;

import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.core.UIComponent;
import mx.graphics.IFill;

import ssen.drawing.PathMaker;

public class PieSeriesWedgeRenderer extends UIComponent implements IPieSeriesWedgeRenderer {
	internal static var factory:IFactory = new ClassFactory(PieSeriesWedgeRenderer);

	//----------------------------------------------------------------
	// current state
	//----------------------------------------------------------------
	//---------------------------------------------
	// lineWeight
	//---------------------------------------------
	private var _lineWeight:Number = 4;

	/** lineWeight */
	public function get lineWeight():Number {
		return _lineWeight;
	}

	public function set lineWeight(value:Number):void {
		_lineWeight = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// lineColor
	//---------------------------------------------
	private var _lineColor:uint = 0xffffff;

	/** lineColor */
	public function get lineColor():uint {
		return _lineColor;
	}

	public function set lineColor(value:uint):void {
		_lineColor = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// lineAlpha
	//---------------------------------------------
	private var _lineAlpha:Number = 1;

	/** lineAlpha */
	public function get lineAlpha():Number {
		return _lineAlpha;
	}

	public function set lineAlpha(value:Number):void {
		_lineAlpha = value;
		invalidateDisplayList();
	}

	//----------------------------------------------------------------
	// implements IPieSeriesWedgeRenderer
	//----------------------------------------------------------------
	//---------------------------------------------
	// outerRadius
	//---------------------------------------------
	private var _outerRadius:Number;

	/** outerRadius */
	public function get outerRadius():Number {
		return _outerRadius;
	}

	public function set outerRadius(value:Number):void {
		_outerRadius = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// innerRadius
	//---------------------------------------------
	private var _innerRadius:Number;

	/** innerRadius */
	public function get innerRadius():Number {
		return _innerRadius;
	}

	public function set innerRadius(value:Number):void {
		_innerRadius = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// pie
	//---------------------------------------------
	private var _pie:PieSeriesWedge;

	/** pie */
	public function get pie():PieSeriesWedge {
		return _pie;
	}

	public function set pie(value:PieSeriesWedge):void {
		_pie = value;
		invalidateDisplayList();
		//		setToolTip();
	}

	//	//---------------------------------------------
	//	// toolTipFunction
	//	//---------------------------------------------
	//	private var _toolTipFunction:Function;
	//
	//	/** toolTipFunction */
	//	public function get toolTipFunction():Function {
	//		return _toolTipFunction;
	//	}
	//
	//	public function set toolTipFunction(value:Function):void {
	//		_toolTipFunction = value;
	//		setToolTip();
	//	}

	//---------------------------------------------
	// fill
	//---------------------------------------------
	private var _fill:IFill;

	/** fill */
	public function get fill():IFill {
		return _fill;
	}

	public function set fill(value:IFill):void {
		_fill = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// order
	//---------------------------------------------
	private var _order:Number;

	/** order */
	public function get order():Number {
		return _order;
	}

	public function set order(value:Number):void {
		_order = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// animate
	//---------------------------------------------
	private var _animate:Number;

	/** animate */
	public function get animate():Number {
		return _animate;
	}

	public function set animate(value:Number):void {
		_animate = value;
		invalidateDisplayList();
	}

	//	//---------------------------------------------
	//	// showDataTip
	//	//---------------------------------------------
	//	private var _showDataTip:Boolean;
	//
	//	/** showDataTip */
	//	public function get showDataTip():Boolean {
	//		return _showDataTip;
	//	}
	//
	//	public function set showDataTip(value:Boolean):void {
	//		_showDataTip = value;
	//		setToolTip();
	//	}

	//	private function setToolTip():void {
	//		var useToolTip:Boolean = _showDataTip && _toolTipFunction !== null && _pie;
	//
	//		if (useToolTip) {
	//			toolTip = _toolTipFunction(_pie);
	//		} else {
	//			toolTip = null;
	//		}
	//	}
	//
	//	override public function set toolTip(value:String):void {
	//		super.toolTip = value;
	//
	//		if (value) {
	//			addEventListener(ToolTipEvent.TOOL_TIP_CREATE, toolTipCreateHandler);
	//		} else if (hasEventListener(ToolTipEvent.TOOL_TIP_CREATE)) {
	//			removeEventListener(ToolTipEvent.TOOL_TIP_CREATE, toolTipCreateHandler);
	//		}
	//	}
	//
	//	private function toolTipCreateHandler(event:ToolTipEvent):void {
	//		if (_fill is SolidColor) {
	//			var fill:SolidColor = _fill as SolidColor;
	//			HtmlToolTip.create(fill.color, event.target, event);
	//		}
	//	}

	//----------------------------------------------------------------
	// render
	//----------------------------------------------------------------
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		//---------------------------------------------
		// calculate
		//---------------------------------------------
		if (isNaN(_order) || isNaN(_animate) || !_pie) return;

		var lineWeight:Number = _lineWeight;
		var lineColor:uint = _lineColor;
		var lineAlpha:Number = _lineAlpha;
		var order:Number = _order;
		var animate:Number = _animate;
		var outerRadius:Number = _outerRadius;
		var innerRadius:Number = _innerRadius;
		var pie:PieSeriesWedge = _pie;

		animate = ((1 - order) * animate) + animate;
		animate = Math.min(1, animate);

		outerRadius = outerRadius * animate;
		innerRadius = innerRadius + (outerRadius * (1 - animate));

		alpha = animate;

		//---------------------------------------------
		// draw wedge
		//---------------------------------------------
		var path:GraphicsPath = PathMaker.donut(0, 0, outerRadius, innerRadius, pie.startDeg, pie.endDeg);
		var graphics:Graphics = graphics;

		graphics.clear();

		if (lineWeight > 0) graphics.lineStyle(lineWeight, lineColor, lineAlpha);

		fill.begin(graphics, null, null);
		graphics.drawPath(path.commands, path.data, path.winding);
		fill.end(graphics);

		if (lineWeight > 0) graphics.lineStyle();
	}
}
}
