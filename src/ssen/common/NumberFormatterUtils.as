package ssen.common {
import mx.formatters.NumberFormatter;

/** 각 종, 숫자들을 Formatting 시켜주는 Util */
public class NumberFormatterUtils {
	/*
	TODO 포맷팅 개선
	- n : Number
	- precision : int = -1 (fluid) | 0 ~ (fixed)
	- min : Number, max : Number, interval : Number, maxPrecision : int

	억 : 100000000 = 10 ^ 8
	 */

	public static function __num(n:Number, precision:int = 0, minPrecision:uint = -1, maxPrecision:uint = -1):String {
		var formatted:String;

		if (precision > 0) {
			n = Math.round(n * Math.pow(10, precision)) / Math.pow(10, precision);
			formatted = n.toFixed(precision);
		} else {
			formatted = getFormatter().format(Math.round(n));
		}

		return wrap(formatted);
	}

	public static function __fluidNum(n:Number, min:Number, max:Number, interval:Number, minPrecision:int = -1, maxPrecision:int = -1):String {
		var dynamicPrecision:Number;
		var decimalPoint:Number = Math.abs(interval) - Math.floor(Math.abs(interval));
		dynamicPrecision = decimalPoint == 0 ? 1 : -Math.floor(Math.log(decimalPoint) / Math.LN10);
		decimalPoint = Math.abs(min) - Math.floor(Math.abs(min));
		dynamicPrecision = Math.max(dynamicPrecision, decimalPoint == 0 ? 1 : -Math.floor(Math.log(decimalPoint) / Math.LN10));

		var roundBase:Number = Math.pow(10, dynamicPrecision);
		n = Math.round(n * roundBase) / roundBase;

		return "";
	}

	/**
	 * 퍼센트 값을 포맷팅한다
	 *
	 * @param n 대상 숫자
	 * @param precision 강제로 유지시킬 소숫점 자리수
	 */
	public static function percentage(n:Number, precision:int = 0):String {
		if (precision > 0) {
			n = Math.round(n * Math.pow(10, precision)) / Math.pow(10, precision);
			return wrap(n.toFixed(precision));
		}

		return getFormatter().format(Math.round(n));
	}

	/**
	 * 1억(Hundred Million) 단위로 나눠서 포맷팅 한다
	 *
	 * @param n 대상 숫자
	 * @param precision 강제로 유지시킬 소숫점 자리수
	 */
	public static function hm(n:Number, precision:int = 0):String {
		if (precision > 0) {
			n = Math.round(n / (Math.pow(10, 8 - precision)));
			return wrap(getFormatter().format(n / Math.pow(10, precision)));
		}

		return getFormatter().format(Math.round(Number(n / 100000000)));
	}

	/**
	 * 차트 Axis에서 사용하는 1억 단위 포맷팅
	 *
	 * @param n 대상 숫자
	 * @param min 범위 최소값
	 * @param max 범위 최대값
	 * @param interval 범위내의 간격
	 */
	public static function fluidHm(n:Number, min:Number, max:Number, interval:Number):String {
		return fluidNum(n / 100000000, min / 100000000, max / 100000000, interval / 100000000);
	}

	/**
	 * 차트 Axis에서 사용하는 100만 단위 포맷팅
	 *
	 * @param n 대상 숫자
	 * @param min 범위 최소값
	 * @param max 범위 최대값
	 * @param interval 범위내의 간격
	 */
	public static function fluidM(n:Number, min:Number, max:Number, interval:Number):String {
		return fluidNum(n / 1000000, min / 1000000, max / 1000000, interval / 1000000);
	}

	/**
	 * 100만(Million) 단위로 나눠서 포맷팅 한다
	 *
	 * @param n 대상 숫자
	 */
	public static function m(n:Number):String {
		return getFormatter().format(Math.round(Number(n / 1000000)));
	}

	/**
	 * 숫자를 포맷팅 한다
	 *
	 * @param n 대상 숫자
	 */
	public static function num(n:Number):String {
		return wrap(getFormatter().format(n));
	}

	/**
	 * 차트 Axis에서 사용하는 숫자 포맷팅
	 *
	 * @param n 대상 숫자
	 * @param min 범위 최소값
	 * @param max 범위 최대값
	 * @param interval 범위내의 간격
	 */
	public static function fluidNum(n:Number, min:Number, max:Number, interval:Number):String {
		// TODO 관련된 공식들의 이론을 파악해야 한다.
		// [ ] Math.LN10
		var precision:Number;
		var decimal:Number = Math.abs(interval) - Math.floor(Math.abs(interval));
		precision = decimal == 0 ? 1 : -Math.floor(Math.log(decimal) / Math.LN10);
		decimal = Math.abs(min) - Math.floor(Math.abs(min));
		precision = Math.max(precision, decimal == 0 ? 1 : -Math.floor(Math.log(decimal) / Math.LN10));
		var roundBase:Number = Math.pow(10, precision);
		var roundedValue:Number = Math.round(n * roundBase) / roundBase;

		return num(roundedValue);
	}

	//==========================================================================================
	// utils
	//==========================================================================================
	// .15 형태의 문자가 되는 것을 방지
	private static function wrap(s:String):String {
		return (s.charAt(0) === ".") ? "0" + s : s;
	}

	private static var formatter:NumberFormatter;

	private static function getFormatter():NumberFormatter {
		if (!formatter) {
			formatter = new NumberFormatter;
		}

		return formatter;
	}
}
}
