package ssen.components.tooltips {
import mx.core.FlexGlobals;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.managers.PopUpManager;

import spark.components.Application;

public class ToolTipProvider {
	public var renderer:IFactory; // of IToolTipRenderer
	public var toolTipFunction:Function;

	private var toolTip:IFlexDisplayObject;

	public function show(centerX:Number, centerY:Number, contentX:Number, contentY:Number, params:Object = null):void {
		toolTip = renderer.newInstance();
		PopUpManager.addPopUp(toolTip, FlexGlobals.topLevelApplication as Application);
		toolTipFunction(toolTip, params);

		var w:Number = toolTip.width;
		var h:Number = toolTip.height;
		var sw:Number = toolTip.stage.stageWidth;
		var sh:Number = toolTip.stage.stageHeight;
		var right:Boolean = true;
		var bottom:Boolean = false;

		if (right && contentX + w > sw) {
			right = false;
		} else if (!right && contentX - w < 0) {
			right = true;
		}

		if (bottom && contentY + h > sh) {
			bottom = false;
		} else if (!bottom && contentY - w < 0) {
			bottom = true;
		}

		if (right) {
			toolTip.x = contentX;
		} else {
			toolTip.x = contentX - w;
		}

		if (bottom) {
			toolTip.y = contentY;
		} else {
			toolTip.y = contentY - h;
		}
	}

	public function hide():void {
		if (toolTip) {
			PopUpManager.removePopUp(toolTip);
			toolTip = null;
		}
	}
}
}
