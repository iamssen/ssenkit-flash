package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import flash.events.IEventDispatcher;

[Event(name="bubblePropertyChange", type="ssen.showcase.views.charts.AdvancedBubbleDataPropertyChangeEvent")]

/** 
 * AdvancedBubbleChart에 사용될 데이터들은 모두 이 Interface를 구현해야 한다
 * Chart 자체적인 Selection 기능은 minimum, maximum에 의해서 의도치 않은 선택 해제가 되기 때문에
 * 안정적인 작동을 위해서 Chart 자체의 Selection 기능을 포기하고 Data Level 에서 선택 여부를 구현 
 */
public interface IAdvancedBubbleData extends IEventDispatcher {
	/** Selection 여부 */
	function get selected():Boolean;
	function set selected(value:Boolean):void;
}
}
