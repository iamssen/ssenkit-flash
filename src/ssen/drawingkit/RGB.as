package ssen.drawingkit {
import ssen.common.StringUtils;

public class RGB {
	//----------------------------------------------------------------
	// properties
	//----------------------------------------------------------------
	public var r:int;
	public var g:int;
	public var b:int;

	public function RGB(hex:uint=0xffffff) {
		setHex(hex);
	}

	/** hex color 를 입력한다 */
	public function setHex(hex:uint):void {
		r=(hex & 0xff0000) >> 16;
		g=(hex & 0x00ff00) >> 8;
		b=(hex & 0x0000ff);
	}

	/** hex color 로 내보낸다 */
	public function toHex():uint {
		var hex:uint=r;
		hex=g + (hex << 8);
		hex=b + (hex << 8);
		return hex;
	}

	public function clone():RGB {
		var clone:RGB=new RGB;
		clone.r=r;
		clone.g=g;
		clone.b=b;
		return clone;
	}

	public function toString():String {
		return StringUtils.formatToString('[RGB r="{0}" g="{1}" b="{2}"]', r.toString(16), g.toString(16), b.toString(16));
	}

	//----------------------------------------------------------------
	// blend
	//----------------------------------------------------------------
	public function multiply(rgb:RGB):RGB {
		var out:RGB=new RGB;

		out.r=rgb.r * r / 255;
		out.g=rgb.g * g / 255;
		out.b=rgb.b * b / 255;

		return out;
	}
}
}
