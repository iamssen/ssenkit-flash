package ssen.components.mxChartSupportClasses.cartesianChartElements {

import flash.display.Graphics;
import flash.geom.Rectangle;

import mx.charts.ChartItem;
import mx.charts.renderers.BoxItemRenderer;
import mx.graphics.IStroke;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.utils.ColorUtil;

public class CuttedBoxRenderer extends BoxItemRenderer {
	//	[Embed(source="assets/wave.png")]
	//	private static const WaveImage:Class;
	//
	//	private static var alphaBitmap:BitmapData;
	//	private static var colorBitmap:BitmapData;

	//---------------------------------------------
	// cuttedColor
	//---------------------------------------------
	private var _cuttedColor:uint = 0x393939;

	/** cuttedColor */
	public function get cuttedColor():uint {
		return _cuttedColor;
	}

	public function set cuttedColor(value:uint):void {
		_cuttedColor = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// cuttedField
	//---------------------------------------------
	private var _cuttedField:String;

	/** cuttedField */
	public function get cuttedField():String {
		return _cuttedField;
	}

	public function set cuttedField(value:String):void {
		_cuttedField = value;
		invalidateDisplayList();
	}

	//---------------------------------------------
	// inavalidate bitmap
	//---------------------------------------------
	//	private var bitmapChanged:Boolean = true;
	//
	//	final protected function invalidate_bitmap():void {
	//		bitmapChanged = true;
	//		invalidateDisplayList();
	//	}

	//	private var wave:BitmapData;
	//	private static var mat:Matrix = new Matrix;

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var chartItem:ChartItem = data as ChartItem;

		if (!_cuttedField || !chartItem || !chartItem.item || chartItem.item[_cuttedField] != true) {
			return;
		}

		//		if (!alphaBitmap) {
		//			alphaBitmap = new WaveImage().bitmapData;
		//			colorBitmap = new BitmapData(alphaBitmap.width, alphaBitmap.height, false, 0x000000);
		//		}

		//		if (bitmapChanged) {
		//			commit_bitmap();
		//			bitmapChanged = false;
		//		}

		//		if (!wave) {
		//			return;
		//		}
		//
		//		mat.identity();
		//		mat.ty = unscaledHeight - h2;

		var strokeColor:uint = 0xffffff;
		var stroke:IStroke = getStyle("stroke");

		if (stroke is Stroke) {
			strokeColor = ColorUtil.adjustBrightness2(Stroke(stroke).color, 30);
		} else if (stroke is SolidColorStroke) {
			strokeColor = ColorUtil.adjustBrightness2(SolidColorStroke(stroke).color, 30);
		}

		drawWave(strokeColor, _cuttedColor, graphics, new Rectangle(-6, unscaledHeight - 25, unscaledWidth + 12, 8));
	}

	//---------------------------------------------
	// commit bitmap
	//---------------------------------------------
	//	protected function commit_bitmap():void {
	//		if (wave) {
	//			wave.dispose();
	//			wave = null;
	//		}
	//
	//		var rect:Rectangle = new Rectangle(0, 0, alphaBitmap.width, alphaBitmap.height);
	//		var pt:Point = new Point(0, 0);
	//
	//		colorBitmap.fillRect(rect, _cuttedColor);
	//
	//		wave = new BitmapData(alphaBitmap.width, alphaBitmap.height, true, 0);
	//		wave.copyPixels(colorBitmap, rect, pt, alphaBitmap);
	//	}

	private static function drawWave(lineColor:uint, backColor:uint, g:Graphics, rect:Rectangle):void {
		const wave:int = 12;
		const rw4:Number = rect.width / 4;
		const x0:Number = rect.x;
		const x1:Number = rect.x + rw4;
		const x2:Number = rect.x + (rw4 * 2);
		const x3:Number = rect.x + (rw4 * 3);
		const x4:Number = rect.x + rect.width;
		const y0m:Number = rect.y;
		const y0b:Number = rect.y + wave;
		const y0t:Number = rect.y - wave;
		const y1m:Number = rect.y + rect.height;
		const y1b:Number = rect.y + rect.height + wave;
		const y1t:Number = rect.y + rect.height - wave;

		g.lineStyle();
		g.beginFill(backColor);
		g.moveTo(x0, y0m);
		g.curveTo(x1, y0b, x2, y0m);
		g.curveTo(x3, y0t, x4, y0m);
		g.lineTo(x4, y1m);
		g.curveTo(x3, y1t, x2, y1m);
		g.curveTo(x1, y1b, x0, y1m);
		g.lineTo(x0, y0m);
		g.endFill();

		g.lineStyle(2, lineColor);
		g.moveTo(x0, y0m);
		g.curveTo(x1, y0b, x2, y0m);
		g.curveTo(x3, y0t, x4, y0m);
		g.moveTo(x4, y1m);
		g.curveTo(x3, y1t, x2, y1m);
		g.curveTo(x1, y1b, x0, y1m);
	}
}
}