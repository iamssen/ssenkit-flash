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
			"Invalidate Lazy"             : invalidateLazy,
			"Invalidate Properties Only"  : invalidatePropertiesOnly,
			"Invalidate Size Only"        : invalidateSizeOnly,
			"Invalidate Parent Only"      : invalidateParentOnly,
			"Invalidate Display List Only": invalidateDisplayListOnly
		}
		var btn:Button;

		for (var label:String in tests) {
			btn = new Button;
			btn.label = label;
			btn.addEventListener(MouseEvent.CLICK, tests[label], false, 0, true);
			addElement(btn);
		}
	}

	private function invalidateLazy(event:MouseEvent):void {
		trace("Showcase__Invalidation.invalidateLazy()");
		test.invalidateSize();
		test.invalidateSize();
		test.invalidateDisplayList();
		test.invalidateDisplayList();
		test.invalidateSize();
		test.invalidateProperties();
		test.callInvalidateParentSizeAndDisplayList();
		test.invalidateDisplayList();
		test.invalidateSize();
		test.invalidateProperties();
		test.invalidateSize();
		test.invalidateSize();
		test.invalidateDisplayList();
		test.invalidateProperties();
		test.invalidateDisplayList();
		test.invalidateSize();
		test.invalidateProperties();
		test.callInvalidateParentSizeAndDisplayList();
		test.invalidateDisplayList();
	}

	private function invalidatePropertiesOnly(event:MouseEvent):void {
		trace("Showcase__Invalidation.invalidatePropertiesOnly()");
		test.invalidateProperties();
	}

	private function invalidateSizeOnly(event:MouseEvent):void {
		trace("Showcase__Invalidation.invalidateSizeOnly()");
		test.invalidateSize();
	}

	private function invalidateParentOnly(event:MouseEvent):void {
		trace("Showcase__Invalidation.invalidateParentOnly()");
		test.callInvalidateParentSizeAndDisplayList();
	}

	private function invalidateDisplayListOnly(event:MouseEvent):void {
		trace("Showcase__Invalidation.invalidateDisplayListOnly()");
		test.invalidateDisplayList();
	}
}
}

import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.utils.StringUtil;

use namespace mx_internal;

class Test extends UIComponent {
	public function callInvalidateParentSizeAndDisplayList():void {
		invalidateParentSizeAndDisplayList();
	}

	override protected function invalidateParentSizeAndDisplayList():void {
		super.invalidateParentSizeAndDisplayList();
		trace("Test.invalidateParentSizeAndDisplayList()");
	}

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
		trace("@ Test.canSkipMeasurement() -->");
		var result:Boolean = super.canSkipMeasurement();
		trace("@ Test.canSkipMeasurement() <--", result);
		return result;
	}

	override mx_internal function measureSizes():Boolean {
		trace("@ Test.measureSizes() -->");
		var result:Boolean = super.mx_internal::measureSizes();
		trace("@ Test.measureSizes() <--", result);
		return result;
	}

	override protected function measure():void {
		trace("@ Test.measure() -->");
		super.measure();
		trace(StringUtil.substitute('    [width basic={0}/{1}/{2} explicit={3}/{4}/{5} measured={6}/{7}]',
				width, minWidth, maxWidth,
				explicitWidth, explicitMinWidth, explicitMaxWidth,
				measuredWidth, measuredMinWidth
		));
		trace(StringUtil.substitute('    [height basic={0}/{1}/{2} explicit={3}/{4}/{5} measured={6}/{7}]',
				height, minHeight, maxHeight,
				explicitHeight, explicitMinHeight, explicitMaxHeight,
				measuredHeight, measuredMinHeight
		));
		trace("@ Test.measure() <--");
	}

	override protected function commitProperties():void {
		trace("@ Test.commitProperties() -->");
		super.commitProperties();
		trace("@ Test.commitProperties() <--");
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		trace("@ Test.updateDisplayList() -->");
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		trace("@ Test.updateDisplayList() <--", unscaledWidth, unscaledHeight);
	}
}

class Template extends UIComponent {
	/** @private */
	override protected function commitProperties():void {
		super.commitProperties();

		// 다량의 변수들을 취합해서 상태 판단
		// Animation을 해야 한다던지,
		// 새롭게 Size 변경이 필요 하다던지 (content size 자체를 여기서 조절해도 될듯)

		var updateDisplayObjecties:Boolean;
		var updateDraw:Boolean;

		if (updateDisplayObjecties) {
			// 기존 Display Objecties 삭제
			// Display Objecties 생성
		}

		// 내부적으로 다량의 Display Object들이 사용될 경우 여기에서 생성 할 수 있다.
		// 생성을 이곳에서 하고, 실제 Graphics Drawing은 updateDisplayList() 에서 처리하는 식으로 Display Object의 생성을 막을 수 있을 듯
	}

	/** @private */
	override protected function canSkipMeasurement():Boolean {
		// 변동 사이즈 처리가 필요한 경우에 false
		// explicit가 존재한다면 딱히 필요없다
		return super.canSkipMeasurement();
	}

	/** @private */
	override protected function measure():void {
		super.measure();

		trace(StringUtil.substitute('[width basic={0}/{1}/{2} explicit={3}/{4}/{5} measured={6}/{7}]',
				width, minWidth, maxWidth,
				explicitWidth, explicitMinWidth, explicitMaxWidth,
				measuredWidth, measuredMinWidth
		));
		trace(StringUtil.substitute('[height basic={0}/{1}/{2} explicit={3}/{4}/{5} measured={6}/{7}]',
				height, minHeight, maxHeight,
				explicitHeight, explicitMinHeight, explicitMaxHeight,
				measuredHeight, measuredMinHeight
		));
	}

	/** @private */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
	}
}