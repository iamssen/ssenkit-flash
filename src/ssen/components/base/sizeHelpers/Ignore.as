package ssen.components.base.sizeHelpers {
public class Ignore extends ComponentSizeHelper {
	public static const FRONT:int = 0;
	public static const CENTER:int = 1;
	public static const BACK:int = 2;

	public var align:int;

	public function Ignore(align:int = 1) {
		this.align = align;
	}

	public function getFrontPosition(size:Number):Number {
		switch (align) {
			case CENTER:
				return (size - contentSize) / 2;
			case BACK:
				return size - contentSize;
			default :
				return 0;
		}
	}

	override public function getLayoutPoint(size:Number):LinearPoint {
		return new LinearPoint(getFrontPosition(size), contentSize);
	}
}
}
