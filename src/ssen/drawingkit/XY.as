package ssen.drawingkit {
import flash.geom.Point;

import ssen.common.StringUtils;

public class XY {
	public var x:int;
	public var y:int;

	public function XY(x:int=0, y:int=0) {
		this.x=x;
		this.y=y;
	}

	public function clone():XY {
		return new XY(x, y);
	}

	public function toString():String {
		return StringUtils.formatToString('[XY x="{0}" y="{1}"]', x, y);
	}

	public function toPoint():Point {
		return new Point(x, y);
	}
}
}
