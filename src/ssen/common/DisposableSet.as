package ssen.common {
public class DisposableSet implements IDisposable {
	private var list:Vector.<IDisposable> = new Vector.<IDisposable>;

	public function add(disposble:IDisposable):void {
		list.push(disposble);
	}

	public function dispose():void {
		var f:int = list.length;
		while (--f >= 0) {
			list[f].dispose();
		}
		list.length = 0;
	}
}
}
