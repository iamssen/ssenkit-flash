package ssen.components.animate {
import com.greensock.easing.Quad;

import ssen.animation.AnimationTrack;

// TODO remove this class when end of mobis project
[Deprecated(replacement=ssen.animation.AnimationTrack)]
public class AnimationTrack {
	public var start:Number;
	public var end:Number;
	public var ease:Function;

	public function AnimationTrack(start:Number = 0, end:Number = 1, ease:Function = null) {
		this.start = start;
		this.end = end;
		this.ease = ease || Quad.easeOut;
	}

	public function getTime(time:Number):Number {
		if (time < start) return NaN;
		if (time > end) time = end;
		var t:Number = (time - start) / (end - start);

		return ease(t, 0, 1, 1);
	}
}
}
