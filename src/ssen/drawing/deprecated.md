```as3
package ssen.drawingkit.graphics {
import flash.display.BitmapData;
import flash.geom.Rectangle;

public class TextureMaker {
	public static function scaleBitmap(bitmap:BitmapData, scale9Grid:Rectangle, smooth:Boolean=false):IRectangleTexture {
		var texture:ScaleBitmapTexture=new ScaleBitmapTexture;
		texture.bitmap=bitmap.clone();
		texture.smooth=smooth;
		texture.scale9Grid=scale9Grid.clone();
		return texture;
	}
}
}
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import ssen.drawingkit.graphics.IRectangleTexture;

class ScaleBitmapTexture implements IRectangleTexture {
	
	public var bitmap:BitmapData;
	public var smooth:Boolean;
	public var scale9Grid:Rectangle;
	
	public function dispose():void {
		bitmap.dispose();
		bitmap=null;
		scale9Grid=null;
	}
	
	public function draw(graphics:Graphics, x:int, y:int, width:int, height:int):void {
		if (!scale9Grid) {
			drawDefault(graphics, x, y, width, height);
		} else {
			var mat:Matrix;
			var topFix:Number=scale9Grid.top;
			var bottomFix:Number=bitmap.height - scale9Grid.top - scale9Grid.height;
			var leftFix:Number=scale9Grid.left;
			var rightFix:Number=bitmap.width - scale9Grid.left - scale9Grid.width;
			
			var min:Number;
			var ow:Number=bitmap.width;
			var oh:Number=bitmap.height;
			var cols:Array;
			var dCols:Array;
			var rows:Array;
			var dRows:Array;
			
			var origin:Rectangle;
			var draw:Rectangle;
			
			var cy:int;
			var cx:int;
			if (scale9Grid.x == 0 && (scale9Grid.width == width || scale9Grid.width == 0)) {
				min=topFix + bottomFix;
				
				if (height > min) {
					mat=new Matrix();
					rows=[0, topFix, oh - bottomFix, oh];
					dRows=[0, topFix, height - bottomFix, height];
					
					cy=-1;
					while (++cy < 3) {
						origin=new Rectangle(0, rows[cy], width, rows[cy + 1] - rows[cy]);
						draw=new Rectangle(0, dRows[cy], width, dRows[cy + 1] - dRows[cy]);
						mat.identity();
						mat.a=width / bitmap.width;
						mat.d=draw.height / origin.height;
						mat.tx=(draw.x - origin.x * mat.a) + x;
						mat.ty=(draw.y - origin.y * mat.d) + y;
						drawScale(graphics, x, y, draw, mat);
					}
				} else {
					drawDefault(graphics, x, y, width, height);
				}
			} else if (scale9Grid.y == 0 && (scale9Grid.height == height || scale9Grid.height == 0)) {
				min=leftFix + rightFix;
				if (width > min) {
					mat=new Matrix();
					cols=[0, leftFix, ow - rightFix, ow];
					dCols=[0, leftFix, width - rightFix, width];
					
					cx=-1;
					while (++cx < 3) {
						origin=new Rectangle(cols[cx], 0, cols[cx + 1] - cols[cx], height);
						draw=new Rectangle(dCols[cx], 0, dCols[cx + 1] - dCols[cx], height);
						mat.identity();
						mat.a=draw.width / origin.width;
						mat.d=height / bitmap.height;
						mat.tx=(draw.x - origin.x * mat.a) + x;
						mat.ty=(draw.y - origin.y * mat.d) + y;
						drawScale(graphics, x, y, draw, mat);
					}
				} else {
					drawDefault(graphics, x, y, width, height);
				}
			} else {
				min=topFix + bottomFix;
				ow=bitmap.width;
				oh=bitmap.height;
				if (height > min) {
					mat=new Matrix();
					cols=[0, leftFix, ow - rightFix, ow];
					dCols=[0, leftFix, width - rightFix, width];
					rows=[0, topFix, oh - bottomFix, oh];
					dRows=[0, topFix, height - bottomFix, height];
					
					cx=-1;
					while (++cx < 3) {
						cy=-1;
						while (++cy < 3) {
							origin=new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
							draw=new Rectangle(dCols[cx], dRows[cy], dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);
							mat.identity();
							mat.a=draw.width / origin.width;
							mat.d=draw.height / origin.height;
							mat.tx=(draw.x - origin.x * mat.a) + x;
							mat.ty=(draw.y - origin.y * mat.d) + y;
							drawScale(graphics, x, y, draw, mat);
						}
					}
				} else {
					drawDefault(graphics, x, y, width, height);
				}
			}
		}
	}
	
	private function drawScale(graphics:Graphics, x:Number, y:Number, draw:Rectangle, mat:Matrix):void {
		graphics.beginBitmapFill(bitmap, mat, false, smooth);
		graphics.drawRect(draw.x + x, draw.y + y, draw.width, draw.height);
		graphics.endFill();
	}
	
	private function drawDefault(graphics:Graphics, x:Number, y:Number, width:Number, height:Number):void {
		var mat:Matrix=new Matrix();
		mat.a=width / bitmap.width;
		mat.d=height / bitmap.height;
		mat.tx=x;
		mat.ty=y;
		
		graphics.beginBitmapFill(bitmap, mat, false, smooth);
		graphics.drawRect(x, y, width, height);
		graphics.endFill();
	}
}
```


```as3
package ssen.drawing {
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
```