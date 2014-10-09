package ssen.components.mxChartSupportClasses._showcase_.utils {

import mx.formatters.NumberFormatter;

/** 여러 숫자 단위들을 Text Formatting 시킨다 */
public class UnitConverter {

	/**
	 * 퍼센트 값을 포맷팅한다
	 *
	 * @param n 대상 숫자
	 * @param precision 강제로 유지시킬 소숫점 자리수
	 */
	public static function percentage(n:Number, precision:int=0):String {
		if (precision > 0) {
			n=Math.round(n * Math.pow(10, precision)) / Math.pow(10, precision);
			return wrap(n.toFixed(2));
		}

		return getFormatter().format(Math.round(n));
	}

	/**
	 * 건수를 포맷팅 한다
	 *
	 * @param n 대상 숫자
	 */
	public static function matter(n:int):String {
		return getFormatter().format(n);
	}

	/**
	 * 1억(Hundred Million) 단위로 나눠서 포맷팅 한다
	 *
	 * @param n 대상 숫자
	 * @param precision 강제로 유지시킬 소숫점 자리수
	 */
	public static function hm(n:Number, precision:int=0):String {
		if (precision > 0) {
			n=Math.round(n / (Math.pow(10, 8 - precision)));
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
	 * 차트 Axis에서 사용하는 숫자 포맷팅
	 *
	 * @param n 대상 숫자
	 * @param min 범위 최소값
	 * @param max 범위 최대값
	 * @param interval 범위내의 간격
	 */
	public static function fluidNum(n:Number, min:Number, max:Number, interval:Number):String {
		var precision:Number=0;
		var decimal:Number=Math.abs(interval) - Math.floor(Math.abs(interval));
		precision=decimal == 0 ? 1 : -Math.floor(Math.log(decimal) / Math.LN10);
		decimal=Math.abs(min) - Math.floor(Math.abs(min));
		precision=Math.max(precision, decimal == 0 ? 1 : -Math.floor(Math.log(decimal) / Math.LN10));
		var roundBase:Number=Math.pow(10, precision);
		var roundedValue:Number=Math.round(n * roundBase) / roundBase;

		return UnitConverter.num(roundedValue);
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
			formatter=new NumberFormatter;
		}

		return formatter;
	}

}
}
