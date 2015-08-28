package ssen.common {
import flashx.textLayout.conversion.TextConverter;
import flashx.textLayout.elements.TextFlow;

import mx.utils.StringUtil;

/** 문자열 관련 util */
public class StringUtils {

	/** 앞뒤 공백을 없애준다 */
	public static function clearBlank(text:String):String {
		return text.replace(/^\s*|\s*$/g, "");
	}

	/** 문자가 null 혹은 공백인지 확인 */
	public static function isBlank(str:String):Boolean {
		return str === null || str === "";
	}

	/**
	 * null 이나 undefined, 혹은 공백 문자열인 경우 기본값으로 바꿔준다
	 * @param value 체크할 값
	 * @param defaultValue 대치할 값
	 * @param checkSpaces 공백문자들로만 이루어진 경우를 위해 공백문자를 제거하고 테스트 할지 여부
	 */
	public static function blankTo(value:*, defaultValue:String, checkSpaces:Boolean = false):String {
		if (value === null || value === undefined) {
			return defaultValue;
		}

		var str:String = value;

		if (str === "") {
			return defaultValue;
		}

		if (checkSpaces) {
			str = clearBlank(str);

			if (str === "") {
				return defaultValue;
			}
		}

		return value;
	}

	/** 값들을 정해진 형식에 맞게 출력한다 */
	[Deprecated(message="StringUtil.substitue 사용")]
	public static function formatToString(format:String, ...args):String {
		return StringUtil.substitute.apply(null, [format].concat(args));
		//		var f:int = args.length;
		//		while (--f >= 0) {
		//			format = format.replace(new RegExp("\\{" + f + "\\}", "g"), args[f]);
		//		}
		//		return format;
	}

	/** 문자열이 Rich Text Format 인지 확인한다 */
	public static function isRichText(str:String):Boolean {
		return str.indexOf("<") > -1;
	}

	/** 문자열을 TextFlow로 전환한다 */
	public static function convertTextFlow(str:String):TextFlow {
		var textFlow:TextFlow;

		if (isRichText(str)) {
			textFlow = TextConverter.importToFlow(str, TextConverter.TEXT_FIELD_HTML_FORMAT);
		} else {
			textFlow = TextConverter.importToFlow(str, TextConverter.PLAIN_TEXT_FORMAT);
		}

		return textFlow;
	}

	/** 특정 문자를 반복해서 곱한다 */
	public static function multiply(char:String, count:int, delimiter:String = ""):String {
		var str:Vector.<String> = new Vector.<String>(count, true);
		while (--count >= 0) {
			str[count] = char;
		}
		return str.join(delimiter);
	}

	/** 문자열이 특정 길이가 되도록 빈공간을 채워준다 */
	public static function fillSpace(text:String, toLength:int, fillCharacter:String = " "):String {
		var f:int = text.length - 1;
		while (++f < toLength) {
			text += fillCharacter;
		}
		return text;
	}
}
}
