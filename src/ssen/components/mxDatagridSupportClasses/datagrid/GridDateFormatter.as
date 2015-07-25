package ssen.components.mxDatagridSupportClasses.datagrid {
import mx.formatters.Formatter;

import ssen.components.mxDatagridSupportClasses._showcase_.viewmodels.YYYYMMDD;

/** yyyymmdd 형태의 날짜를 포맷팅 해주는 Util Class */
public class GridDateFormatter extends Formatter {
	
	/**
	 * "yyyymmdd"를 "yyyy-mm-dd" 형태로 포맷팅 한다
	 *
	 * @param value 문자열 또는 숫자 형태의 "yyyymmdd" 데이터
	 */
	override public function format(value:Object):String {
		var yyyymmdd:YYYYMMDD = new YYYYMMDD(value);

		if (yyyymmdd.yyyymmdd < 20000000 || yyyymmdd.yyyymmdd > 21000000) {
			return "-";
		}

		return yyyymmdd.toString("YYYY-MM-DD");
	}
}
}
