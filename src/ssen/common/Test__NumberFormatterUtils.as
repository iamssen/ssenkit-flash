package ssen.common {
import mx.utils.StringUtil;

import ssen.devkit.CollectionPrinter;

public class Test__NumberFormatterUtils {
	[Test]
	public function test():void {
		//		func(1 / 3, 0, 0.2);
		//		func(1 / 3, 0, 1.2);
		//
		//		dynamicDecimalPrecision(0.1);
		//		dynamicDecimalPrecision(0.01);
		//		dynamicDecimalPrecision(0.001);
		//		dynamicDecimalPrecision(0.0001);
		//		dynamicDecimalPrecision(0.00001);
		//		dynamicDecimalPrecision(0.000001);
		//		dynamicDecimalPrecision(0.346634);
		//		dynamicDecimalPrecision(0.04);
		//		dynamicDecimalPrecision(0.05);
		//		dynamicDecimalPrecision(0.06);

		CollectionPrinter.printTable([
			fluidnum(0, 1, 8),
			fluidnum(0, 0.1, 8),
			fluidnum(0, 100, 8),
			fluidnum(0, 100, 10),
			fluidnum(0.3, 0.35, 8)
		], new <String>["start", "end", "ns"]);
	}

	private static function fluidnum(start:Number, end:Number, separate:int):Object {
		var min:Number = start;
		var interval:Number = (end - start) / separate;
		var n:Number = start;
		var ns:Vector.<Number> = new <Number>[];

		var f:int = -1;
		while (++f <= separate) {
			ns.push(func(n, min, interval));
			n += interval;
		}

		return {
			start: start,
			end  : end,
			ns   : ns.join(', ')
		};
	}

	private static function func(n:Number, min:Number, interval:Number):Number {
		var precision:Number;
		var points:Number;

		// interval의 0을 센다
		points = Math.abs(interval) - Math.floor(Math.abs(interval));
		precision = points == 0 ? 1 : -Math.floor(Math.log(points) / Math.LN10);

		// min의 0을 센다
		points = Math.abs(min) - Math.floor(Math.abs(min));
		precision = Math.max(precision, points == 0 ? 1 : -Math.floor(Math.log(points) / Math.LN10));

		// 라운딩 시킨다
		var roundBase:Number = Math.pow(10, precision);
		var rounded:Number = Math.round(n * roundBase) / roundBase;

		return rounded;
	}
}
}
