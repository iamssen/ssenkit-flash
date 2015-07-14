package ssen.components.core {
import mx.graphics.SolidColor;

import spark.components.Group;
import spark.layouts.VerticalLayout;
import spark.primitives.Rect;

public class Showcase__Size extends Group {
	public function Showcase__Size() {
		var verticalLayout:VerticalLayout = new VerticalLayout;
		verticalLayout.padding = 10;
		verticalLayout.gap = 10;
		layout = verticalLayout;

		var rect1:Rect = new Rect;
		rect1.percentWidth = 100;
		rect1.height = 100;
		rect1.fill = new SolidColor(0xaaaaaa);
		addElement(rect1);

		var test:Test = new Test;
		test.percentWidth = 100;
		test.percentHeight = 100;
		addElement(test);

		var rect2:Rect = new Rect;
		rect2.percentWidth = 100;
		rect2.height = 100;
		rect2.fill = new SolidColor(0xaaaaaa);
		addElement(rect2);
	}
}
}

import flash.display.Graphics;

import mx.core.UIComponent;
import mx.utils.StringUtil;

class Test extends UIComponent {

	override protected function commitProperties():void {
		super.commitProperties();
		explicitMaxHeight = 300;
	}

//	override protected function canSkipMeasurement():Boolean {
//		var v:Boolean = false;
//		trace("Test.canSkipMeasurement()", v);
//		return v;
//	}
//
//	override protected function measure():void {
//		super.measure();
//		trace("@ Test.measure() -->");
//		super.measure();
//
//		measuredHeight = 400; // 효과 없음
//		//		explicitMaxHeight = 300; // 효과 있음
//		//		maxHeight = 300; // 효과 있음
//
//		trace(StringUtil.substitute('    [width basic={0}/{1}/{2} explicit={3}/{4}/{5} measured={6}/{7}]',
//				width, minWidth, maxWidth,
//				explicitWidth, explicitMinWidth, explicitMaxWidth,
//				measuredWidth, measuredMinWidth
//		));
//		trace(StringUtil.substitute('    [height basic={0}/{1}/{2} explicit={3}/{4}/{5} measured={6}/{7}]',
//				height, minHeight, maxHeight,
//				explicitHeight, explicitMinHeight, explicitMaxHeight,
//				measuredHeight, measuredMinHeight
//		));
//		trace("@ Test.measure() <--");
//	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		trace("Test.updateDisplayList()", unscaledWidth, unscaledHeight);

		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0xff0000);
		g.drawRect(0, 0, unscaledWidth, unscaledHeight);
		g.endFill();
	}
}