package ssen.drawingkit.graphics {
import flash.display.Graphics;

import ssen.common.IDisposable;

public interface IRectangleTexture extends IDisposable {
	function draw(graphics:Graphics, x:int, y:int, width:int, height:int):void;
}
}
