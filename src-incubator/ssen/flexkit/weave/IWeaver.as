package ssen.flexkit.weave {
import ssen.common.IDisposable;

public interface IWeaver extends IDisposable {
	function setProperty(name:String, value:*):void;
	function getProperty(name:String):*;
	function updatedLinkedProperty(name:String):void;
	function watchProperty(name:String, callback:Function):void;
	function unwatchProperty(name:String, callback:Function):void;
	function addListener(name:String, callback:Function):void;
	function removeListener(name:String, callback:Function):void;
	function fire(name:String, ... properties):void;
}
}
