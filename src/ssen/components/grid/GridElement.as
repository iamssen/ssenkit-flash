package ssen.components.grid {

import spark.components.Group;
import spark.components.VScrollBar;
import spark.components.supportClasses.SkinnableComponent;

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
		setStyle("skinClass", GridElementSkin);
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