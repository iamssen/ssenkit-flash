package ssen.datakit.ds {

/** 입력한 요소들 중에서 랜덤한 값을 뽑아낸다 */
public class RandomDataCollection {

	private var _values:Array;
	private var _indices:Vector.<int>;
	private var _current:int;

	public function RandomDataCollection(values:Array=null) {
		setValues(values);
	}

	/** 요소들을 재입력한다 */
	public function setValues(values:Array):void {
		if (values === null) {
			return;
		}

		var ids:Vector.<int>=new Vector.<int>(values.length, true);
		var f:int=values.length;
		while (--f >= 0) {
			ids[f]=f;
		}

		_values=values;
		_indices=ids.sort(sort);
		_current=-1;
	}

	/** 랜덤값을 가져온다 */
	public function get():* {
		if (_values === null) {
			return null;
		}

		_current++;
		return _values[_indices[_current % _indices.length]];
	}

	private function sort(a:int, b:int):int {
		if (Math.random() < 0.5) {
			return -1;
		}

		return 1;
	}
}
}
