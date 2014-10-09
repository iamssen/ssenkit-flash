package ssen.components.mxChartSupportClasses._showcase_.views.charts {
import mx.charts.chartClasses.ChartElement;
import mx.events.PropertyChangeEvent;

import spark.components.Label;

import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.VerticalAlign;

/** Chart 내부에 Axis Label 을 처리하기 위해 만든 Element (현재 사용 안함) */
public class AdvancedChartAxisLabel extends ChartElement {
	private var yLabelChanged:Boolean;
	private var xLabelChanged:Boolean;
	private var yLabelComponent:Label;
	private var xLabelComponent:Label;

	//---------------------------------------------
	// yLabel
	//---------------------------------------------
	private var _yLabel:String;

	/** yLabel */
	[Bindable]
	public function get yLabel():String {
		return _yLabel;
	}

	public function set yLabel(value:String):void {
		var oldValue:String=_yLabel;
		_yLabel=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "yLabel", oldValue, _yLabel));
		}

		yLabelChanged=true;
		invalidateProperties();
	}

	//---------------------------------------------
	// xLabel
	//---------------------------------------------
	private var _xLabel:String;

	/** xLabel */
	[Bindable]
	public function get xLabel():String {
		return _xLabel;
	}

	public function set xLabel(value:String):void {
		var oldValue:String=_xLabel;
		_xLabel=value;
		if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "xLabel", oldValue, _xLabel));
		}

		xLabelChanged=true;
		invalidateProperties();
	}


	//==========================================================================================
	// constructor
	//==========================================================================================
	public function AdvancedChartAxisLabel() {
		xLabelComponent=getLabelComponent();
		xLabelComponent.setStyle("textAlign", TextAlign.RIGHT);
		xLabelComponent.setStyle("verticalAlign", VerticalAlign.BOTTOM);
		addChild(xLabelComponent);

		yLabelComponent=getLabelComponent();
		yLabelComponent.setStyle("textAlign", TextAlign.LEFT);
		yLabelComponent.setStyle("verticalAlign", VerticalAlign.TOP);
		addChild(yLabelComponent);

		mouseChildren=false;
		mouseEnabled=false;
		mouseFocusEnabled=false;
		tabChildren=false;
		tabEnabled=false;
		tabFocusEnabled=false;
	}

	private function getLabelComponent():Label {
		var label:Label=new Label;
		label.maxDisplayedLines=1;
		label.setStyle("fontFamily", "mainfont");
		label.setStyle("fontSize", 13);
		label.setStyle("color", 0xcccccc);
		label.width=300;
		label.height=200;
		return label;
	}

	/** @private */
	override protected function commitProperties():void {
		super.commitProperties();

		if (yLabelChanged) {
			yLabelComponent.text=yLabel;
			yLabelComponent.invalidateDisplayList();
			yLabelChanged=false;
			invalidateDisplayList();
		}

		if (xLabelChanged) {
			xLabelComponent.text=xLabel;
			xLabelChanged=false;
			invalidateDisplayList();
		}
	}

	/** @private */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		yLabelComponent.width=250;
		yLabelComponent.height=40;
		yLabelComponent.x=5;
		yLabelComponent.y=0;

		xLabelComponent.width=250;
		xLabelComponent.height=40;
		xLabelComponent.x=unscaledWidth - xLabelComponent.width;
		xLabelComponent.y=unscaledHeight - xLabelComponent.height - 5;
	}
}
}
