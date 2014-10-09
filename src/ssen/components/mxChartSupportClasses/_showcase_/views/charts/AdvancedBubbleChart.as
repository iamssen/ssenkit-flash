package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import mx.charts.BubbleChart;
import mx.charts.LinearAxis;
import mx.charts.chartClasses.DataTransform;
import mx.charts.chartClasses.Series;
import mx.collections.ICollectionView;
import mx.core.mx_internal;

use namespace mx_internal;

[Event(name="selectedDataChanged", type="ssen.showcase.views.charts.AdvancedBubbleChartEvent")]

/** Zoom, Selection 등의 기능이 추가된 Bubble Chart */
public class AdvancedBubbleChart extends BubbleChart {
	public function AdvancedBubbleChart() {

		// 최대, 최소 Bubble Radius 설정
		setStyle("minRadius", 3);
		setStyle("maxRadius", 14);
	}

	/** @private 하위 Element들이 사용 */
	internal function setSelectedDatas(datas:Array):void {
		var laxis:LinearAxis=radiusAxis as LinearAxis;

		var evt:AdvancedBubbleChartEvent=new AdvancedBubbleChartEvent(AdvancedBubbleChartEvent.SELECTED_DATA_CHANGED);
		evt.selectedDatas=datas;
		dispatchEvent(evt);
	}

	/** @private */
	override mx_internal function applyDataProvider(dp:ICollectionView, transform:DataTransform):void {
		if (dp.length === 0) {
			enabled=false;
		}

		var axes:Object=transform.axes;
		for (var p:String in axes) {
			axes[p].chartDataProvider=dp;
		}

		var elements:Array /* of ChartElement */=transform.elements;
		var n:int=elements.length;
		for (var i:int=0; i < n; i++) {
			// FIXME IAdvancedChartElement일 경우에도 dataProvider를 넣어주도록 처리
			if (elements[i] is Series || elements[i] is IAdvancedChartElement) {
				elements[i].chartDataProvider=dp;
			}
		}
		clearSelection();
	}
}
}
