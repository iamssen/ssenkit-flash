package ssen.components.base.sizeHelpers {
import mx.core.mx_internal;

use namespace mx_internal;

public class ComponentSize {
	public var contentSize:Number;
	public var contentMinSize:Number;

	[Inspectable(type="Array", enumeration="ignore,resize,scroll", defaultValue="resize")]
	public var underSizePolicy:String = "resize";

	[Inspectable(type="Array", enumeration="ignore,resize,cut", defaultValue="resize")]
	public var overSizePolicy:String = "resize";

	[Inspectable(type="Array", enumeration="front,center,back", defaultValue="center")]
	public var align:String = "center";

	public function ComponentSize(overSizePolicy:String = "resize", underSizePolicy:String = "resize", align:String = "center") {
		this.overSizePolicy = overSizePolicy;
		this.underSizePolicy = underSizePolicy;
		this.align = align;
	}

	public function commitProperties(contentSize:Number, contentMinSize:Number):void {
		this.contentSize = contentSize;
		this.contentMinSize = contentMinSize;
	}

	public function computeSize(size:Number):Number {
		if (overSizePolicy === "cut" && size > contentSize) {
			return contentSize;
		} else if (underSizePolicy === "scroll" && size < contentMinSize) {
			return contentMinSize;
		}
		return size;
	}

	public function getLayoutPoint(size:Number):LinearPoint {
		if ((overSizePolicy === "ignore" && size > contentSize) || (underSizePolicy === "ignore" && size < contentSize)) {
			var frontPosition:Number;
			switch (align) {
				case "center":
					frontPosition = (size - contentSize) / 2;
					break;
				case "back":
					frontPosition = size - contentSize;
					break;
				default:
					frontPosition = 0;
					break;
			}
			return new LinearPoint(frontPosition, contentSize);
		}

		return new LinearPoint(0, size);
	}
}
}

