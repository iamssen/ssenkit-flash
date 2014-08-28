package ssen.drawingkit.graphics {
import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;

public class DottedLine extends Shape {
	public static function create(x1:int, y1:int, x2:int, y2:int, color:uint=0x000000, dash:uint=1, gap:uint=13,
								  thickness:uint=10):DottedLine {
		var line:DottedLine=new DottedLine;
		line.x=x1;
		line.y=y1;

		var dash1:Number=(dash > thickness) ? dash - thickness : 1;
		var gap1:Number=gap + thickness;

		var dx:Number=x2 - x1;
		var dy:Number=y2 - y1;
		var w:Number=Math.sqrt(dx * dx + dy * dy);

		line.rotation=Math.atan2(dy, dx) * 180 / Math.PI;

		var pos:uint=0;
		var dashPlusGap:uint=dash1 + gap1;
		var g:Graphics=line.graphics;

		g.clear();
		g.moveTo(0, 0);
		g.lineStyle(thickness, color, 1, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);

		while (w > 0) {
			g.moveTo(pos, 0);
			pos+=dash1;
			g.lineTo(pos, 0);
			pos+=gap1;
			w-=dashPlusGap;
		}

		return line;
	}

	public function dispose():void {
		if (parent) {
			parent.removeChild(this);
			graphics.clear();
		}
	}
}
}
