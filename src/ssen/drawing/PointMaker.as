package ssen.drawingkit {
import com.greensock.easing.Linear;

public class PointMaker {

	/**
	 * 2차 베지어 포인트를 계산한다
	 *
	 * @param p1 시작지점
	 * @param p2 끝지점
	 * @param c 베지어 곡점
	 * @param current 현재 이동 지점
	 * @param total 이동 거리의 전체
	 *
	 * @return 현재 베지어 포인트 위치
	 */
	public static function quadraticBezier(p1:XY, p2:XY, c:XY, current:int, total:int):XY {
		if (current > total) {
			throw new Error("current 는 total 보다 작을 수 없습니다");
		}

		var p:XY=new XY;
		var s:Number=current / total;
		var s1:Number=1 - s;

		p.x=_quadraticBezier(p1.x, p2.x, c.x, s, s1);
		p.y=_quadraticBezier(p1.y, p2.y, c.y, s, s1);

		return p;
	}

	/**
	 * 2차 베지어 경로를 계산한다
	 * @param p1 시작지점
	 * @param p2 끝지점
	 * @param c 베지어 곡점
	 * @param step 나눌 단계
	 * @param ease Easing Function (TweenLite Easing Function)
	 *
	 * @return 베지어 경로
	 */
	public static function quadraticBeziers(p1:XY, p2:XY, c:XY, step:int, ease:Function=null):Vector.<XY> {
		if (ease === null) {
			ease=Linear.easeNone;
		}

		var result:Vector.<XY>=new Vector.<XY>(step + 1, true);
		var xy:XY;

		// t = 현재, d = 전체
		var t:int=-1;
		var d:int=step;
		var s:Number;
		var s1:Number;

		while (++t <= d) {
			s=ease(t, 0, 1, d);
			//			s=t / d;
			s1=1 - s;

			xy=new XY;
			xy.x=_quadraticBezier(p1.x, p2.x, c.x, s, s1);
			xy.y=_quadraticBezier(p1.y, p2.y, c.y, s, s1);

			result[t]=xy;
		}

		return result;
	}

	private static function _quadraticBezier(p1:Number, p2:Number, c:Number, s:Number, s1:Number):Number {
		return p1 * s1 * s1 + c * 2 * s * s1 + p2 * s * s;
	}

	/**
	 * 3차 베지어 포인트를 계산한다
	 *
	 * @param p1 시작지점
	 * @param p2 끝지점
	 * @param c1 베지어 곡점1
	 * @param c2 베지어 곡점2
	 * @param current 현재 이동 지점
	 * @param total 이동 거리의 전체
	 *
	 * @return 현재 베지어 포인트 위치
	 */
	public static function cubicBezier(p1:XY, p2:XY, c1:XY, c2:XY, current:int, total:int):XY {
		if (current > total) {
			throw new Error("current 는 total 보다 작을 수 없습니다");
		}

		var p:XY=new XY;
		var s:Number=current / total;
		var s1:Number=1 - s;

		p.x=_cubicBezier(p1.x, p2.x, c1.x, c2.x, s, s1);
		p.y=_cubicBezier(p1.y, p2.y, c1.y, c2.y, s, s1);

		return p;
	}

	/**
	 * 3차 베지어 경로를 계산한다
	 * @param p1 시작지점
	 * @param p2 끝지점
	 * @param c1 베지어 곡점1
	 * @param c2 베지어 곡점2
	 * @param step 나눌 단계
	 * @param ease Easing Function (TweenLite Easing Function)
	 *
	 * @return 베지어 경로
	 */
	public static function cubicBeziers(p1:XY, p2:XY, c1:XY, c2:XY, step:int, ease:Function=null):Vector.<XY> {
		if (ease === null) {
			ease=Linear.easeNone;
		}

		var result:Vector.<XY>=new Vector.<XY>(step + 1, true);
		var xy:XY;

		// t = 현재, d = 전체
		var t:int=-1;
		var d:int=step;
		var s:Number;
		var s1:Number;

		while (++t <= d) {
			s=ease(t, 0, 1, d);
			s1=1 - s;

			xy=new XY;
			xy.x=_cubicBezier(p1.x, p2.x, c1.x, c2.x, s, s1);
			xy.y=_cubicBezier(p1.y, p2.y, c1.y, c2.y, s, s1);

			result[t]=xy;
		}

		return result;
	}

	private static function _cubicBezier(p1:Number, p2:Number, c1:Number, c2:Number, s:Number, s1:Number):Number {
		return s1 * s1 * s1 * p1 + 3 * s * s1 * s1 * c1 + 3 * s * s * s1 * c2 + s * s * s * p2;
	}

	public static function line(p1:XY, p2:XY, current:int, total:int):XY {
		var p:XY=new XY;
		var s:Number=current / total;

		p.x=p1.x + ((p2.x - p1.x) * s);
		p.y=p1.y + ((p2.y - p1.y) * s);

		return p;
	}
}
}
