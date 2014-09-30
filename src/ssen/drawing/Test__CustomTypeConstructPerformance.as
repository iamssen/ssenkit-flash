package ssen.drawing {

import flash.geom.Point;
import flash.geom.Rectangle;

[Exclude]

/*
Point > XY 이기 때문에 구지 XY라는 Custom Type이 필요없다.
Rectangle < Rect 이지만, Custom Type을 감수할 정도로 큰 차이는 나지 않는다.

[trace] ---------------------------------------------
[trace] Audition start
[trace] ---------------------------------------------
[trace] ✓ ssen.drawing::Test__CustomTypeConstructPerformance#createPoint() 52ms
[trace] ✓ ssen.drawing::Test__CustomTypeConstructPerformance#createRectangle() 64ms
[trace] ✓ ssen.drawing::Test__CustomTypeConstructPerformance#createXY() 48ms
[trace] ✓ ssen.drawing::Test__CustomTypeConstructPerformance#createRect() 57ms
[trace] ---------------------------------------------
[trace] Pass audition.
[trace] ---------------------------------------------
*/

public class Test__CustomTypeConstructPerformance {
	private static const COUNT:int = 100000;

	[Test]
	public function createXY():void {
		var arr:Array = [];
		var f:int = -1;
		var fmax:int = COUNT;
		var o:XY;
		while (++f < fmax) {
			o = new XY;
			o.x = f;
			o.y = f;
			arr.push(o);
		}
	}

	[Test]
	public function createPoint():void {
		var arr:Array = [];
		var f:int = -1;
		var fmax:int = COUNT;
		var o:Point;
		while (++f < fmax) {
			o = new Point;
			o.x = f;
			o.y = f;
			arr.push(o);
		}
	}

	[Test]
	public function createRectangle():void {
		var arr:Array = [];
		var f:int = -1;
		var fmax:int = COUNT;
		var o:Rectangle;
		while (++f < fmax) {
			o = new Rectangle;
			o.x = f;
			o.y = f;
			o.width = f;
			o.height = f;
			arr.push(o);
		}
	}

	[Test]
	public function createRect():void {
		var arr:Array = [];
		var f:int = -1;
		var fmax:int = COUNT;
		var o:Rect;
		while (++f < fmax) {
			o = new Rect;
			o.x = f;
			o.y = f;
			o.width = f;
			o.height = f;
			arr.push(o);
		}
	}
}
}

class Rect {
	public var x:Number;
	public var y:Number;
	public var width:Number;
	public var height:Number;
}

class XY {
	public var x:Number;
	public var y:Number;
}


