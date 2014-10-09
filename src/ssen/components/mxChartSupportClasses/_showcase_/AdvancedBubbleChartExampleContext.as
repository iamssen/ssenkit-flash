package ssen.components.mxChartSupportClasses._showcase_ {
import ssen.reflow.context.Context;
import ssen.showcase.viewmodels.ChartViewModel;
import ssen.showcase.views.LeftChart;

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
