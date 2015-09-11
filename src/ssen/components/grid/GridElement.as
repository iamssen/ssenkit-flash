package ssen.components.grid {

import spark.components.Group;
import spark.components.VScrollBar;
import spark.components.supportClasses.SkinnableComponent;

import ssen.components.base.setDefaultSkin;

public class GridElement extends SkinnableComponent {
	//==========================================================================================
	// skin parts
	//==========================================================================================
	[SkinPart(required="true")]
	public var frontLockedContainer:Group;

	[SkinPart(required="true")]
	public var backLockedContainer:Group;

	[SkinPart(required="true")]
	public var unlockedContainer:Group;

	[SkinPart(required="true")]
	public var scrollBar:VScrollBar;

	public function GridElement() {
		setDefaultSkin(styleManager, GridElement, GridElementSkin);
	}

	override protected function attachSkin():void {
		if (!getStyle("skinClass") && !getStyle("skinFactory")) setStyle("skinClass", GridElementSkin);
		super.attachSkin();
	}

	public function getBlock(block:int):Group {
		switch (block) {
			case GridBlock.FRONT_LOCK:
				return frontLockedContainer;
			case GridBlock.BACK_LOCK:
				return backLockedContainer;
			default:
				return unlockedContainer;
		}
	}
}
}
