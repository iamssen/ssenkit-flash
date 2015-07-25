package ssen.components.base.sizeHelpers {
public class ComponentSizeHelper {
	public var contentSize:Number;
	public var contentMinSize:Number;

	public function getLayoutPoint(size:Number):LinearPoint {
		return new LinearPoint(0, size);
	}
}
}
