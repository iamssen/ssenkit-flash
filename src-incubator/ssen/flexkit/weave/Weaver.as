package ssen.flexkit.weave {
import flash.utils.Dictionary;

public class Weaver implements IWeaver {

	private var properties:Object;
	private var propertyWatchers:Callbacks;
	private var listeners:Callbacks;

	public function Weaver() {
		properties={};
		propertyWatchers=new Callbacks;
		listeners=new Callbacks;
	}

	//==========================================================================================
	// property management
	//==========================================================================================
	public function setProperty(name:String, value:*):void {
		properties[name]=value;

		var callbacks:Dictionary=propertyWatchers.getCallbacks(name);

		if (callbacks) {
			for (var callback:Function in callbacks) {
				callback(name, "write");
			}
		}
	}

	public function getProperty(name:String):* {
		return properties[name];
	}

	public function updatedLinkedProperty(name:String):void {
		var callbacks:Dictionary=propertyWatchers.getCallbacks(name);

		if (callbacks) {
			for (var callback:Function in callbacks) {
				callback(name, "update");
			}
		}
	}

	public function watchProperty(name:String, callback:Function):void {
		propertyWatchers.add(name, callback);
	}

	public function unwatchProperty(name:String, callback:Function):void {
		propertyWatchers.remove(name, callback);
	}

	//==========================================================================================
	// evnet management
	//==========================================================================================
	public function addListener(name:String, callback:Function):void {
		listeners.add(name, callback);
	}

	public function removeListener(name:String, callback:Function):void {
		listeners.remove(name, callback);
	}

	public function fire(name:String, ... properties):void {
		var callbacks:Dictionary=listeners.getCallbacks(name);

		if (callbacks) {
			for (var callback:Function in callbacks) {
				var args:Array=[name];
				callback.apply(null, args.concat(properties));
			}
		}
	}

	public function dispose():void {
		properties=null;
		propertyWatchers=null;
		listeners=null;
	}
}
}

import flash.utils.Dictionary;

class Callbacks {
	private var names:Dictionary=new Dictionary;
	private var count:Dictionary=new Dictionary;

	private function getName(name:String):Dictionary {
		if (names[name] === undefined) {
			names[name]=new Dictionary;
		}
		return names[name];
	}

	private function addCount(name:String):int {
		if (!count[name]) {
			count[name]=1;
		} else {
			count[name]+=1;
		}

		return count[name];
	}

	private function removeCount(name:String):int {
		if (count[name] === undefined) {
			throw new Error("Errror!!");
		} else {
			if (count[name] == 1) {
				delete count[name];
				return 0;
			} else if (count[name] > 1) {
				count[name]-=1;
				return count[name];
			} else {
				throw new Error("Err!!!");
			}
		}
	}

	public function add(name:String, callback:Function):void {
		var dic:Dictionary=getName(name);

		if (!dic[callback]) {
			dic[callback]=true;
			addCount(name);
		}
	}

	public function remove(name:String, callback:Function):void {
		if (!exists(name, callback)) {
			return;
		}

		var dic:Dictionary=getName(name);
		delete dic[callback];
		if (removeCount(name) === 0) {
			delete names[name];
		}
	}

	public function getCallbacks(name:String):Dictionary {
		return names[name];
	}

	public function exists(name:String, callback:Function):Boolean {
		return names[name] !== undefined && names[name][callback] !== undefined;
	}
}
