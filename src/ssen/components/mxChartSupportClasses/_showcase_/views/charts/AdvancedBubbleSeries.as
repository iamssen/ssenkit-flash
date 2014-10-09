package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import mx.charts.series.BubbleSeries;
import mx.collections.IList;
import mx.core.ClassFactory;
import mx.events.PropertyChangeEvent;

/** Advanced Bubble Chart 를 위한 추가 기능을 처리하는 Bubble Series */
public class AdvancedBubbleSeries extends BubbleSeries {

	public function AdvancedBubbleSeries() {
		setStyle("itemRenderer", new ClassFactory(AdvancedBubbleRenderer));
	}

	//---------------------------------------------
	// xBase
	//---------------------------------------------
	private var _xBase:Number;

	/** X축 기준선 처리를 위한 값 */
	[Bindable]
	public function get xBase():Number {
		return _xBase;
	}

	public function set xBase(value:Number):void {
		var oldValue:Number=_xBase;
		_xBase=value;

		invalidateDisplayList();

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "xBase", oldValue, _xBase));
		}
	}

	//---------------------------------------------
	// yBase
	//---------------------------------------------
	private var _yBase:Number;

	/** Y축 기준선 처리를 위한 값 */
	[Bindable]
	public function get yBase():Number {
		return _yBase;
	}

	public function set yBase(value:Number):void {
		var oldValue:Number=_yBase;
		_yBase=value;

		invalidateDisplayList();

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "yBase", oldValue, _yBase));
		}
	}

	/**
	 * 분면 기준으로 내부의 Bubble 들을 선택 처리한다
	 *
	 * @param topLeft 좌상단 분면의 아이템들을 선택 처리
	 * @param topRight 우상단 분면의 아이템들을 선택 처리
	 * @param bottomLeft 좌하단 분면의 아이템들을 선택 처리
	 * @param bottomRight 우하단 분면의 아이템들을 선택 처리
	 */
	public function selectDimension(topLeft:Boolean, topRight:Boolean, bottomLeft:Boolean, bottomRight:Boolean):Array {
		if (!chart.dataProvider || chart.dataProvider.length === 0) {
			return null;
		}

		var datas:IList=chart.dataProvider as IList;
		var data:IAdvancedBubbleData;

		var result:Array=[];

		var top:Boolean;
		var right:Boolean;

		var f:int=-1;
		var fmax:int=datas.length;

		var r:Boolean;

		while (++f < fmax) {
			data=datas.getItemAt(f) as IAdvancedBubbleData;

			top=!isNaN(_yBase) && data[yField] > _yBase;
			right=!isNaN(_xBase) && data[xField] > _xBase;

			r=false;

			if (topLeft && top && !right) {
				r=true;
			}

			if (topRight && top && right) {
				r=true;
			}

			if (bottomLeft && !top && !right) {
				r=true;
			}

			if (bottomRight && !top && right) {
				r=true;
			}

			data.selected=r;

			if (r) {
				result.push(data);
			}
		}

		return result;
	}
}
}
