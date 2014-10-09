package ssen.components.mxDatagridSupportClasses.datagrid {
import mx.formatters.NumberFormatter;

/** 100단위 포맷팅 */
public class GridMillionFormatter extends NumberFormatter {
	
	/**
	 * 숫자를 100만 단위로 나눠서 포맷팅 시킨다
	 * 
	 * @param value 숫자가 아니면 "-"로 포맷팅 시킨다
	 */
	override public function format(value:Object):String {
		var n:Number=Number(value);

		if (isNaN(n)) {
			return "-";
		}

		return super.format(Math.round(Number(n / 1000000)));
	}


}
}
