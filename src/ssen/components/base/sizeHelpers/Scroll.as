package ssen.components.base.sizeHelpers {
public class Scroll extends ComponentSizeHelper {
	public var userExplicitMinSize:Number;

	public function get explicitMinSize():Number {
		if (!isNaN(userExplicitMinSize)) {
			return Math.max(userExplicitMinSize, contentMinSize);
		} else {
			return contentMinSize;
		}
	}

	public function get canSkipSetExplicitMinSize():Boolean {
		return isNaN(contentMinSize) || userExplicitMinSize < contentMinSize;
	}
}
}
