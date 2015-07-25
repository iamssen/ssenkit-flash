package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import flash.events.Event;

import ssen.common.StringUtils;

/** Advanced Bubble Chart 에서 발생하는 Event */
public class AdvancedBubbleChartEvent extends Event {

	//==========================================================================================
	// events
	//==========================================================================================
	//	public static const BLANK_SELECTION:String="blankSelection";

	/** BubbleChart의 선택 항목들이 변경됨 */
	public static const SELECTED_DATA_CHANGED:String="selectedDataChanged";

	//==========================================================================================
	// parameters
	//==========================================================================================
	//	public var selectedData:IAdvancedBubbleData;
	/** 선택된 항목 데이터들 */
	public var selectedDatas:Array;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function AdvancedBubbleChartEvent(type:String) {
		super(type);
	}

	/** @private */
	override public function clone():Event {
		var clone:AdvancedBubbleChartEvent=new AdvancedBubbleChartEvent(type);
		//		clone.selectedData=selectedData;
		clone.selectedDatas=selectedDatas;
		return clone;
	}

	/** @private */
	override public function toString():String {
		//		return StringUtils.formatToString("[AdvancedBubbleChartEvent selectedData={0} selectedDatas={1}]", selectedData, selectedDatas);
		return StringUtils.formatToString("[AdvancedBubbleChartEvent selectedDatas={0}]", selectedDatas);
	}
}
}
