package ssen.components.mxChartSupportClasses._showcase_ {
import ssen.components.mxChartSupportClasses._showcase_.viewmodels.ChartViewModel;
import ssen.components.mxChartSupportClasses._showcase_.views.LeftChart;
import ssen.reflow.context.Context;

public class AdvancedBubbleChartExampleContext extends Context {
	override protected function mapDependency():void {
		injector.mapSingleton(ChartViewModel);

		viewMap.map(LeftChart);
	}

	override protected function shutdown():void {
	}

	override protected function startup():void {
	}
}
}
