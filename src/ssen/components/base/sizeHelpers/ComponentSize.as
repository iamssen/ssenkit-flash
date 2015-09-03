package ssen.components.base.sizeHelpers {
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

	public function getActualSize(actualSize:Number):Number {
		if (overSizePolicy === "cut" && actualSize > contentSize) {
			return contentSize;
		} else if (underSizePolicy === "scroll" && actualSize < contentMinSize) {
			return contentMinSize;
		}
		return actualSize;
	}

	public function getLayoutPoint(unscaledSize:Number):LinearPoint {
		if ((overSizePolicy === "ignore" && unscaledSize > contentSize)
				|| (underSizePolicy === "ignore" && unscaledSize < contentSize)) {
			var frontPosition:Number;
			switch (align) {
				case "center":
					frontPosition = (unscaledSize - contentSize) / 2;
					break;
				case "back":
					frontPosition = unscaledSize - contentSize;
					break;
				default:
					frontPosition = 0;
					break;
			}
			return new LinearPoint(frontPosition, contentSize);
		}

		return new LinearPoint(0, unscaledSize);
	}
}
}

import mx.core.UIComponent;

import ssen.components.base.sizeHelpers.ComponentSize;

class Comp extends UIComponent {
	private var hsize:ComponentSize;

	public function Comp() {
		// constructor 에서 기본 Size Policy를 정해준다
		hsize = new ComponentSize("resize", "resize");
	}

	override protected function commitProperties():void {
		super.commitProperties();
		// content size 확정 구간
		// commit properties 에서 content의 계산된 size를 입력해준다
		hsize.commitProperties(100, 40);
	}

	override protected function measure():void {
		super.measure();
		// measure size 확정 구간
		// measure 상황이 되고, explicit size가 없으면 measure size 에 content size를 넣어준다
		if (isNaN(explicitWidth)) measuredWidth = hsize.contentSize;
	}

	override public function setActualSize(w:Number, h:Number):void {
		// actual size 변조 구간
		// cut 이거나 scroll 이 설정되어 있는 경우, actual size를 변조한다
		w = hsize.getActualSize(w);
		super.setActualSize(w, h);
	}

	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		trace("size", width, height);
		trace("unscaled", unscaledWidth, unscaledHeight);
		trace("measured", measuredWidth, measuredHeight);
		trace("measured min", measuredMinWidth, measuredMinHeight);
		trace("explicit", explicitWidth, explicitHeight);
		trace("explicit min", explicitMinWidth, explicitMinHeight);
		trace("explicit max", explicitMaxWidth, explicitMaxHeight);
		trace("content size", hsize.contentSize);
		trace("content min size", hsize.contentMinSize);
		trace();
		trace();
	}
}


