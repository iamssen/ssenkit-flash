package ssen.components.base.sizeHelpers {
public class Resize extends ComponentSizeHelper {
	public function getResizeRatio(size:Number):Number {
		return size / contentSize;
	}
}
}
