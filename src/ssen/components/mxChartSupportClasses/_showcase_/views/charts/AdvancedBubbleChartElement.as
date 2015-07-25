package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import mx.charts.LinearAxis;
import mx.charts.chartClasses.ChartElement;
import mx.collections.ICollectionView;
import mx.collections.ListCollectionView;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;

/** Bubble Chart의 확장 Element를 작성하기 위한 추상 Base Class */
public class AdvancedBubbleChartElement extends ChartElement implements IAdvancedChartElement {
	protected var _computeDataProvider:Boolean;
	private var _chartDataProvider:ListCollectionView;

	//==========================================================================================
	// properties
	//==========================================================================================
	public function get bubbleChart():AdvancedBubbleChart {
		return chart as AdvancedBubbleChart;
	}

	//==========================================================================================
	// override
	//==========================================================================================
	/** @private chartDataProvider가 입력되는 시점에 밑단 작업을 한다 */
	override public function set chartDataProvider(value:Object):void {
		if (_chartDataProvider == value) {
			return;
		}

		var dp:ICollectionView=value as ListCollectionView;

		if (_chartDataProvider && _chartDataProvider.hasEventListener(CollectionEvent.COLLECTION_CHANGE)) {
			_chartDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChanged);
		}

		super.chartDataProvider=value;
		_chartDataProvider=value as ListCollectionView;

		if (_chartDataProvider) {
			_chartDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChanged, false, 0, true);
		}

		_computeDataProvider=true;
		invalidateProperties();
	}

	/** @private */
	override protected function commitProperties():void {
		super.commitProperties();

		if (_computeDataProvider) {
			if (!bubbleChart || !bubbleChart.series || bubbleChart.series.length === 0 || !_chartDataProvider) {
				callLater(invalidateProperties);
			} else {
				computeDataProvider();
				_computeDataProvider=false;
			}
		}
	}

	//==========================================================================================
	// event handler
	//==========================================================================================
	private function collectionChanged(event:CollectionEvent):void {
		if (event.kind === CollectionEventKind.REPLACE) {
			_computeDataProvider=true;
			invalidateProperties();
		}
	}

	//==========================================================================================
	// protected
	//==========================================================================================
	/** Bubble Chart의 Data Provider 를 가져온다 */
	protected function getChartDataProvider():ListCollectionView {
		return _chartDataProvider;
	}

	//==========================================================================================
	// abstract
	//==========================================================================================
	/** [Abstract] Data Provider의 데이터 구성 변경 시에 처리할 작업들을 작성한다 */
	protected function computeDataProvider():void {
	}

	//==========================================================================================
	// utils
	//==========================================================================================
	/** 시각적 Y좌표에 해당하는 값을 가져온다 */
	protected function getVerticalValue(y:Number):Number {
		var vaxis:LinearAxis=getVerticalAxis();
		return vaxis.maximum - ((vaxis.maximum - vaxis.minimum) * (y / unscaledHeight));
	}

	/** 시각적 X좌표에 해당하는 값을 가져온다 */
	protected function getHorizontalValue(x:Number):Number {
		var haxis:LinearAxis=getHorizontalAxis();
		return ((haxis.maximum - haxis.minimum) * (x / unscaledWidth)) + haxis.minimum;
	}

	/** Bubble Chart의 가로Axis를 가져온다 */
	protected function getHorizontalAxis():LinearAxis {
		return bubbleChart.horizontalAxis as LinearAxis;
	}

	/** Bubble Chart의 세로Axis를 가져온다 */
	protected function getVerticalAxis():LinearAxis {
		return bubbleChart.verticalAxis as LinearAxis;
	}

	/** 논리적 가로축 값에 해당하는 X 위치를 가져온다 */ 
	protected function getHorizontalPosition(h:Number):Number {
		var haxis:LinearAxis=getHorizontalAxis();
		return ((h - haxis.minimum) / (haxis.maximum - haxis.minimum)) * unscaledWidth;
	}

	/** 논리적 세로축 값에 해당하는 Y 위치를 가져온다 */
	protected function getVerticalPosition(v:Number):Number {
		var vaxis:LinearAxis=getVerticalAxis();
		return unscaledHeight - (((v - vaxis.minimum) / (vaxis.maximum - vaxis.minimum)) * unscaledHeight);
	}


}
}
