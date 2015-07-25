package ssen.animation {
import com.greensock.TweenNano;

import ssen.common.IDisposable;

public class Animation implements IDisposable {
	//----------------------------------------------------------------
	// states
	//----------------------------------------------------------------
	private var tween:TweenNano;

	//----------------------------------------------------------------
	// properties
	//----------------------------------------------------------------
	/** () => void */
	public var ready:Function;

	/** (current:second, total:second) => void */
	public var animate:Function;

	/** () => void */
	public var render:Function;

	/** second */
	public var duration:Number = 3;

	//----------------------------------------------------------------
	// methods
	//----------------------------------------------------------------
	public function start():void {
		stop();

		if (render === null) {
			throw new Error("undefined render() function");
		}

		ready();

		if (animate === null || duration <= 0) {
			render();
			return;
		}

		_t = 0;
		tween = TweenNano.to(this, duration, {t: 1, onComplete: stop});
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

	//----------------------------------------------------------------
	// dispose
	//----------------------------------------------------------------
	public function dispose():void {
		stop();
		ready = null;
		animate = null;
		render = null;
	}
}
}
