package ssen.devkit {
import avmplus.getQualifiedClassName;

import ssen.common.StringUtils;

public class Assert {
	public static function equals(... args):void {
		var v:Object=args[0];
		var f:int=0;
		var fmax:int=args.length;
		while (++f < fmax) {
			if (v != args[f]) {
				throw e('not equals {0}', args.join(", "));
			}
		}
	}

	public static function notEqual(value:*, isNotEqual:*):void {
		if (value == isNotEqual) {
			throw e('{0} is equal {1}', value, isNotEqual);
		}
	}

	public static function typeis(value:*, type:Class):void {
		if (value is type) {
		} else {
			throw e('{0} isn\'t {1}', value, getQualifiedClassName(type));
		}
	}

	public static function exist(value:*):void {
		if (value === null || value === undefined) {
			throw e('{0} isn\'t exist', value);
		}
	}

	public static function above(value:Number, than:Number):void {
		if (value <= than) {
			throw e('{0} isn\'t above than {1}', value, than);
		}
	}

	public static function below(value:Number, than:Number):void {
		if (value >= than) {
			throw e('{0} isn\'t below than {1}', value, than);
		}
	}

	public static function within(value:Number, min:Number, max:Number):void {
		if (value < min || value > max) {
			throw e('{0} isn\'t within {1}, {2}', value, min, max);
		}
	}

	public static function match(value:String, match:RegExp):void {
		if (!match.test(value)) {
			throw e('{0} isn\'t matched {1}', value, match.source);
		}
	}

	private static function e(format:String, ... args:Array):Error {
		return new Error(StringUtils.formatToString.apply(null, [format].concat(args)));
	}
}
}
