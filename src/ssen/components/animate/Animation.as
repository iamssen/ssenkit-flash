package ssen.components.animate {
import com.greensock.TweenLite;

import ssen.animation.Animation;

[Deprecated(replacement=ssen.animation.Animation)]
public class Animation {

	private var tween:TweenLite;
	private var func:Function;
	public var duration:Number;

	//---------------------------------------------
	// animate
	//---------------------------------------------
	private var _animate:Number;

	/** @private animate */
	public function get animate():Number {
		return _animate;
	}

	/** @private */
	public function set animate(value:Number):void {
		_animate = value;
		func(value);
	}

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function Animation(duration:Number = 3) {
		this.duration = duration;
	}

	public function start(func:Function):void {
		this.func = func;
		_animate = 0;
		tween = TweenLite.to(this, duration, {animate: 1, onComplete: stop});
	}

	public function stop():void {
		if (tween && tween.active) {
			tween.kill();
		}
		tween = null;
		this.func = null;
	}
}
}
