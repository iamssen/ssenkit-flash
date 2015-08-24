package ssen.components.chart.pola.pieAxis {
import com.greensock.easing.Quad;

import flash.display.Graphics;
import flash.events.EventDispatcher;

import flashx.textLayout.factory.TruncationOptions;
import flashx.textLayout.formats.ITextLayoutFormat;
import flashx.textLayout.formats.TextLayoutFormat;

import mx.collections.IList;
import mx.core.UIComponent;

import ssen.common.DisposableUtils;
import ssen.common.MathUtils;
import ssen.common.NullUtils;
import ssen.components.animate.AnimationTrack;
import ssen.components.chart.pola.IPolaAxis;
import ssen.components.chart.pola.PolaChart;
import ssen.text.IFormattedTextComponent;
import ssen.text.LabelComponentUtils;
import ssen.text.SpriteHtmlLines;
[Deprecated(message="Remove when end of project")]
public class PieLabels extends EventDispatcher implements IPieElement, IFormattedTextComponent {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// chart field
	//----------------------------------------------------------------
	public var dataField:String;
	public var axis:IPolaAxis;

	//----------------------------------------------------------------
	// style
	//----------------------------------------------------------------
	public var radiusRatio:Number = 1;
	/** labelFunction = `(data:Object, dataField:String, pie:PieSeriesWedge) => String` */
	public var labelFunction:Function;
	/** additionalRadiusFunction = `(data:Object, dataField:String, pie:PieSeriesWedge) => Number` */
	public var additionalRadiusFunction:Function;

	//----------------------------------------------------------------
	// animate
	//----------------------------------------------------------------
	public var animationTrack:AnimationTrack = new AnimationTrack(0, 1, Quad.easeOut);
	private var lastAnimationRatio:Number;

	//==========================================================================================
	// compute
	//==========================================================================================
	public function computeMaximumValue(dataProvider:IList):Number {
		return NaN;
	}

	//==========================================================================================
	// render
	//==========================================================================================
	private var display:UIComponent;

	public function PieLabels() {
		display = new UIComponent;
		display.mouseChildren = false;
		display.mouseEnabled = false;
		display.mouseFocusEnabled = false;
		display.tabChildren = false;
		display.tabEnabled = false;
		display.tabFocusEnabled = false;
	}

	public function render(axis:PieAxis, chart:PolaChart, targetContainer:UIComponent, animationRatio:Number):void {
		//----------------------------------------------------------------
		// time tracking
		//----------------------------------------------------------------
		animationRatio = animationTrack.getTime(animationRatio);

		if (isNaN(animationRatio)) {
			display.alpha = 0;
			return;
		} else if (animationRatio === lastAnimationRatio) {
			return;
		}

		lastAnimationRatio = animationRatio;

		//----------------------------------------------------------------
		// init display
		//----------------------------------------------------------------
		targetContainer.addChild(display);
		DisposableUtils.disposeDisplayContainer(display);

		var g:Graphics = display.graphics;

		if (!axis || !axis.dataProvider) return;

		//----------------------------------------------------------------
		// compute
		//----------------------------------------------------------------
		var pies:Pies = compute(axis);

		//----------------------------------------------------------------
		// coordinate info
		//----------------------------------------------------------------
		var radiusRatio:Number = this.radiusRatio;
		var radius:Number = chart.computedContentRadius * axis.drawRadiusRatio * radiusRatio;

		//----------------------------------------------------------------
		// draw
		//----------------------------------------------------------------
		display.alpha = animationRatio;

		g.clear();

		var f:int = -1;
		var fmax:int = pies.list.length;
		var pie:PieSeriesWedge;
		var px:Number;
		var py:Number;
		var animate:Number;
		var lines:SpriteHtmlLines;
		var additionalRadius:Number = 0;

		while (++f < fmax) {
			// pie
			pie = pies.list[f];

			// set label component
			lines = new SpriteHtmlLines;
			lines.text = LabelComponentUtils.getLabel(pie.row, dataField, null, labelFunction, pie);
			lines.format = LabelComponentUtils.getTextLayoutFormat(this, pie);
			lines.truncationOptions = truncationOptions;
			lines.textAlign = textAlign;

			lines.createTextLines();
			display.addChild(lines);

			// animate
			animate = ((1 - (f / fmax)) * animationRatio) + animationRatio;
			animate = Math.min(1, animate);

			// additional radius
			if (additionalRadiusFunction !== null) {
				additionalRadius = additionalRadiusFunction(pie.row, dataField, pie);
				if (additionalRadius !== 0) additionalRadius = additionalRadius * animationRatio;
			}

			// set label component position
			px = chart.computedCenterX + ((radius + additionalRadius) * Math.cos(MathUtils.deg2rad(pie.labelDeg)));
			py = chart.computedCenterY + ((radius + additionalRadius) * Math.sin(MathUtils.deg2rad(pie.labelDeg)));

			lines.alpha = animate;
			lines.scaleX = animate;
			lines.scaleY = animate;
			lines.x = px + ((lines.width * animate) / -2);
			lines.y = py + ((lines.height * animate) / -2);
		}

	}

	private function compute(axis:PieAxis):Pies {
		var pies:Pies = new Pies;
		var pie:PieSeriesWedge;

		var f:int = -1;
		var fmax:int = axis.dataProvider.length;

		var source:Object;
		var value:Number;

		while (++f < fmax) {
			source = axis.dataProvider.getItemAt(f);
			value = NullUtils.nanTo(source[dataField], 0);

			if (value > 0) {
				pie = new PieSeriesWedge;
				pie.row = source;
				pie.value = value;

				pies.list.push(pie);
				pies.total += value;
			}
		}

		var startDeg:Number = MathUtils.rotate(axis.drawStartAngle);
		var endDeg:Number = MathUtils.rotate(axis.drawEndAngle);
		if (startDeg > endDeg) {
			var cacheDeg:Number = endDeg;
			endDeg = startDeg;
			startDeg = cacheDeg;
		}
		var totalDeg:Number = endDeg - startDeg;

		var nextRatio:Number = 0;
		var nextDeg:Number = startDeg;

		f = -1;
		fmax = pies.list.length;
		while (++f < fmax) {
			pie = pies.list[f];
			pie.ratioValue = pie.value / pies.total;

			pie.startRatio = nextRatio;
			nextRatio += pie.ratioValue;
			pie.endRatio = nextRatio;

			pie.startDeg = MathUtils.rotate(nextDeg, -90);
			pie.labelDeg = MathUtils.rotate(nextDeg + ((pie.ratioValue * totalDeg) / 2), -90);
			nextDeg += pie.ratioValue * totalDeg;
			pie.endDeg = MathUtils.rotate(nextDeg, -90);
		}

		return pies;
	}


	//==========================================================================================
	// implements IFormattedTextComponent
	//==========================================================================================
	//----------------------------------------------------------------
	// style
	//----------------------------------------------------------------
	private var format:TextLayoutFormat = new TextLayoutFormat;

	//---------------------------------------------
	// textAlign
	//---------------------------------------------
	private var _textAlign:String = "center";

	/** textAlign */
	public function get textAlign():String {
		return _textAlign;
	}

	[Inspectable(type="Array", enumeration="center,left,right", defaultValue="left")]
	public function set textAlign(value:String):void {
		_textAlign = value;
		format.textAlign = value;
	}

	//---------------------------------------------
	// fontLookup
	//---------------------------------------------
	/** fontLookup */
	public function get fontLookup():String {
		return format.fontLookup;
	}

	[Inspectable(type="Array", enumeration="auto,device,embeddedCFF", defaultValue="device")]
	public function set fontLookup(value:String):void {
		format.fontLookup = value;
	}

	//---------------------------------------------
	// color
	//---------------------------------------------
	/** color */
	public function get color():uint {
		return format.color;
	}

	public function set color(value:uint):void {
		format.color = value;
	}

	//---------------------------------------------
	// fontFamily
	//---------------------------------------------
	/** fontFamily */
	public function get fontFamily():String {
		return format.fontFamily;
	}

	public function set fontFamily(value:String):void {
		format.fontFamily = value;
	}

	//---------------------------------------------
	// fontSize
	//---------------------------------------------
	/** fontSize */
	public function get fontSize():uint {
		return format.fontSize;
	}

	public function set fontSize(value:uint):void {
		format.fontSize = value;
	}

	//---------------------------------------------
	// fontWeight
	//---------------------------------------------
	/** fontWeight */
	public function get fontWeight():String {
		return format.fontWeight;
	}

	[Inspectable(type="Array", enumeration="normal,bold", defaultValue="normal")]
	public function set fontWeight(value:String):void {
		format.fontWeight = value;
	}

	//---------------------------------------------
	// lineHeight
	//---------------------------------------------
	/** lineHeight */
	public function get lineHeight():Object {
		return format.lineHeight;
	}

	public function set lineHeight(value:Object):void {
		format.lineHeight = value;
	}

	//---------------------------------------------
	// trackingLeft
	//---------------------------------------------
	/** trackingLeft */
	public function get trackingLeft():Object {
		return format.trackingLeft;
	}

	public function set trackingLeft(value:Object):void {
		format.trackingLeft = value;
	}

	//---------------------------------------------
	// trackingRight
	//---------------------------------------------
	/** trackingRight */
	public function get trackingRight():Object {
		return format.trackingRight;
	}

	public function set trackingRight(value:Object):void {
		format.trackingRight = value;
	}

	//---------------------------------------------
	// truncationOptions
	//---------------------------------------------
	private var _truncationOptions:TruncationOptions;

	/** truncationOptions */
	public function get truncationOptions():TruncationOptions {
		return _truncationOptions;
	}

	public function set truncationOptions(value:TruncationOptions):void {
		_truncationOptions = value;
	}

	//---------------------------------------------
	// textFormatFunction
	//---------------------------------------------
	private var _textFormatFunction:Function;

	/** textFormatFunction = (component:PieLabels, format:TextLayoutFormat, pie:PieSeriesWedge) => TextLayoutFormat*/
	public function get textFormatFunction():Function {
		return _textFormatFunction;
	}

	public function set textFormatFunction(value:Function):void {
		_textFormatFunction = value;
	}

	public function getFormat():ITextLayoutFormat {
		return format;
	}

	public function setFormat(newFormat:ITextLayoutFormat):void {
		format = new TextLayoutFormat(newFormat);
	}
}
}

import ssen.components.chart.pola.pieAxis.PieSeriesWedge;

class Pies {
	public var list:Vector.<PieSeriesWedge> = new Vector.<PieSeriesWedge>;
	public var total:Number = 0;
}