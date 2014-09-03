//			<mx:AxisRenderer fontSize="12" axis="{haxis}">
//				<mx:labelRenderer>
//					<fx:Component>
//						<mx:Label>
//							<fx:Script>
//								<![CDATA[
//									import ssen.common.MathUtils;
//
//									override public function set data(value:Object):void {
//										text=value.text;
//										setStyle("color", MathUtils.rand(0x000000, 0xffffff));
//									}
//								]]>
//							</fx:Script>
//						</mx:Label>
//					</fx:Component>
//				</mx:labelRenderer>
//			</mx:AxisRenderer>

package ssen.components.mxChartSupportClasses.renderers {

	import spark.components.RichText;

	public class AxisLabelRenderer extends RichText {

	}
}