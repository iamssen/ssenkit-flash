package ssen.drawing {

import flash.display.DisplayObject;
import flash.geom.Rectangle;

public class DrawingUtils {
	/** display object 들의 rectangle bounds 를 합쳐서 새로운 bounds 를 만들어준다 */
	public static function unionDisplayObjectBounds(displayObjects:Vector.<DisplayObject>):Rectangle {
		var f:int = 0;
		var fmax:int = displayObjects.length;
		var display:DisplayObject = displayObjects[0];
		var rect:Rectangle = new Rectangle(display.x, display.y, display.width, display.height);
		while (++f < fmax) {
			display = displayObjects[f];
			rect = rect.union(new Rectangle(display.x, display.y, display.width, display.height));
		}

		return rect;
	}

	/**
	 * 대상을 특정 사이즈에 맞게 줄일때 필요한 곱하기 비율을 알아낸다
	 * @param bounds scaling 시킬 대상의 bound
	 * @param targetCoordinateSpace scaling 시킬 공간의 bound
	 * @return scaling 시키기 위해서 곱해줄 비율
	 */
	public static function getScalingMinimizeRatio(bounds:Rectangle, targetCoordinateSpace:Rectangle):Number {
		var hratio:Number = (bounds.width > targetCoordinateSpace.width) ? targetCoordinateSpace.width / bounds.width : 1;
		var vratio:Number = (bounds.height > targetCoordinateSpace.height) ? targetCoordinateSpace.height / bounds.height : 1;

		return (hratio > vratio) ? vratio : hratio;
	}
}
}
