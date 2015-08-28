package ssen.common {
import mx.formatters.NumberFormatter;

/** Number Formatting Utils */
public class NumberFormatterUtils {
	public static function __num(n:Number, precision:int = 0):String {
		return __format(__round(n, precision));
	}

	public static function __fluidNum(n:Number, min:Number, interval:Number, minPrecision:int = -1, maxPrecision:int = -1):String {
		var precision:Number;
		var points:Number;

		// count 0 interval
		points = Math.abs(interval) - Math.floor(Math.abs(interval));
		precision = points == 0 ? 1 : -Math.floor(Math.log(points) / Math.LN10);

		// count 0 min and compare maximum 0 by interval
		points = Math.abs(min) - Math.floor(Math.abs(min));
		precision = Math.max(precision, points == 0 ? 1 : -Math.floor(Math.log(points) / Math.LN10));

		if (minPrecision > 0) {
			precision = Math.min(precision, minPrecision);
		} else if (maxPrecision > 0) {
			precision = Math.max(precision, maxPrecision);
		}

		return __format(__round(n, precision));
	}

	private static function __format(n:Number):String {
		return wrap(getFormatter().format(n));
	}

	public static function __round(n:Number, precision:Number = 0):Number {
		if (precision < 1) return Math.round(n);
		var base:Number = Math.pow(10, precision);
		return Math.round(n * base) / base;
	}

	/**
	 * 퍼센트 값을 포맷팅한다
	 *
	 * @param n 대상 숫자
	 * @param precision 강제로 유지시킬 소숫점 자리수
	 */
	[Deprecated(message="remove when end of project")]
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
	[Deprecated(message="remove when end of project")]
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
	[Deprecated(message="remove when end of project")]
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
	[Deprecated(message="remove when end of project")]
	public static function fluidM(n:Number, min:Number, max:Number, interval:Number):String {
		return fluidNum(n / 1000000, min / 1000000, max / 1000000, interval / 1000000);
	}

	/**
	 * 100만(Million) 단위로 나눠서 포맷팅 한다
	 *
	 * @param n 대상 숫자
	 */
	[Deprecated(message="remove when end of project")]
	public static function m(n:Number):String {
		return getFormatter().format(Math.round(Number(n / 1000000)));
	}

	/**
	 * 숫자를 포맷팅 한다
	 *
	 * @param n 대상 숫자
	 */
	[Deprecated(message="remove when end of project")]
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
	[Deprecated(message="remove when end of project")]
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
