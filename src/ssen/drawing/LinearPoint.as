package ssen.drawing {
import mx.utils.StringUtil;

public class LinearPoint {
	public var p:Number;
	public var size:Number;

	public function LinearPoint(p:Number, size:Number) {
		this.p = p;
		this.size = size;
	}

	public function toString():String {
		return StringUtil.substitute('[LinearPoint p={0} size={1}]', p, size);
	}
}
}
