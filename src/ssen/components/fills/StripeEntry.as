package ssen.components.fills {
public class StripeEntry {
	public var color:uint = 0xffffff;
	public var alpha:Number = 1;
	public var size:int = 7;

	public function getARGB():uint {
		var a:uint = alpha * 0xff;
		if (a > 0xff) a = 0xff;
		return (a << 24) + color;
	}
}
}
