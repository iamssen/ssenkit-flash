package ssen.components.core {
import flash.events.MouseEvent;

import spark.components.Button;
import spark.components.VGroup;

public class Showcase__Invalidation extends VGroup {
	private var test:Test;

	public function Showcase__Invalidation() {
		paddingLeft = 10;
		paddingTop = 10;

		test = new Test;
		addElement(test);

		var tests:Object = {
			"Test1": test1
		}
		var btn:Button;

		for (var label:String in tests) {
			btn = new Button;
			btn.label = label;
			btn.addEventListener(MouseEvent.CLICK, tests[label], false, 0, true);
			addChild(btn);
		}
	}

	private function test1(event:MouseEvent):void {
		trace("Showcase__Invalidation.test1()");
		test.invalidateSize();
		test.invalidateSize();
		test.invalidateDisplayList();
		test.invalidateDisplayList();
	}
}
}

import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

class Test extends UIComponent {
	override public function invalidateDisplayList():void {
		super.invalidateDisplayList();
		trace("Test.invalidateDisplayList()");
	}

	override public function invalidateProperties():void {
		super.invalidateProperties();
		trace("Test.invalidateProperties()");
	}

	override public function invalidateSize():void {
		super.invalidateSize();
		trace("Test.invalidateSize()");
	}

	override protected function canSkipMeasurement():Boolean {
		var result:Boolean = super.canSkipMeasurement();
		trace("Test.canSkipMeasurement()", result);
		return result;
	}

	override mx_internal function measureSizes():Boolean {
		var result:Boolean = super.mx_internal::measureSizes();
		trace("Test.measureSizes()", result);
		return result;
	}

	override protected function measure():void {
		super.measure();
		trace("Test.measure()");
	}

	override protected function commitProperties():void {
		super.commitProperties();
		trace("Test.commitProperties()");
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		trace("Test.updateDisplayList()");
	}
}