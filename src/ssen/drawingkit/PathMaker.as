package ssen.drawingkit {
import flash.display.GraphicsPath;
import flash.display.GraphicsTrianglePath;
import flash.geom.Point;

public class PathMaker {
	//==========================================================================================
	// arrow
	//==========================================================================================
	private static const ARROW_RECT_COMMAND:Vector.<int>=new <int>[1, 2, 2, 2, 2, 2];

	public static function arrowRect(direction:int, arrowSize:int, x:Number, y:Number, width:Number, height:Number):GraphicsPath {
		var path:GraphicsPath=new GraphicsPath();
		path.commands=ARROW_RECT_COMMAND;
		var rect:Vector.<Number>=new <Number>[x, y, x + width, y, x + width, y + height, x, y + height, x, y];
		path.data=new Vector.<Number>();
		switch (direction) {
			case 0:
				rect[1]=rect[3]=rect[9]=rect[1] + arrowSize;
				path.data=rect.slice(0, 2).concat(rect.slice(2), new <Number>[x + (width >> 1), y]);
				break;
			case 1:
				rect[2]=rect[4]=rect[2] - arrowSize;
				path.data=rect.slice(0, 4).concat(rect.slice(4), new <Number>[x + width, y + (height >> 1)]);
				break;
			case 2:
				rect[5]=rect[7]=rect[5] - arrowSize;
				path.data=rect.slice(0, 6).concat(rect.slice(6), new <Number>[x + (width >> 1), y + height]);
				break;
			case 3:
				rect[0]=rect[6]=rect[8]=rect[0] + arrowSize;
				path.data=rect.slice(0, 8).concat(rect.slice(8), new <Number>[x, y + (height >> 1)]);
				break;
		}
		return path;
	}

	//==========================================================================================
	// rect
	//==========================================================================================
	private static const RECT_COMMAND:Vector.<int>=new <int>[1, 2, 2, 2, 2];

	/** 네모 상자의 path 를 만든다 */
	public static function rect(x:Number, y:Number, width:Number, height:Number):GraphicsPath {
		var path:GraphicsPath=new GraphicsPath();
		path.commands=RECT_COMMAND;
		if (!path.data)
			path.data=new Vector.<Number>(10, true);
		path.data[0]=x;
		path.data[1]=y;
		path.data[2]=x + width;
		path.data[3]=y;
		path.data[4]=x + width;
		path.data[5]=y + height;
		path.data[6]=x;
		path.data[7]=y + height;
		path.data[8]=x;
		path.data[9]=y;

		return path;
	}

	//==========================================================================================
	// tail box
	//==========================================================================================
	private static const TAIL_BOX_COMMAND:Vector.<int>=new <int>[1, 2, 2, 2, 2, 2, 2, 2];

	/** 말풍선 형태의 상자를 만든다 */
	public static function tailBox(x:Number, y:Number, width:Number, height:Number, tp:Point, ts:int):GraphicsPath {
		var xcase:int;
		var ycase:int;
		if (tp.x < x) {
			xcase=0;
		} else if (tp.x > x + width) {
			xcase=2;
		} else {
			xcase=1;
		}
		if (tp.y < y) {
			ycase=0;
		} else if (tp.y > y + height) {
			ycase=2;
		} else {
			ycase=1;
		}

		var draw:int=(xcase + ycase) % 2;
		if (draw < 1)
			return rect(x, y, width, height);

		var path:GraphicsPath=new GraphicsPath();
		path.commands=TAIL_BOX_COMMAND;
		path.data=new Vector.<Number>();

		path.data.push(x, y);
		if (xcase == 1 && ycase == 0) {
			if (tp.x < (ts >> 1) + x)
				tp.x=(ts >> 1) + x;
			if (tp.x > x + width - (ts >> 1))
				tp.x=x + width - (ts >> 1);
			path.data.push(tp.x - (ts >> 1), y, tp.x, tp.y, tp.x + (ts >> 1), y, x + width, y);
		} else {
			path.data.push(x + width, y);
		}
		if (xcase == 2 && ycase == 1) {
			if (tp.y < (ts >> 1) + y)
				tp.y=(ts >> 1) + y;
			if (tp.y > y + height - (ts >> 1))
				tp.y=y + height - (ts >> 1);
			path.data.push(x + width, tp.y - (ts >> 1), tp.x, tp.y, x + width, tp.y + (ts >> 1), x + width, y + height);
		} else {
			path.data.push(x + width, y + height);
		}
		if (xcase == 1 && ycase == 2) {
			if (tp.x < (ts >> 1) + x)
				tp.x=(ts >> 1) + x;
			if (tp.x > x + width - (ts >> 1))
				tp.x=x + width - (ts >> 1);
			path.data.push(tp.x + (ts >> 1), y + height, tp.x, tp.y, tp.x - (ts >> 1), y + height, x, y + height);
		} else {
			path.data.push(x, y + height);
		}
		if (xcase == 0 && ycase == 1) {
			if (tp.y < (ts >> 1) + y)
				tp.y=(ts >> 1) + y;
			if (tp.y > y + height - (ts >> 1))
				tp.y=y + height - (ts >> 1);
			path.data.push(x, tp.y + (ts >> 1), tp.x, tp.y, x, tp.y - (ts >> 1), x, y);
		} else {
			path.data.push(x, y);
		}

		return path;
	}

	//==========================================================================================
	// round rect
	//==========================================================================================
	private static const ROUND_RECT_COMMAND:Vector.<int>=new <int>[1, 2, 3, 2, 3, 2, 3, 2, 3];

	/** 둥근 모서리를 가진 상자를 만든다 */
	public static function roundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number,
									 ellipseHeight:Number):GraphicsPath {
		var path:GraphicsPath=new GraphicsPath();
		path.commands=ROUND_RECT_COMMAND;
		if (!path.data)
			path.data=new Vector.<Number>(26, true);
		var x0:Number=x;
		var x1:Number=x + ellipseWidth;
		var x2:Number=x + width - ellipseWidth;
		var x3:Number=x + width;
		var y0:Number=y;
		var y1:Number=y + ellipseHeight;
		var y2:Number=y + height - ellipseHeight;
		var y3:Number=y + height;
		path.data[0]=x1;
		path.data[1]=y0;
		path.data[2]=x2;
		path.data[3]=y0;
		path.data[4]=x3;
		path.data[5]=y0;
		path.data[6]=x3;
		path.data[7]=y1;
		path.data[8]=x3;
		path.data[9]=y2;
		path.data[10]=x3;
		path.data[11]=y3;
		path.data[12]=x2;
		path.data[13]=y3;
		path.data[14]=x1;
		path.data[15]=y3;
		path.data[16]=x0;
		path.data[17]=y3;
		path.data[18]=x0;
		path.data[19]=y2;
		path.data[20]=x0;
		path.data[21]=y1;
		path.data[22]=x0;
		path.data[23]=y0;
		path.data[24]=x1;
		path.data[25]=y0;

		return path;
	}

	//==========================================================================================
	// distort triangle path
	//==========================================================================================
	private static const DISTORT_INDICES:Vector.<int>=new <int>[0, 1, 2, 1, 3, 2];
	private static const DISTORT_UVT_DATA:Vector.<Number>=new <Number>[0, 0, 1, 0, 0, 1, 1, 1];

	/** distort, skew 형태의 triangie path 를 만든다 */
	public static function distort(tlX:Number, tlY:Number, trX:Number, trY:Number, dlX:Number, dlY:Number, drX:Number,
								   drY:Number):GraphicsTrianglePath {
		var path:GraphicsTrianglePath=new GraphicsTrianglePath();
		var v:Vector.<Number>=path.vertices ? path.vertices : new Vector.<Number>(8, true);
		v[0]=tlX;
		v[1]=tlY;
		v[2]=trX;
		v[3]=trY;
		v[4]=dlX;
		v[5]=dlY;
		v[6]=drX;
		v[7]=drY;
		path.vertices=v;
		path.indices=DISTORT_INDICES;
		path.uvtData=DISTORT_UVT_DATA;

		return path;
	}

	//==========================================================================================
	// donut
	//==========================================================================================
	/** 도넛 형태의 path 를 만든다 */
	public static function donut(x:Number, y:Number, radius:Number, innerRadius:Number, startDeg:Number, endDeg:Number):GraphicsPath {
		var path:GraphicsPath=new GraphicsPath();

		// (degree) start 와 end 를 계산해서 그릴 각도를 구한다.
		var arc:Number=endDeg > startDeg ? endDeg - startDeg : 360 - startDeg + endDeg;

		//		if (startDeg === endDeg || arc === 360) {
		//			return fulldonut(x, y, radius, innerRadius, path);
		//		}

		// segs 각도를 45 로 나누어서 등분을 결정한다.
		var s:int=Math.ceil(arc / 45);
		// theta : radian 등분의 갯수 단위로 radian 이 얼마만큼 증가할지 구한다.
		var th:Number=((arc / s) / 180) * Math.PI;
		// angle : radian 시작 radian 을 계산한다.
		var a:Number=(startDeg / 180) * Math.PI;

		// GraphicsPath 의 command, data
		var outCmd:Vector.<int>=new Vector.<int>();
		var outData:Vector.<Number>=new Vector.<Number>();
		var inCmd:Vector.<int>=new Vector.<int>();
		var inData:Vector.<Number>=new Vector.<Number>();

		// 외부 최초점을 moveTo 로 옮겨준다.
		outCmd.push(1);
		outData.push(x + radius * Math.cos(a), y + radius * Math.sin(a));
		inCmd.push(3);
		inData.push(x + innerRadius * Math.cos(a), y + innerRadius * Math.sin(a));
		// controlAngle : radian 컨트롤 점의 radian angle
		var ca:Number;

		// draw
		while (--s >= 0) {
			a+=th;
			ca=a - (th / 2);
			outCmd.push(3);
			outData.push(x + (radius / Math.cos(th / 2)) * Math.cos(ca), y + (radius / Math.cos(th / 2)) * Math.sin(ca),
																	x + radius * Math.cos(a), y + radius * Math.sin(a));
			inCmd.unshift(3);
			inData.unshift(x + innerRadius * Math.cos(a), y + innerRadius * Math.sin(a),
													  x + (innerRadius / Math.cos(th / 2)) * Math.cos(ca),
													  y + (innerRadius / Math.cos(th / 2)) * Math.sin(ca));
		}
		// 내부 최초점을 lineTo 로 바꿔준다.
		inCmd[0]=2;
		// 내부 마지막점과 외부 최초점을 연결하는 lineTo 를 설정해준다.
		inCmd.push(2);
		inData.push(outData[0], outData[1]);
		// 외부 데이터 + 내부 데이터 
		outCmd=outCmd.concat(inCmd);
		outData=outData.concat(inData);

		path.commands=outCmd;
		path.data=outData;

		return path;
	}

	//	public static function fulldonut(x:Number, y:Number, radius:Number, innerRadius:Number):GraphicsPath {
	//		if (!path)
	//			path=new GraphicsPath;
	//
	//		return path;
	//	}
	//
	//	public static function radius(x:Number, y:Number, radius:Number):GraphicsPath {
	//		if (!path)
	//			path=new GraphicsPath;
	//
	//		var cmd:Vector.<int>=new Vector.<int>;
	//		var data:Vector.<Number>=new Vector.<Number>;
	//		cmd.push(1);
	//		data.push(x, y - radius);
	//		cmd.push(
	////		GraphicsPathCommand.
	//		
	//
	//		return path;
	//	}

	//==========================================================================================
	// line
	//==========================================================================================
	private static const LINE_COMMAND:Vector.<int>=new <int>[1, 2];

	/** 간단한 line path 를 만든다 */
	public static function line(x0:Number, y0:Number, x1:Number, y1:Number):GraphicsPath {
		var path:GraphicsPath=new GraphicsPath();
		path.commands=LINE_COMMAND;
		if (!path.data)
			path.data=new Vector.<Number>(4, true);
		path.data[0]=x0;
		path.data[1]=y0;
		path.data[2]=x1;
		path.data[3]=y1;

		return path;
	}

	//==========================================================================================
	// circle
	//==========================================================================================
	/**
	 * @add lyj
	 * 원 형태의 path 를 만든다
	 */
	public static function circle(x:Number, y:Number, radius:Number):GraphicsPath {
		var path:GraphicsPath=new GraphicsPath();
		// (degree) start 와 end 를 계산해서 그릴 각도를 구한다.
		var arc:Number=360;
		// segs 각도를 45 로 나누어서 등분을 결정한다.
		var s:int=Math.ceil(arc / 45);
		// theta : radian 등분의 갯수 단위로 radian 이 얼마만큼 증가할지 구한다.
		var th:Number=((arc / s) / 180) * Math.PI;
		// angle : radian 시작 radian 을 계산한다.
		var a:Number=0;
		// GraphicsPath 의 command, data
		var cmd:Vector.<int>=new Vector.<int>();
		var data:Vector.<Number>=new Vector.<Number>();
		// 외부 최초점을 moveTo 로 옮겨준다.
		cmd.push(1);
		data.push(x + radius * Math.cos(a), y + radius * Math.sin(a));
		// controlAngle : radian 컨트롤 점의 radian angle
		var ca:Number;

		// draw
		while (--s >= 0) {
			a+=th;
			ca=a - (th / 2);
			cmd.push(3);
			data.push(x + (radius / Math.cos(th / 2)) * Math.cos(ca), y + (radius / Math.cos(th / 2)) * Math.sin(ca),
																 x + radius * Math.cos(a), y + radius * Math.sin(a));
		}

		path.commands=cmd;
		path.data=data;

		return path;
	}
}
}
