package ssen.animation {
import com.greensock.easing.Quad;

public class AnimationTrack {
	/** second */
	public var start:Number;

	/** second */
	public var end:Number;

	public var ease:Function;

	public function AnimationTrack(start:Number = 0, end:Number = 1, ease:Function = null) {
		this.start = start;
		this.end = end;
		this.ease = ease || Quad.easeOut;
	}

	public function beforeTime(time:Number):Boolean {
		return time < start;
	}

	public function afterTime(time:Number):Boolean {
		return time > end;
	}

	public function getTime(time:Number):Number {
		if (time < start) time = start;
		if (time > end) time = end;
		var t:Number = (time - start) / (end - start); // 현재 값
		var b:Number = 0; // 시작 시간
		var c:Number = 1; // 증가량 (b에서 얼마나 변하는가)
		var d:Number = 1; // 전체 시간
		return ease(t, b, c, d);
	}
}
}
