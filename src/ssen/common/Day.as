package ssen.common {
import mx.utils.StringUtil;

/** 시간을 제외한 날짜 계산을 할 때 사용 */
public class Day {
	/** microtime 1000 */
	private static const SECOND:int = 1000;

	/** microtime 1000 * 60 */
	private static const MINUTE:int = 60000;

	/** microtime 1000 * 60 * 60 */
	private static const HOUR:int = 3600000;

	/** microtime 1000 * 60 * 60 * 24 */
	private static const DAY:int = 86400000;

	/** microtime 1000 * 60 * 60 * 24 * 7 */
	private static const WEEK:int = 604800000;

	private var d:Date;

	public function Day(date:Date = null) {
		this.date = date;
	}

	/** 현재 날짜 */
	public function get date():Date {
		return d;
	}

	public function set date(date:Date):void {
		d = (date !== null) ? DateUtils.dropTimes(date) : DateUtils.dropTimes(new Date);
	}

	//----------------------------------------------------------------
	// equal
	//----------------------------------------------------------------
	/** 같은 날 체크 */
	public function equal(day:Day):Boolean {
		return day.d.time === d.time;
	}

	/** 같은 달 체크 */
	public function equalMonth(day:Day):Boolean {
		return day.d.fullYear === d.fullYear && day.d.month === d.month;
	}

	/** 같은 주 체크 */
	public function equalWeek(day:Day):Boolean {
		return getFirstDayOfWeek().equal(day.getFirstDayOfWeek());
	}

	//----------------------------------------------------------------
	// info
	//----------------------------------------------------------------
	/** 이번달의 몇째주 */
	public function get weekOfMonth():int {
		return ((d.date + getFirstDayOfMonth().d.day - 1) / 7) + 1;
	}

	/** 올해의 몇째주 */
	public function get weekOfYear():int {
		var firstDay:Date = new Date(d.fullYear, 0, 1);
		var dayOf:int = ((d.time - firstDay.time) / DAY) + 1;
		return ((dayOf + firstDay.day - 1) / 7) + 1;
	}

	/** 올해의 몇째일 */
	public function get dayOfYear():int {
		var firstDay:Date = new Date(d.fullYear, 0, 1);
		return ((d.time - firstDay.time) / DAY) + 1;
	}

	//----------------------------------------------------------------
	// clone and move
	//----------------------------------------------------------------
	/** 현재 날짜를 복제한다 */
	public function clone():Day {
		var day:Day = new Day;
		day.d.time = d.time;
		return day;
	}

	/** 내일 */
	public function getNextDay():Day {
		var day:Day = clone();
		day.d.time += DAY;
		return day;
	}

	/** 어제 */
	public function getPrevDay():Day {
		var day:Day = clone();
		day.d.time -= DAY;
		return day;
	}

	/** 이번달을 첫째날 */
	public function getFirstDayOfMonth():Day {
		var day:Day = clone();
		day.d.date = 1;
		return day;
	}

	/** 이번달의 마지막날 */
	public function getLastDayOfMonth():Day {
		var day:Day = clone();
		day.d.date = DateUtils.getLastDay(day.d.fullYear, day.d.month);
		return day;
	}

	/** 이번주의 첫째날 */
	public function getFirstDayOfWeek():Day {
		var day:Day = clone();
		day.d.time -= DAY * day.d.day;
		return day;
	}

	/** 이번주의 마지막날 */
	public function getLastDayOfWeek():Day {
		var day:Day = clone();
		day.d.time += DAY * (6 - day.d.day);
		return day;
	}

	/** 다음달 */
	public function getNextMonth():Day {
		var day:Day = clone();

		if (day.d.month >= 11) {
			day.d.month = 0;
			day.d.fullYear++;
		} else {
			day.d.month++;
		}

		return day;
	}

	/** 지난달 */
	public function getPrevMonth():Day {
		var day:Day = clone();

		if (day.d.month <= 0) {
			day.d.month = 11;
			day.d.fullYear--;
		} else {
			day.d.month--;
		}

		return day;
	}

	/** 다음주 */
	public function getNextWeek():Day {
		var day:Day = clone();
		day.d.time += WEEK;
		return day;
	}

	/** 지난주 */
	public function getPrevWeek():Day {
		var day:Day = clone();
		day.d.time -= WEEK;
		return day;
	}

	/** 내년 */
	public function getNextYeay():Day {
		var day:Day = clone();
		day.d.fullYear += 1;
		return day;
	}

	/** 작년 */
	public function getPrevYeay():Day {
		var day:Day = clone();
		day.d.fullYear -= 1;
		return day;
	}

	//----------------------------------------------------------------
	// 
	//----------------------------------------------------------------
	private static const days:Vector.<String> = new <String>["일", "월", "화", "수", "목", "금", "토"];

	/** @private */
	public function toString():String {
		return StringUtil.substitute('[Day {0}년 {1}월 {2}일 {3}요일]', date.fullYear, date.month + 1, date.date, days[date.day]);
	}
}
}
