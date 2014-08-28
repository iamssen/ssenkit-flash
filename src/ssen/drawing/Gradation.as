package ssen.drawingkit {
import com.greensock.easing.Linear;

public class Gradation {
	/**
	 * rgb 와 rgb 사이의 gradation color 를 뽑는다
	 *
	 * @param start 시작색
	 * @param end 끝색
	 * @param current 현재 시점
	 * @param total 전체 시점
	 */
	public static function getGradationColor(start:RGB, end:RGB, current:Number, total:Number):RGB {
		if (current > total) {
			throw new Error("current 는 total 보다 작을 수 없습니다");
		}

		var r:RGB=new RGB;
		var s:Number=current / total;

		r.r=start.r + ((end.r - start.r) * s);
		r.g=start.g + ((end.g - start.g) * s);
		r.b=start.b + ((end.b - start.b) * s);

		return r;
	}

	/**
	 * rgb 와 rgb 사이의 gradation color 들을 뽑아낸다.
	 *
	 * @param start 시작색
	 * @param end 끝색
	 * @param step 나눌 단계수
	 * @param ease Easing function
	 */
	public static function getGradationColors(start:RGB, end:RGB, step:int, ease:Function=null):Vector.<RGB> {
		if (ease === null) {
			ease=Linear.easeNone;
		}

		// 시작값
		var b:RGB=start.clone();

		// 증가량 (최종값이 아니라, 최종 증가량 이다)
		var c:RGB=end.clone();
		c.r=c.r - b.r;
		c.g=c.g - b.g;
		c.b=c.b - b.b;

		var result:Vector.<RGB>=new Vector.<RGB>(step + 1, true);
		var rgb:RGB;

		// 전체 시간
		var d:int=step - 1;
		// 현재 시간
		var t:int=step + 1;

		while (--t >= 0) {
			rgb=new RGB;
			rgb.r=ease(t, b.r, c.r, d);
			rgb.g=ease(t, b.g, c.g, d);
			rgb.b=ease(t, b.b, c.b, d);
			result[t]=rgb;
		}

		return result;
	}
}
}
