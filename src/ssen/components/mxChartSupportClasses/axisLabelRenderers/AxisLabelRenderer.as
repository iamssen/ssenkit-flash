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

package ssen.components.mxChartSupportClasses.axisLabelRenderers {

import mx.charts.AxisLabel;
import mx.core.IDataRenderer;
import mx.events.PropertyChangeEvent;

import ssen.text.HtmlRichText;

public class AxisLabelRenderer extends HtmlRichText implements IDataRenderer {
	//---------------------------------------------
	// data
	//---------------------------------------------
	private var _data:Object;

	/** data */
	[Bindable]
	public function get data():Object {
		return _data;
	}

	public function set data(value:Object):void {
		var oldValue:Object = _data;
		_data = value;

		if (value is AxisLabel) {
			var label:AxisLabel = value as AxisLabel;
			text = label.text;
		}

		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "data", oldValue, _data));
		}
	}
}
}