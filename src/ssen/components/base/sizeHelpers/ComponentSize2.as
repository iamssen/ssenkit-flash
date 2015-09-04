package ssen.components.base.sizeHelpers {
public class ComponentSize2 {
	public var contentSize:Number;
	public var contentMinSize:Number;

	[Inspectable(type="Array", enumeration="ignore,resize,scroll", defaultValue="resize")]
	public var underSizePolicy:String = "resize";

	[Inspectable(type="Array", enumeration="ignore,resize,cut", defaultValue="resize")]
	public var overSizePolicy:String = "resize";

	[Inspectable(type="Array", enumeration="front,center,back", defaultValue="center")]
	public var align:String = "center";

	public var userExplicitMaxSize:Number;

	public var userExplicitMinSize:Number;

	public function get explicitMaxSize():Number {
		if (overSizePolicy === "cut") {
			if (!isNaN(userExplicitMaxSize)) {
				return Math.min(userExplicitMaxSize, contentSize);
			}
			return contentSize;
		}
		return userExplicitMaxSize;
	}

	public function get explicitMinSize():Number {
		if (underSizePolicy === "scroll") {
			if (!isNaN(userExplicitMinSize)) {
				return Math.max(userExplicitMinSize, contentMinSize);
			}
			return contentMinSize;
		}
		return userExplicitMinSize;
	}

	public function canSkipSetExplicitMaxSize():Boolean {
		if (overSizePolicy === "cut") {
			return isNaN(contentSize) || userExplicitMaxSize > contentSize;
		}
		return false;
	}

	public function canSkipSetExplicitMinSize():Boolean {
		if (underSizePolicy === "scroll") {
			return isNaN(contentMinSize) || userExplicitMinSize < contentMinSize;
		}
		return false;
	}

	public function ComponentSize2(overSizePolicy:String = "resize", underSizePolicy:String = "resize", align:String = "center") {
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
