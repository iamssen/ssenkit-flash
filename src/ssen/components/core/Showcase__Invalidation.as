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

/*
# invalidateParentSizeAndDisplayList()
```
[trace] Showcase__Invalidation.invalidateParentOnly()
[trace] Test.invalidateParentSizeAndDisplayList()
```
Parent에만 영향을 끼친다.
리스트가 전반적으로 교체된다거나, 상위의 Rendering에 의해 하위의 Rendering이 실행될 경우 사용할 수 있을듯 싶다.


# invalidateProperties()
```
[trace] Showcase__Invalidation.invalidatePropertiesOnly()
[trace] Test.invalidateProperties()
[trace] @ Test.commitProperties() -->
[trace] @ Test.commitProperties() <--
```
자체적으로는 Size, Display Update 등에는 영향을 미치지 않는다.

# invalidateSize()
```
[trace] Showcase__Invalidation.invalidateSizeOnly()
[trace] Test.invalidateSize()
[trace] @ Test.measureSizes() -->
[trace] @ Test.canSkipMeasurement() -->
[trace] @ Test.canSkipMeasurement() <-- false
[trace] @ Test.measure() -->
[trace]     [width basic=0/0/10000 explicit=NaN/NaN/NaN measured=0/0]
[trace]     [height basic=0/0/10000 explicit=NaN/NaN/NaN measured=0/0]
[trace] @ Test.measure() <--
[trace] @ Test.measureSizes() <-- false
```
역시 Display Update 에는 영향을 미치지 않는다

# invalidateDisplayList()
```
[trace] Showcase__Invalidation.invalidateDisplayListOnly()
[trace] Test.invalidateDisplayList()
[trace] @ Test.updateDisplayList() -->
[trace] @ Test.updateDisplayList() <-- 0 0
```
Display Update 에만 영향을 미친다
Size에 대한 계산을 끌고 오지 않는다

# Intricate invalidation
```
[trace] Showcase__Invalidation.invalidateLazy()
[trace] Test.invalidateSize()
[trace] Test.invalidateSize()
[trace] Test.invalidateDisplayList()
[trace] Test.invalidateDisplayList()
[trace] Test.invalidateSize()
[trace] Test.invalidateProperties()
[trace] Test.invalidateParentSizeAndDisplayList()
[trace] Test.invalidateDisplayList()
[trace] Test.invalidateSize()
[trace] Test.invalidateProperties()
[trace] Test.invalidateSize()
[trace] Test.invalidateSize()
[trace] Test.invalidateDisplayList()
[trace] Test.invalidateProperties()
[trace] Test.invalidateDisplayList()
[trace] Test.invalidateSize()
[trace] Test.invalidateProperties()
[trace] Test.invalidateParentSizeAndDisplayList()
[trace] Test.invalidateDisplayList()
[trace] @ Test.commitProperties() -->
[trace] @ Test.commitProperties() <--
[trace] @ Test.measureSizes() -->
[trace] @ Test.canSkipMeasurement() -->
[trace] @ Test.canSkipMeasurement() <-- false
[trace] @ Test.measure() -->
[trace]     [width basic=0/0/10000 explicit=NaN/NaN/NaN measured=0/0]
[trace]     [height basic=0/0/10000 explicit=NaN/NaN/NaN measured=0/0]
[trace] @ Test.measure() <--
[trace] @ Test.measureSizes() <-- false
[trace] @ Test.updateDisplayList() -->
[trace] @ Test.updateDisplayList() <-- 0 0
```
다수의 Invalidation을 중복 실행한다해도 실행되는 Update Hook 들은 일정하게 작동한다

# 필요한 Hook 구조들

commitProperties()
- 하위 element 들의 추가/삭제를 할 수 있다 (단순한 element 들의 추가/삭제)
- content width/height를 계산할 수 있다 (content가 고정 사이즈를 가지는 경우)

canSkipMeasurment()
- explicit width/height 와 content width/height 를 체크해서 자동 size를 계산할지 결정한다

measure()
- content width/height 와 explicit width/height 를 가지고 자동 size를 계산한다


*/

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