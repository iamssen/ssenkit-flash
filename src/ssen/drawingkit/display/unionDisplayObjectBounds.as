package ssen.drawingkit.display {
import flash.display.DisplayObject;
import flash.geom.Rectangle;

/** display object 들의 rectangle bounds 를 합쳐서 새로운 bounds 를 만들어준다 */
public function unionDisplayObjectBounds(displayObjects:Vector.<DisplayObject>):Rectangle {
	var f:int=0;
	var fmax:int=displayObjects.length;
	var display:DisplayObject=displayObjects[0];
	var rect:Rectangle=new Rectangle(display.x, display.y, display.width, display.height);
	while (++f < fmax) {
		display=displayObjects[f];
		rect=rect.union(new Rectangle(display.x, display.y, display.width, display.height));
	}

	return rect;
}
}
