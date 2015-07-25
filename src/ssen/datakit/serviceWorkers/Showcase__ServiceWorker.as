package ssen.datakit.serviceWorkers {
import spark.components.Group;

public class Showcase__ServiceWorker extends Group {
	private var f:int;
	private var fmax:int;

	public function Showcase__ServiceWorker() {
		f = -1;
		fmax = 10;
		next();
	}

	private function next():void {
		if (++f < fmax) {
			var unit:URLStreamAsyncUnit = new URLStreamAsyncUnit;
			unit.result = resultHandler;
			unit.load("http://localhost:9080/login.jsp");
		} else {
			trace("Showcase__ServiceWorker.next() complete");
		}
	}

	private function resultHandler(result:String):void {
		//		trace("Showcase__ServiceWorker.complete()", result.length);
		next();
	}
}
}
