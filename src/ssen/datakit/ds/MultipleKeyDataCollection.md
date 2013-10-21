# key 가 복수인 Dictionary 와 같은 데이터 구조체

`<node category1="a" category2="b" value="123" />` 과 같은 기준이 2개 이상인 데이터를 저장하고, key 를 통해 사용 가능하게 해주는 구조체.

바로는 사용이 안되고, 상속 구현을 해줘야 한다.

# 제공하는 api

- crud
	- `_create()`
	- `_read()`
	- `_update()`
	- `_delete()`
	
- search
	- `_find()`
	- `_findPrimary()` primary 로 지정된 key 를 통해 단일 항목을 찾는다. 속도가 빠르다. 
	
- info
	- `length`
	
- util
	- `_purge()`
	- `_getBackup()`
	- `_restoreBackup()`
	
# EventListenerCollection 예제

차후 일괄 삭제를 위해 event listener 를 관리하는 기능

event 와 listener 라는 두가지 key 를 통한 data 주소를 만들어낼 수 있다 

	class ListenerCollection extends MultipleKeyDataCollection {
		public function add(event:String, listener:Function):void {
			_create({event: event, listener: listener});
		}
	
		public function remove(event:String, listener:Function):void {
			var indices:Vector.<int>=_find({event: event, listener: listener});
	
			var f:int=indices.length;
			while (--f >= 0) {
				_delete(indices[f]);
			}
		}
	
		public function clear(event:String):Vector.<Function> {
			var indices:Vector.<int>=_find({event: event});
			var result:Vector.<Function>=new Vector.<Function>(indices.length, true);
	
			var f:int=indices.length;
			while (--f >= 0) {
				result[f]=_read(indices[f])["listener"];
				_delete(indices[f]);
			}
	
			return result;
		}
	
		public function get(event:String):Vector.<Function> {
			var indices:Vector.<int>=_find({event: event});
			var result:Vector.<Function>=new Vector.<Function>(indices.length, true);
	
			var f:int=indices.length;
			while (--f >= 0) {
				result[f]=_read(indices[f])["listener"];
			}
	
			return result;
		}
	
		public function all():Vector.<Evt> {
			var arr:Array=_getSource();
			var evts:Vector.<Evt>=new Vector.<Evt>(arr.length, true);
			var evt:Evt;
			var obj:Object;
	
			var f:int=arr.length;
			while (--f >= 0) {
				obj=arr[f];
				evt=new Evt;
				evt.type=obj["event"];
				evt.listener=obj["listener"];
				evts[f]=evt;
			}
	
			return evts;
		}
	}


