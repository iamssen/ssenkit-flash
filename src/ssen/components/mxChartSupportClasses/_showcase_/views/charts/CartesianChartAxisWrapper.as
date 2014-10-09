package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import spark.components.SkinnableContainer;

/** Cartesian Chart 외부에 Axis Label 처리를 하기 위한 Container 형태의 Label */
public class CartesianChartAxisWrapper extends SkinnableContainer {
	/** 가로축 라벨 텍스트 */
	[Bindable]
	public var horizontalAxisLabel:String;

	/** 세로축 라벨 텍스트 */
	[Bindable]
	public var verticalAxisLabel:String;

	public function CartesianChartAxisWrapper() {
		setStyle("skinClass", CartesianChartAxisWrapperSkin);
	}
}
}
