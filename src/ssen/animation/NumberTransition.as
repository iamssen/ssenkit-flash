package ssen.animation {
public class NumberTransition {
	public var from:Number;
	public var to:Number;

	public function NumberTransition(from:Number, to:Number) {
		this.from = from;
		this.to = to;
	}

	public function getSnapshot(t:Number):Number {
		return from + ((to - from) * t);
	}
}
}
