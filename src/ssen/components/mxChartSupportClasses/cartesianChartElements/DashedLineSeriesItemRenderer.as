package ssen.components.mxChartSupportClasses.cartesianChartElements {
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.series.items.LineSeriesSegment;
import mx.collections.IList;
import mx.core.IDataRenderer;
import mx.core.UIComponent;
import mx.graphics.IStroke;

import ssen.drawing.GraphicsUtils;

public class DashedLineSeriesItemRenderer extends UIComponent implements IDataRenderer {
		//---------------------------------------------
		// dashedLineFunction
		//---------------------------------------------
		private var _dashedLineFunction:Function;

		/** dashedLineFunction */
		public function get dashedLineFunction():Function {
			return _dashedLineFunction;
		}

		public function set dashedLineFunction(value:Function):void {
			_dashedLineFunction=value;
			invalidateDisplayList();
		}

		//---------------------------------------------
		// strokeFunction
		//---------------------------------------------
		private var _strokeFunction:Function;

		/** strokeFunction */
		public function get strokeFunction():Function {
			return _strokeFunction;
		}

		public function set strokeFunction(value:Function):void {
			_strokeFunction=value;
			invalidateDisplayList();
		}

		//---------------------------------------------
		// data
		//---------------------------------------------
		private var _data:Object;

		/** data */
		public function get data():Object {
			return _data;
		}

		public function set data(value:Object):void {
			_data=value;
			invalidateDisplayList();
		}

		//==========================================================================================
		// draw
		//==========================================================================================
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			graphics.clear();

			var lineSeriesSegment:LineSeriesSegment=data as LineSeriesSegment;
			var form:String=getStyle("form") as String;

			if (!lineSeriesSegment || _dashedLineFunction == null) {
				return;
			}

			var dataProvider:IList=lineSeriesSegment.element.dataProvider as IList;

			if (!dataProvider || dataProvider.length === 0) {
				return;
			}

			var stroke:IStroke=getStyle("lineStroke") as IStroke;
			var data:Object;

			var f:int=-1;
			var fmax:int=dataProvider.length;

			var dash:Boolean;

			while (++f < fmax) {
				data=dataProvider.getItemAt(f);
				dash=_dashedLineFunction(data);


				if (f < fmax - 1) {
					if (_strokeFunction !== null) {
						stroke=_strokeFunction(data);
					}

					if (dash) {
						GraphicsUtils.drawDashedPolyLine(graphics, stroke, lineSeriesSegment.items.slice(f, f + 2));
					} else {
						GraphicsUtilities.drawPolyLine(graphics, lineSeriesSegment.items, f, f + 2, "x", "y", stroke, form);
					}
				}
			}
		}
	}
}
