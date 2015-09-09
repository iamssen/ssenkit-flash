package ssen.components.scroll {

import spark.components.HScrollBar;

import ssen.components.scroll.snippets.SimpleHorizontalScrollBarSkin;

[Style(name="thumbColor", inherit="yes", type="uint", format="Color")]
[Style(name="thumbAlpha", inherit="yes", type="Number", format="Number")]
[Style(name="thumbOverColor", inherit="yes", type="uint", format="Color")]
[Style(name="thumbOverAlpha", inherit="yes", type="Number", format="Number")]
[Style(name="thumbDownColor", inherit="yes", type="uint", format="Color")]
[Style(name="thumbDownAlpha", inherit="yes", type="Number", format="Number")]
[Style(name="trackColor", inherit="yes", type="uint", format="Color")]
[Style(name="trackAlpha", inherit="yes", type="Number", format="Number")]
[Style(name="thumbInsideMargin", inherit="yes", type="uint")]
[Style(name="thumbOutsideMargin", inherit="yes", type="uint")]
[Style(name="thumbStartMargin", inherit="yes", type="uint")]
[Style(name="thumbEndMargin", inherit="yes", type="uint")]

public class SimpleHorizontalScrollBar extends HScrollBar {
	override protected function createChildren():void {
		if (!getStyle("skinClass") && !getStyle("skinFactory")) setStyle("skinClass", SimpleHorizontalScrollBarSkin);
		super.createChildren();
	}
}
}
