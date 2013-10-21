package ssen.datakit.ds {
import flash.utils.Dictionary;

import ssen.common.IDisposable;

/** 다수의 key 를 가지는 data 들을 관리해주는 data collection 구조체 (상속 구현 필수) */
public class MultipleKeyDataCollection implements IDisposable {
	private var pkeys:Vector.<String>;
	private var primary:Dictionary;
	private var table:Array;
	private var count:uint;
	private var primaryEnabled:Boolean;

	/**
	 * constructor
	 * @param primaryKeys 절대값을 가지는 primary key 들을 입력해준다
	 */
	public function MultipleKeyDataCollection(... primaryKeys) {
		init(primaryKeys);
	}

	public function dispose():void {
		pkeys=null;
		primary=null;
		table=null;
	}

	//----------------------------------------------------------------
	// initial
	//----------------------------------------------------------------
	private function init(primaryKeys:Array):void {
		table=[];
		count=0;

		if (primaryKeys.length > 0) {
			primary=new Dictionary;
			pkeys=new Vector.<String>(primaryKeys.length, true);

			var f:int=primaryKeys.length;
			var key:String;

			while (--f >= 0) {
				key=primaryKeys[f];
				primary[key]=new Dictionary;
				pkeys[f]=key;
			}

			primaryEnabled=true;
		}
	}

	/** 내부 데이터를 모두 삭제한다 (구조체의 정보는 유지) */
	final protected function _purge():void {
		var arr:Array=[];

		if (pkeys !== null && pkeys.length > 0) {
			var f:int=-1;
			var fmax:int=pkeys.length;
			while (++f < fmax) {
				arr[f]=pkeys[f];
			}
		}

		init(arr);
	}

	//----------------------------------------------------------------
	// backup and restore
	//----------------------------------------------------------------
	/** 현재 collection 내의 data 들을 배열 형태로 내보내준다 */
	final protected function _getSource():Array {
		return table;
	}

	/** 외부의 배열 형태 데이터를 가져와서 collection 에 복구해준다 */
	final protected function _restoreSource(t:Array):void {
		var key:String;

		table=[];
		count=0;
		if (primaryEnabled) {
			for (key in primary) {
				primary[key]=new Dictionary;
			}
		}

		var f:int=-1;
		var fmax:int=t.length;

		var row:Object;

		while (++f < fmax) {
			row=t[f];
			table[f]=row;

			if (primaryEnabled) {
				if (row) {
					for (key in row) {
						if (primary[key] !== undefined) {
							primary[key][row[key]]=f;
						}
					}
				}
			}

			if (row) {
				count++;
			}
		}
	}

	//----------------------------------------------------------------
	// crud
	//----------------------------------------------------------------
	/** create */
	final protected function _create(row:Object):int {
		var index:uint=table.length;
		var key:String;
		var cache:Object;
		var cacheLength:int;

		if (primaryEnabled) {
			cache={};
			cacheLength=0;

			for (key in row) {
				if (primary[key] !== undefined) {
					if (primary[key][row[key]] === undefined) {
						cache[key]=row[key];
						cacheLength++;
					} else {
						return -1;
					}
				}
			}
		}

		table[index]=row;

		if (primaryEnabled) {
			if (cacheLength > 0) {
				for (key in cache) {
					primary[key][cache[key]]=index;
				}
			}
		}

		count++;

		return index;
	}

	/** read */
	final protected function _read(index:int):Object {
		return table[index];
	}

	/** delete */
	final protected function _delete(index:int):Object {
		if (table[index]) {
			var row:Object=table[index];

			if (primaryEnabled) {
				var f:int=pkeys.length;
				var key:String;

				while (--f >= 0) {
					key=pkeys[f];

					if (table[key] !== undefined && primary[key][table[key]] !== undefined) {
						delete primary[key][table[key]];
					}
				}
			}

			table[index]=null;
			count--;

			return row;
		}

		return null;
	}

	/** update */
	final protected function _update(index:int, fetch:Object):Object {
		if (table[index]) {
			var row:Object=table[index];
			var key:String;

			if (primaryEnabled) {
				var f:int=pkeys.length;
				var cache:Object={};

				while (--f >= 0) {
					key=pkeys[f];

					// fetch 될 데이터에 primary data key 가 있으면 
					if (fetch[key] !== undefined) {
						// primary data cache 에 fetch 될 데이터의 값이 있으면 
						if (primary[key][fetch[key]] !== undefined) {
							// 그 값이 update 할 index 와 다르다면
							if (primary[key][fetch[key]] !== index) {
								// 다른 primary data 를 침해하므로 실행 취소
								return null;
							}
						}

						cache[key]=row[key];
					}
				}
			}

			for (key in fetch) {
				row[key]=fetch[key];
			}

			if (primaryEnabled) {
				for (key in cache) {
					delete primary[key][cache[key]];
					primary[key][row[key]]=index;
				}
			}

			return row;
		}

		return null;
	}

	//----------------------------------------------------------------
	// info
	//----------------------------------------------------------------
	/** 저장된 데이터의 갯수 */
	final public function get length():int {
		return count;
	}

	/** @private */
	final protected function getTablelength():int {
		return table.length;
	}

	//----------------------------------------------------------------
	// search
	//----------------------------------------------------------------
	/**
	 * 데이터를 찾는다
	 *
	 * @return indices
	 */
	final protected function _find(query:Object):Vector.<int> {
		var result:Vector.<int>=new Vector.<int>;
		var key:String;
		var keys:Array=[];

		for (key in query) {
			keys.push(key);
		}


		var f:int=table.length;
		var s:int;
		var row:Object;
		var valid:Boolean;

		while (--f >= 0) {
			row=table[f];
			
			if (row===null) {
				continue;
			}
			
			valid=true;

			s=keys.length;
			while (--s >= 0) {
				key=keys[s];
				if (row[key] !== query[key]) {
					valid=false;
					break;
				}
			}

			if (valid) {
				result.push(f);
			}
		}

		return result;
	}

	/**
	 * primary key 를 사용해서 데이터를 찾는다 (빠르다)
	 *
	 * @return index
	 */
	final protected function _findPrimary(key:String, value:Object):int {
		if (primaryEnabled && primary[key][value] !== undefined) {
			return primary[key][value];
		}

		return -1;
	}
}
}
