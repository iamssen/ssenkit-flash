package ssen.components.base.renderHelpers {
import com.greensock.TweenLite;

import ssen.common.IDisposable;

public class Animation implements IDisposable {
	private var tween:TweenLite;

	public var ready:Function;
	public var animate:Function;
	public var render:Function;

	public var duration:Number = 3;

	public function start():void {
		if (render === null) {
			throw new Error("undefined render() function");
		}

		ready();

		if (animate === null || duration <= 0) {
			render();
			return;
		}

		_t = 0;
		tween = TweenLite.to(this, duration, {t: 1, onComplete: stop});
	}

	public function stop():void {
		if (tween && tween.active) {
			render();
			tween.kill();
		}
		tween = null;
	}

	//----------------------------------------------------------------
	// tweener 가 사용하는 property
	//----------------------------------------------------------------
	//---------------------------------------------
	// t
	//---------------------------------------------
	private var _t:Number;

	/** @private t */
	public function get t():Number {
		return _t;
	}

	/** @private */
	public function set t(value:Number):void {
		_t = value;
		animate(_t);
	}

	public function dispose():void {
		stop();
		ready = null;
		animate = null;
		render = null;
	}
}
}
