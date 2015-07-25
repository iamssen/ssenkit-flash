package ssen.components.base.sizeHelpers {
public class Sample__ComponentSizeHelper {
}
}

import mx.core.UIComponent;

import spark.components.HScrollBar;

import ssen.components.base.sizeHelpers.Cut;
import ssen.components.base.sizeHelpers.Ignore;
import ssen.components.base.sizeHelpers.Resize;
import ssen.components.base.sizeHelpers.Scroll;

class OverAndResizeCase extends UIComponent {
	private var hOverLayout:Resize;

	override protected function commitProperties():void {
		super.commitProperties();
		hOverLayout.contentSize = 300;
		hOverLayout.contentMinSize = 30;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (unscaledWidth > hOverLayout.contentSize) {
			var hRatio:Number = hOverLayout.getResizeRatio(unscaledWidth);
			// draw
		}
	}
}

class UnderAndResizeCase extends UIComponent {
	private var hUnderLayout:Resize;

	override protected function commitProperties():void {
		super.commitProperties();
		hUnderLayout.contentSize = 300;
		hUnderLayout.contentMinSize = 30;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (unscaledWidth < hUnderLayout.contentSize) {
			var hRatio:Number = hUnderLayout.getResizeRatio(unscaledWidth);
			// draw
		}
	}
}

class OverAndCutCase extends UIComponent {
	private var hOverLayout:Cut;

	override public function set explicitMaxWidth(value:Number):void {
		hOverLayout.userExplicitMaxSize = value;
		if (hOverLayout.canSkipSetExplicitMaxSize) return;
		super.explicitMaxWidth = value;
	}

	override protected function commitProperties():void {
		super.commitProperties();
		hOverLayout.contentSize = 300;
		hOverLayout.contentMinSize = 30;
		super.explicitMaxWidth = hOverLayout.explicitMaxSize;
	}
}

class UnderAndScrollCase extends UIComponent {
	private var hUnderLayout:Scroll;
	private var _hscroll:HScrollBar;

	override public function set explicitMinWidth(value:Number):void {
		hUnderLayout.userExplicitMinSize = value;
		if (hUnderLayout.canSkipSetExplicitMinSize) return;
		super.explicitMinWidth = value;
	}

	override protected function commitProperties():void {
		super.commitProperties();
		hUnderLayout.contentSize = 300;
		hUnderLayout.contentMinSize = 30;
		super.explicitMinWidth = hUnderLayout.explicitMinSize;
		// viewport 의 conent width 를 입력시켜 준다. data 가 교체되는 등 scroll 이 초기화 될 가능성에 대비해준다
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (unscaledWidth < hUnderLayout.contentSize) {
			_hscroll.visible = true;
			_hscroll.includeInLayout = true;
			_hscroll.width = unscaledWidth;
		} else {
			_hscroll.visible = false;
			_hscroll.includeInLayout = false;
		}
	}
}

class OverAndIgnoreCase extends UIComponent {
	private var hOverLayout:Ignore;

	override protected function commitProperties():void {
		super.commitProperties();
		hOverLayout.contentSize = 300;
		hOverLayout.contentMinSize = 30;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (unscaledWidth > hOverLayout.contentSize) {
		}
	}
}

class UnderAndIgnoreCase extends UIComponent {
	private var hUnderLayout:Ignore;

	override protected function commitProperties():void {
		super.commitProperties();
		hUnderLayout.contentSize = 300;
		hUnderLayout.contentMinSize = 30;
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		if (unscaledWidth < hUnderLayout.contentSize) {
		}
	}
}