package ssen.common {

[Exclude]

public class AsyncTest {

	[Test]
	public function whilist(done:Function):void {

		var i:int = -1;
		var imax:int = 10;
		var n:int = 0;

		function test():Boolean {
			return i < imax;
		}

		function task(callback:Function):void {
			n += 1;
		}

		Async.whilst(test, task, done);
	}
}
}
