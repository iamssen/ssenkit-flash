package ssen.common {
import ssen.devkit.CollectionPrinter;

public class Test__NumberFormatterUtils {
	[Test]
	public function test():void {
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
			ns.push(NumberFormatterUtils.__fluidNum(n, min, interval));
			n += interval;
		}

		return {
			start: start,
			end  : end,
			ns   : ns.join(', ')
		};
	}
}
}
