package ssen.common {

/** Date 관련 util */
public class DateUtils {
	//----------------------------------------------------------------
	// last days
	//----------------------------------------------------------------
	/** 월의 마지막 날짜를 가져온다 */
	public static function getLastDay(year:int, month:int):int {
		const LAST_DAYS:Vector.<int> = new <int>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

		var lastday:int;
		if (month != 1) {
			lastday = LAST_DAYS[month];
		} else {
			if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) {
				lastday = 29;
			} else {
				lastday = LAST_DAYS[month];
			}
		}
		return lastday;
	}

	//----------------------------------------------------------------
	// get date
	//----------------------------------------------------------------
	/** 시, 분, 초를 제거한다 */
	public static function dropTimes(date:Date):Date {
		return new Date(date.fullYear, date.month, date.date, 0, 0, 0, 0);
	}

	/** clone */
	public static function clone(date:Date):Date {
		var d:Date = new Date;
		d.time = date.time;
		return d;
	}

}
}
