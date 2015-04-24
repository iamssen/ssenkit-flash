package ssen.components.mxChartSupportClasses.cartesianChartElements {
import flash.geom.Rectangle;
import flash.text.engine.TextLine;

import flashx.textLayout.formats.TextLayoutFormat;

import mx.events.PropertyChangeEvent;

import ssen.text.EmbededFontUtils;
import ssen.text.TextLineCache;
import ssen.text.TextLineFactory;

[Style(name="overHeadLabelFontFamily", inherit="no", type="String")]
	[Style(name="overHeadLabelFontSize", inherit="no", type="int")]
	[Style(name="overHeadLabelFontColor", inherit="no", type="String")]

	[Style(name="groupOverHeadLabelFontFamily", inherit="no", type="String")]
	[Style(name="groupOverHeadLabelFontSize", inherit="no", type="int")]
	[Style(name="groupOverHeadLabelFontColor", inherit="no", type="String")]

	public class ClusteredColumnSetOverHeadLabel extends ClusteredColumnSeriesRendererBaseElement {
		//==========================================================================================
		// properties
		//==========================================================================================
		//---------------------------------------------
		// labelFunction
		//---------------------------------------------
		private var _labelFunction:Function;

		/** labelFunction */
		[Bindable]
		public function get labelFunction():Function {
			return _labelFunction;
		}

		public function set labelFunction(value:Function):void {
			var oldValue:Function=_labelFunction;
			_labelFunction=value;

			if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "labelFunction", oldValue, _labelFunction));
			}

			invalidateDisplayList();
		}

		//---------------------------------------------
		// groupLabelFunction
		//---------------------------------------------
		private var _groupLabelFunction:Function;

		/** groupLabelFunction */
		[Bindable]
		public function get groupLabelFunction():Function {
			return _groupLabelFunction;
		}

		public function set groupLabelFunction(value:Function):void {
			var oldValue:Function=_groupLabelFunction;
			_groupLabelFunction=value;

			if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "groupLabelFunction", oldValue, _groupLabelFunction));
			}

			invalidateDisplayList();
		}

		//----------------------------------------------------------------
		// caches
		//----------------------------------------------------------------
		private var textLines:TextLineCache=new TextLineCache;
//		private var labelFormat:TextFormatManager;
//		private var groupLabelFormat:TextFormatManager;

		//==========================================================================================
		// constructor
		//==========================================================================================
		public function ClusteredColumnSetOverHeadLabel() {
//			labelFormat=new TextFormatManager({overHeadLabelFontFamily: "fontFamily", overHeadLabelFontColor: "color", overHeadLabelFontSize: "fontSize",
//				overHeadLabelFontLookup: "fontLookup"});
//
//			groupLabelFormat=new TextFormatManager({groupOverHeadLabelFontFamily: "fontFamily", groupOverHeadLabelFontColor: "color", groupOverHeadLabelFontSize: "fontSize",
//				groupOverHeadLabelFontLookup: "fontLookup"});

		}

		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);

			switch (styleProp) {
				case "overHeadLabelFontFamily":
				case "overHeadLabelFontColor":
				case "overHeadLabelFontSize":
					invalidateDisplayList();
					break;
				case "groupOverHeadLabelFontFamily":
				case "groupOverHeadLabelFontColor":
				case "groupOverHeadLabelFontSize":
					invalidateDisplayList();
					break;
			}
		}

		//==========================================================================================
		// implements abstract methods
		//==========================================================================================
		/** @private */
		override protected function begin():void {
			textLines.clear();

			var fontFamily:String;
			var fontColor:uint;
			var fontLookup:String;
			var fontSize:int;

			fontFamily=getStyle("overHeadLabelFontFamily") || "hyundaiLight";
			fontColor=getStyle("overHeadLabelFontColor") || 0x000000;
			fontLookup=EmbededFontUtils.getFontLookup(fontFamily);
			fontSize=getStyle("overHeadLabelFontSize") || 12;

//			labelFormat.setStyle("overHeadLabelFontFamily", fontFamily);
//			labelFormat.setStyle("overHeadLabelFontColor", fontColor);
//			labelFormat.setStyle("overHeadLabelFontLookup", fontLookup);
//			labelFormat.setStyle("overHeadLabelFontSize", fontSize);

			fontFamily=getStyle("groupOverHeadLabelFontFamily") || "hyundaiLight";
			fontColor=getStyle("groupOverHeadLabelFontColor") || 0x000000;
			fontLookup=EmbededFontUtils.getFontLookup(fontFamily);
			fontSize=getStyle("groupOverHeadLabelFontSize") || 15;

//			groupLabelFormat.setStyle("groupOverHeadLabelFontFamily", fontFamily);
//			groupLabelFormat.setStyle("groupOverHeadLabelFontColor", fontColor);
//			groupLabelFormat.setStyle("groupOverHeadLabelFontLookup", fontLookup);
//			groupLabelFormat.setStyle("groupOverHeadLabelFontSize", fontSize);
		}



		override protected function drawColumnOverHead(rect:Rectangle, data:Object, field:String):void {
			if (_labelFunction == null) {
				return;
			}

			var str:String=_labelFunction(data, field);

			if (!str) {
				return;
			}

			var lines:Vector.<TextLine>=TextLineFactory.createTextLines(str, new TextLayoutFormat());
			var line:TextLine;

			var f:int=lines.length;
			var ny:int=rect.y - 5;

			while (--f >= 0) {
				line=lines[f];

				ny=ny - line.height + line.ascent;

				line.x=rect.x - (line.width / 2) + (rect.width / 2);
				line.y=ny - 3;

				addChild(line);
				textLines.add(line);
			}
		}

		override protected function drawColumnSetOverHead(rect:Rectangle, data:Object, fields:Vector.<String>):void {
			if (_groupLabelFunction == null) {
				return;
			}

			var str:String=_groupLabelFunction(data, fields);

			if (!str) {
				return;
			}

			var lines:Vector.<TextLine>=TextLineFactory.createTextLines(str, new TextLayoutFormat());
			var line:TextLine;

			var f:int=lines.length;
			var ny:int=rect.y - 30;

			while (--f >= 0) {
				line=lines[f];

				ny=ny - line.height + line.ascent;

				line.x=rect.x - (line.width / 2) + (rect.width / 2);
				line.y=ny - 3;

				addChild(line);
				textLines.add(line);
			}
		}
	}
}

