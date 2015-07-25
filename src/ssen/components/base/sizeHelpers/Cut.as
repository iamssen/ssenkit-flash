package ssen.components.base.sizeHelpers {
public class Cut extends ComponentSizeHelper {
	public var userExplicitMaxSize:Number;

	public function get explicitMaxSize():Number {
		if (!isNaN(userExplicitMaxSize)) {
			return Math.min(userExplicitMaxSize, contentSize);
		} else {
			return contentSize;
		}
	}

	public function get canSkipSetExplicitMaxSize():Boolean {
		return isNaN(contentSize) || userExplicitMaxSize > contentSize;
	}
}
}
