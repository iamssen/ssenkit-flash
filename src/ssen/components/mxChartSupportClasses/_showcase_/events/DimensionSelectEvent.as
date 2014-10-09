package ssen.components.mxChartSupportClasses._showcase_.events {
import flash.events.Event;

/**
 * 분면 선택 이벤트
 *
 * @see ssen.showcase.views.charts.ChartUtilButtons
 */
public class DimensionSelectEvent extends Event {
	//==========================================================================================
	// events
	//==========================================================================================
	/** 분면이 선택 되었음을 알린다 */
	public static const SELECT_DIMENSION:String="selectDimension";

	//==========================================================================================
	// parameters
	//==========================================================================================
	/** 좌상단 선택 여부 */
	public var topLeft:Boolean;

	/** 우상단 선택 여부 */
	public var topRight:Boolean;

	/** 좌하단 선택 여부 */
	public var bottomLeft:Boolean;

	/** 우하단 선택 여부 */
	public var bottomRight:Boolean;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function DimensionSelectEvent(topLeft:Boolean, topRight:Boolean, bottomLeft:Boolean, bottomRight:Boolean) {
		super(SELECT_DIMENSION);

		this.topLeft=topLeft;
		this.topRight=topRight;
		this.bottomLeft=bottomLeft;
		this.bottomRight=bottomRight;
	}

	override public function clone():Event {
		return new DimensionSelectEvent(topLeft, topRight, bottomLeft, bottomRight);
	}
}
}
