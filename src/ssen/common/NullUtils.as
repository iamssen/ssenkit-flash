package ssen.common {

/** 공백 값들을 대치 해주는 기능들 */
public class NullUtils {

	/**
	 * 해당 값이 null 이나 undefined 인지 확인한다
	 * @param value 체크할 값
	 */
	public static function isNull(value:*):Boolean {
		return value === null || value === undefined;
	}

	/**
	 * null 이나 undefined 인 경우 기본값으로 대치해준다
	 * @param value 체크할 값
	 * @param defaultValue 대치할 값
	 */
	public static function nullTo(value:*, defaultValue:*):* {
		return isNull(value) ? defaultValue : value;
	}

	/** @copy StringUtils#blankTo() */
	public static function blankTo(value:*, defaultValue:String, checkSpaces:Boolean = false):String {
		return StringUtils.blankTo(value, defaultValue, checkSpaces);
	}

	/** @copy MathUtils#nanTo() */
	public static function nanTo(value:*, defaultValue:Number):Number {
		return MathUtils.nanTo(value, defaultValue);
	}
}
}
