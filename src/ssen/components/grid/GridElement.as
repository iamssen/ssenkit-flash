package ssen.components.grid {

import spark.components.Group;
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

	public function GridElement() {
		setStyle("skinClass", GridElementSkin);
	}
}
}
