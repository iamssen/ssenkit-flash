package ssen.components.mxDatagridSupportClasses._showcase_.viewmodels {
import mx.formatters.DateFormatter;

/** 숫자형 년월일 데이터를 다룬다 */
public class YYYYMMDD {
	private var _yyyymmdd:int;
	private var _yyyy:int;
	private var _mm:int;
	private var _dd:int;

	public function YYYYMMDD(yyyymmdd:*) {
		var n:Number=Number(yyyymmdd);

		if (isNaN(n)) {
			var s:String=String(yyyymmdd).replace(/\D+/g, "");
			n=Number(s);

			if (isNaN(n)) {
				throw new Error("Unavaliable yyyymmdd format");
			} else {
				yyyymmdd=n;
			}
		}

		_yyyymmdd=yyyymmdd;

		var str:String=_yyyymmdd.toString();

		_yyyy=int(str.substr(0, 4));
		_mm=int(str.substr(4, 2));
		_dd=int(str.substr(6, 2));
	}

	//==========================================================================================
	// getters
	//==========================================================================================
	public function get yyyymmdd():int {
		return _yyyymmdd;
	}

	public function get yyyy():int {
		return _yyyy;
	}

	public function get mm():int {
		return _mm;
	}

	public function get dd():int {
		return _dd;
	}

	//==========================================================================================
	// utils
	//==========================================================================================
	/** Unixtime 형태의 시간값을 가져온다 */
	public function toDateTime():Number {
		var date:Date=new Date(_yyyy, _mm - 1, _dd, 0, 0, 0, 0);
		return date.time;
	}

	private static var date:Date=new Date;

	private static var formatter:DateFormatter=new DateFormatter;

	/**
	 * 문자로 변환한다
	 * @param formatString DateFormatter의 formatString 형태
	 */
	public function toString(formatString:String="YYYY-MM-DD"):String {
		date.fullYear=_yyyy;
		date.month=_mm - 1;
		date.date=_dd;
		date.hours=0;
		date.minutes=0;
		date.seconds=0;
		date.milliseconds=0;
		formatter.formatString=formatString;
		return formatter.format(date);
	}
}
}
