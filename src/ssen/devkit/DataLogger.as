package ssen.devkit {
import flash.net.FileReference;
import flash.net.registerClassAlias;
import flash.utils.ByteArray;

public class DataLogger {
	private var store:Array;

	public function DataLogger() {
		registerClassAlias("ssen.devkit.DataLoggerVO", DataLoggerVO);
		store = [];
	}

	public function save(params:Object, value:Object):void {
		var keySize:int = 0;
		var keyFields:Array = [];
		var keyValues:Array = [];

		for (var key:String in params) {
			if (params.hasOwnProperty(key)) {
				keySize += 1;
				keyFields.push(key);
				keyValues.push(params[key]);
			}
		}

		var vo:DataLoggerVO = new DataLoggerVO;
		vo.keySize = keySize;
		vo.keyFields = keyFields;
		vo.keyValues = keyValues;
		vo.value = value;

		store.push(vo);
	}

	public function saveToFile():void {
		var bytes:ByteArray = new ByteArray;
		bytes.writeObject(store);

		var ref:FileReference = new FileReference;
		ref.save(bytes, "lpims.dlogger");
	}

	public function loadFromFile(bytes:ByteArray):void {
		store = bytes.readObject();
	}
}
}